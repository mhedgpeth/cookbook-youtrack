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
