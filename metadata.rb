name             "youtrack"
maintainer       "Vyacheslav Slinko"
maintainer_email "vyacheslav.slinko@gmail.com"
license          "MIT"
description      "Installs YouTrack Issue Tracker from JetBrains"
version          "0.0.0"

recipe "youtrack", "Install and start YouTrack instance"

%w{ bluepill java }.each do |cb|
  depends cb
end
