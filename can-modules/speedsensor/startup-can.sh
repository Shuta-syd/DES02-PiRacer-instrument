##!/bin/bash

# Step 1 : Flash Arduino
echo "Flashing Arduino ..."
{
  cd /home/pi/Arduino/speedsensor
  arduino-cli compile --fqbn arduino:avr:uno .
  arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno .
  # $ARDUINO compile -b arduino:avr:nano:cpu=atmega328old rpm-calculator
  # $ARDUINO upload -b arduino:avr:nano:cpu=atmega328old rpm-calculator -p /dev/ttyUSB0
} &> /dev/null
echo "Arduino flashed."

# Step 2: Setup Can Interfaces
echo "Setting up can interface ..."
{
  sudo ip link set can0 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
  #sudo ip link set can1 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
} &> /dev/null
echo "can interface set up."