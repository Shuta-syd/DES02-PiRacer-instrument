#!/bin/bash

# Get absolut path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to piracer_py directory
if [[ "$SCRIPT_DIR" != */app/piracer_py ]]; then
    echo "Error: The script must be located in [PROJECT_DIR]/app/piracer_py"
    exit 1
fi

# monitoring the main process
process_name="python3_main_process"

# function to restart the process
function restart()
{
    # kill a python processes by pattern
    sudo pkill -f "python3_main_process"

    #start main.py (again)
    #python3 main.py
    ./startup_main.sh
}

# this is a trap for ctrl + c 
trap ctrl_c INT
function ctrl_c() {
    echo "Stop monitoring."
    exit 1
}

# check if the process is alive
while true; do
  isAliveProcess = $(ps -ef | grep "$process_name" | grep -v grep | wc -l)
  if [ $isAliveProcess -eq 0 ]; then
    echo "${process_name} off. Process restart."
    restart 
  fi
  sleep 3
done