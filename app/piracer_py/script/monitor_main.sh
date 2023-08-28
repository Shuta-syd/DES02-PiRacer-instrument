#!/bin/bash
# please make sure you have to run as user called 'seame01'
process_name="python3_main_process"
process_path="/home/seame01/workspace/DES02-PiRacer-instrument/app/piracer_py/dbus/script/restart.sh"
inter=3
wait=3

while true; do
  isAliveProcess=$(ps -ef | grep "$process_name" |
                  grep -v grep | wc -l)

  if [ $isAliveProcess -eq 1 ]; then
    echo "o:${process_name} process"
  else
    echo "x:${process_name} process"
    /bin/bash $process_path &
  fi

  sleep $inter
done