##!/bin/bash

echo "Startup CAN Modules"

# Step 1 : Flash Arduino
# $ARDUINO compile -b arduino:avr:nano:cpu=atmega328old rpm-calculator
# $ARDUINO upload -b arduino:avr:nano:cpu=atmega328old rpm-calculator -p /dev/ttyUSB0

# Step 2: Setup Can Interfaces
sudo ip link set can0 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
echo "can0 interface set up."
sudo ip link set can1 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
echo "can1 interface set up."