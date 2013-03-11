include_recipe "bluepill"
include_recipe "java"

bin_dir = "#{node["youtrack"]["dir"]}/bin"
log_dir = "#{node["youtrack"]["dir"]}/logs"

jar_name = "youtrack-#{node["youtrack"]["version"]}.jar"
jar_link = "http://download.jetbrains.com/charisma/#{jar_name}"
jar_file = "#{bin_dir}/#{jar_name}"

script_file = "#{bin_dir}/start.sh"
pid_file    = "#{log_dir}/youtrack.pid"

output_log_file = "#{log_dir}/output.log"
error_log_file  = "#{log_dir}/error.log"

directory node["youtrack"]["dir"]
directory bin_dir
directory log_dir

remote_file jar_file do
  backup false
  source jar_link
  action :create_if_missing
end

template script_file do
  mode 0755
  source "start.sh.erb"
  variables(
    :memory          => node["youtrack"]["memory"],
    :jar_file        => jar_file,
    :port            => node["youtrack"]["port"],
    :output_log_file => output_log_file,
    :error_log_file  => error_log_file,
    :pid_file        => pid_file
  )
end

template "#{node["bluepill"]["conf_dir"]}/youtrack.pill" do
  source "youtrack.pill.erb"
  variables(
    :script_file => script_file,
    :pid_file    => pid_file
  )
end

bluepill_service "youtrack" do
  action [:enable, :load, :start]
end
