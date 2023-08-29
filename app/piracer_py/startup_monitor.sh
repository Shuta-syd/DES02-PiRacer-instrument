#!/bin/bash

# Get absolut path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to piracer_py directory
if [[ "$SCRIPT_DIR" != */app/piracer_py ]]; then
    echo "Error: The script must be located in [PROJECT_DIR]/app/piracer_py"
    exit 1
fi

function restart()
{
    # kill a python processes by pattern
    sudo pkill -f "python3_main_process"
    sudo pkill -f "python3_car_info"
    sudo pkill -f "python3_car_control"
    sudo pkill -f "python3_recieve_data"
    sudo pkill -f "python3_send_data"

    # kill by pgrep (saver)
    # sudo kill $(pgrep -f 'python main.py')
    # sudo kill $(pgrep -f '/process/car_control.py')
    # sudo kill $(pgrep -f '/process/car_control.py')
    # sudo kill $(pgrep -f '/process/recieve_data.py')
    # sudo kill $(pgrep -f '/process/send_data.py')

    #start main.py (again)
    python3 main.py
    #./startup_main.sh
}

# monitoring the main process
process_name="python3_main_process"

# this is a trap for ctrl + c 
function ctrl_c()
{
  exit 0
}
trap ctrl_c INT

while true; do
  isAliveProcess=$(ps -ef | grep "$process_name" |
                  grep -v grep | wc -l)

  if [ $isAliveProcess -eq 0 ]; then
    echo "${process_name} off. Process restart."
    restart 
  fi
  sleep 3
done


