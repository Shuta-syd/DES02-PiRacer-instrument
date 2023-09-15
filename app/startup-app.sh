#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 0: Store process id in text file
sudo echo $$ >> $SCRIPT_DIR/../pid.txt

# Step1: Kill processes
sudo pkill -f "python3"
sudo pkill -f "python3_main_process"
sudo pkill -f "python3_car_info"
sudo pkill -f "python3_car_control"
sudo pkill -f "python3_recieve_data"
sudo pkill -f "python3_send_data"

sleep 5

# Step2: Run piracer_py main
chmod 755 $SCRIPT_DIR/piracer_py/startup_main.sh
$SCRIPT_DIR/piracer_py/startup_main.sh & 

# Step3: Block until python3_main_process appears
while [! pgrep -f python3_main_process]&> /dev/null ; do
  loading_chars="/-\|"
  for ((i=0; i<${#loading_chars}; i++)); do
    echo -ne "Starting Python3_main_python process... ${loading_chars:$i:1}" "\r"
    sleep 1
  done
done
echo "Starting Python3_main_python process... Running."

sleep 5

# Step4: Run piracer_py Process Monitor
chmod 755 $SCRIPT_DIR/piracer_py/startup_monitor.sh
$SCRIPT_DIR/piracer_py/startup_monitor.sh & 

sleep 5

# Step3: Build & Run QT Dashboard Application
chmod 755 $SCRIPT_DIR/dashboard/build.sh
cd $SCRIPT_DIR/dashboard
./build.sh 