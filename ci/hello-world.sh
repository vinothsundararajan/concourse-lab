#!/bin/sh
echo "This script to do some basic concourse pipeline and tasks."
sleep 10
if [ $? -eq 0 ]; then
  echo -e "Rest for 10 seconds.."
  disk_usage=$(df -hT /)
  echo -e "Root disk usage ${disk_usage},$1"
  sleep 10
fi