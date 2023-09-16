#!/bin/bash

clear 

sudo echo "Startup DES02 Piracer Instrument"

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 0: Kill all processes that are written in pid.txt
{
if [ -f "$SCRIPT_DIR/pid.txt" ]; then
  while read line; do
    sudo kill -9 $line
  done < $SCRIPT_DIR/pid.txt
fi
} &> /dev/null

# Step 1: Kill python processes from privious run
sudo pkill -f "python3"
sudo pkill -f "python3_main_process"
sudo pkill -f "python3_car_info"
sudo pkill -f "python3_car_control"
sudo pkill -f "python3_recieve_data"
sudo pkill -f "python3_send_data"
# wait for 10 seconds. The tcp servers loopback needs some time to be availible again.
sleep 10

# Step 2: Store process id in text file
echo $$ > "$SCRIPT_DIR/pid.txt"

# Step 3: Start CAN Modules
chmod 755 $SCRIPT_DIR/can-modules/speedsensor/startup-can.sh
$SCRIPT_DIR/can-modules/speedsensor/startup-can.sh

# Step 4: Start Applications
chmod 755 $SCRIPT_DIR/app/startup-app.sh
$SCRIPT_DIR/app/startup-app.sh
