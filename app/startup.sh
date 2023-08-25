#!/bin/bash
DIR=/home/seame01/workspace/DES02-PiRacer-instrument
ARDUINO=/home/seame01/bin/arduino-cli

# startup Arduino
$DIR/can-modules/setup_can.sh&
#$ARDUINO compile -b arduino:avr:nano:cpu=atmega328old rpm-calculator
#$ARDUINO upload -b arduino:avr:nano:cpu=atmega328old rpm-calculator -p /dev/ttyUSB0

# startup d-bus service & monitor
$DIR/app/piracer_py/startup_main.sh&
$DIR/app/piracer_py/startup_monitor.sh&

# startup to build application
$DIR/app/dashboard/build.sh&
