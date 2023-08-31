#!/bin/bash
DIR=$(pwd)
PARENT_DIR="$(cd .. && pwd)"
cd $DIR

# startup Arduino
chmod 755 $PARENT_DIR/can-modules/setup_can.sh
chmod 755 $DIR/piracer_py/startup_py.sh
chmod 755 $DIR/piracer_py/startup_monitor.sh
chmod 755 $DIR/dashboard/build.sh


$PARENT_DIR/can-modules/setup_can.sh&
# #$ARDUINO compile -b arduino:avr:nano:cpu=atmega328old rpm-calculator
# #$ARDUINO upload -b arduino:avr:nano:cpu=atmega328old rpm-calculator -p /dev/ttyUSB0

# # startup d-bus service & monitor
$DIR/piracer_py/startup_py.sh&

# wait until python3_main_process appears
while ! pgrep -f python3_main_process ; do
  echo "Waiting for main_python process..."
  sleep 1
done

$DIR/piracer_py/startup_monitor.sh&

# # startup to build application
$DIR/dashboard/build.sh&
