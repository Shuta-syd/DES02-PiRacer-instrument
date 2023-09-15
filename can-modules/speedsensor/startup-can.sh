#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 0: Store Process id in pid.txt
sudo echo $$ >> $SCRIPT_DIR/../pid.txt

# Step 1 : Flash Arduino
# echo "Arduino flashed with can-modules/speedsensor code?"

# Step 2: Setup Can Interfaces
{
  sudo ip link set can0 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
  sudo ip link set can1 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
} &> /dev/null
echo "Can interface set up."