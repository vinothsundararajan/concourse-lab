#!/bin/sh
set -xe 
echo  -e "INFO: This script to execute maven build , compile and package  process by $1"
sleep 5
if [ $? -eq 0 ]; then
  echo -e "INFO: Maven clean process just begins.."
  disk_usage=$(df -hT /)
  ls -l 
  echo  -e "INFO: maven building in $(hostname) container at $(pwd)"
  mvn clean
  if [ "$?" -eq 0 ]; then
    mvn install ; 
    if [ "$?" -eq 0 ]; then
      echo  -e "INFO: Maven clean and install successfully."
      mvn package ;
      cp target/my-app-*.jar ../concourse-app-output/my-app.jar
    fi
  fi
fi
sleep 5