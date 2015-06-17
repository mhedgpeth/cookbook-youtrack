include_recipe 'bluepill'
include_recipe 'java'

bin_dir = "#{node['youtrack']['dir']}/bin"
log_dir = "#{node['youtrack']['dir']}/logs"

jar_name = "youtrack-#{node["youtrack"]["version"]}.jar"
jar_link = "http://download.jetbrains.com/charisma/#{jar_name}"
jar_file = "#{bin_dir}/#{jar_name}"

script_file = "#{bin_dir}/start.sh"
pid_file    = "#{log_dir}/youtrack.pid"

output_log_file = "#{log_dir}/output.log"
error_log_file  = "#{log_dir}/error.log"

directory node['youtrack']['dir']
directory bin_dir
directory log_dir

remote_file jar_file do
  backup false
  source jar_link
  action :create_if_missing
end

database_directory = node['youtrack']['database_directory']

directory database_directory

template script_file do
  mode 0755
  source "start.sh.erb"
  variables(
    :memory          => node['youtrack']['memory'],
    :jar_file        => jar_file,
    :port            => node['youtrack']['port'],
    :output_log_file => output_log_file,
    :error_log_file  => error_log_file,
    :pid_file        => pid_file,
	  :database_location => database_directory,
    :max_perm_size => node['youtrack']['max_perm_size']
  )
end

template "#{node["bluepill"]["conf_dir"]}/youtrack.pill" do
  source 'youtrack.pill.erb'
  variables(
    :script_file => script_file,
    :pid_file    => pid_file
  )
end

bluepill_service 'youtrack' do
  action [:enable, :load, :start]
end

# adding user to run YouTrack
user 'youtrack' do
  supports :manage_home => true
  comment 'YouTrack user'
  gid 'users'
  home "#{node["youtrack"]["dir"]}"
  shell '/bin/bash'
  not_if "grep #{node["youtrack"]["user"]} /etc/passwd"
end

# changing folder rights
execute 'change permissions' do
    command "chown -R #{node["youtrack"]["user"]}:users #{node["youtrack"]["dir"]}"
    user 'root'
    not_if "stat -c %U #{node["youtrack"]["dir"]} | grep #{node["youtrack"]["user"]}"
    action :run
end

# setting up port forwarding (CentOS 7 specific)
if (node[:platform] == 'centos' && node['platform_version'].start_with?('7.'))
  execute 'setup port forwarding' do
      command "firewall-cmd --set-default-zone=public && firewall-cmd --zone=public --add-masquerade && firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=#{node["youtrack"]["port"]}"
      user 'root'
      not_if "firewall-cmd --list-forward-ports | grep #{node["youtrack"]["port"]}"
      action :run
  end
end
