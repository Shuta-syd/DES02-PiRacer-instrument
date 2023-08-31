#!/bin/bash

#get the path of the script
SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
#ARDUINO = $SCRIPT_PATH/rpm-caluclator

# Step 1 : Flash Arduino
echo "Make sure that the Can Module (Arduino) is flashed correctly."

# Step 2: Setup Can Interfaces
echo "Setting up can interface ..."
{
  sudo ip link set can0 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
  sudo ip link set can1 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
} &> /dev/null
echo "Can interface set up."