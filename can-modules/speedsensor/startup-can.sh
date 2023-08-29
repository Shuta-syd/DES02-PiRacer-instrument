##!/bin/bash

#echo "Startup CAN Modules"

# Step 1 : Flash Arduino
# $ARDUINO compile -b arduino:avr:nano:cpu=atmega328old rpm-calculator
# $ARDUINO upload -b arduino:avr:nano:cpu=atmega328old rpm-calculator -p /dev/ttyUSB0

# Step 2: Setup Can Interfaces
echo "Setting up can interface ..."
{
  sudo ip link set can0 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
  #sudo ip link set can1 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
} &> /dev/null
echo "can interface set up."