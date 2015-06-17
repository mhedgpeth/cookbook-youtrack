# Description

Installs YouTrack Issue Tracker from JetBrains.

# Requirements

## Cookbooks

* bluepill
* java

# Attributes

* `node["youtrack"]["version"]` - YouTrack version. Default is `4.2`.
* `node["youtrack"]["dir"]` - Location of YouTrack installation. Default is
  `/opt/YouTrack-4.2`
* `node["youtrack"]["memory"]` - Memory used by JVM. Default is `384m`.
* `node["youtrack"]["port"]` — Port for listening. Default is `8112`.
* `node["youtrack"]["database_directory"]` - Location of YouTrack database. Default is `<YouTrack installation folder>\teamsysdata`.
* `node["youtrack"]["user"]` - user to run YouTrack as. Default is `youtrack`.

# History
Version 0.0.1 contains the following improvements:

* YouTrack runs as non-root user.
* Port redirection for CentOS 7. By default port 80 is redirected to 8112.
* Changed default version of YouTrack to 6.0.12634
* Changed default installation path to /opt/youtrack
* Changed default memory settings.



