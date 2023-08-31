#!/bin/bash
DIR=$(pwd)

# startup Arduino
chmod 755 $DIR/can-modules/setup_can.sh
chmod 755 $DIR/piracer_py/startup_py.sh
chmod 755 $DIR/piracer_py/startup_monitor.sh
chmod 755 $DIR/dashboard/build.sh

$DIR/can-modules/setup_can.sh&
#$ARDUINO compile -b arduino:avr:nano:cpu=atmega328old rpm-calculator
#$ARDUINO upload -b arduino:avr:nano:cpu=atmega328old rpm-calculator -p /dev/ttyUSB0

# startup d-bus service & monitor
$DIR/app/piracer_py/startup_py.sh&
$DIR/app/piracer_py/startup_monitor.sh&

# startup to build application
$DIR/app/dashboard/build.sh&
