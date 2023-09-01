#!/bin/bash

# Get absolut path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to piracer_py directory
if [[ "$SCRIPT_DIR" != */app/piracer_py ]]; then
    echo "Error: The script must be located in [PROJECT_DIR]/app/piracer_py"
    exit 1
fi

# function to restart the process
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

# monitor the main_process
PROCESS_NAME="python3_main_process"
while true; do
  isAliveProcess=$(ps -ef | grep "$PROCESS_NAME" |
                  grep -v grep | wc -l)

  if [ $isAliveProcess -eq 0 ]; then
    echo "x:${PROCESS_NAME} process"
    restart_main
  fi
  sleep 5
done


