#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step0: Store process id in text file
sudo echo $$ >> $SCRIPT_DIR/../../pid.txt

# Step1: Monitor the main_process & Restart if needed.
function restart_main()
{
  sudo pkill -f "python3"
  sudo pkill -f "python3_main_process"
  sudo pkill -f "python3_car_info"
  sudo pkill -f "python3_car_control"
  sudo pkill -f "python3_recieve_data"
  sudo pkill -f "python3_send_data"
  python3 $SCRIPT_DIR/main.py
}

PROCESS_NAME="python3_main_process"

while true; do
  isAliveProcess=$(ps -ef | grep "$PROCESS_NAME" | grep -v grep | wc -l)
  if [ $isAliveProcess -eq 0 ]; then
    echo "${PROCESS_NAME} not alive. Restart."
    restart_main
  fi
  sleep 5
done


