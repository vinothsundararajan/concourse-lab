#!/bin/sh
set -xe 
echo "This script to execute maven build , compile and package  process by $1"
sleep 5
if [ $? -eq 0 ]; then
  echo -e "Maven clean process just begins.."
  disk_usage=$(df -hT /)
  ls -l 
  pwd && echo $(hostname)
  cd ..
  mvn clean
  if [ "$?" -eq 0 ]; then
    mvn install ; 
    if [ "$?" -eq 0 ]; then
      echo "Maven clean and install successfully."
      mvn package ;
      cp target/my-app-*.jar ../app-output/my-app.jar
    fi
  fi
  cd -
fi
sleep 5