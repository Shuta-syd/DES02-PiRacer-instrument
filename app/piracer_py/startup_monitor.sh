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
    kill_all
    python3 $SCRIPT_DIR/main.py
}

# function to kill all piracer's processes.
function kill_all()
{
  echo " All processes killed " 
    sudo pkill -f "python3"
    sudo pkill -f "python3_main_process"
    sudo pkill -f "python3_car_info"
    sudo pkill -f "python3_car_control"
    sudo pkill -f "python3_recieve_data"
    sudo pkill -f "python3_send_data"
}

process_name="python3_main_process"

echo "Press q in bash to quit monitoring loop and kill all python processes"

# check if the process is alive
while true; do
  if [read -n 1 == "q"]; then 
    break
  fi 
  # if the main is not alive then restart it
  if ! pgrep -f $process_name; then
    #3echo "Process $process_name is not running."
    #restart_main
  fi
  sleep 3
done