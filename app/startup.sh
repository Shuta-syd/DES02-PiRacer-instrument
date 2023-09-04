#!/bin/bash
export DIR=$(pwd)
export PARENT_DIR="$(cd .. && pwd)"

echo $DIR | systemd-cat -t test-log
echo $PARENT_DIR | systemd-cat -t test-log

cd $DIR

# startup Arduino
chmod 755 $PARENT_DIR/can-modules/setup_can.sh
chmod 755 $DIR/piracer_py/startup_py.sh
chmod 755 $DIR/piracer_py/startup_monitor.sh
chmod 755 $DIR/dashboard/build.sh


bash $PARENT_DIR/can-modules/setup_can.sh&
# #$ARDUINO compile -b arduino:avr:nano:cpu=atmega328old rpm-calculator
# #$ARDUINO upload -b arduino:avr:nano:cpu=atmega328old rpm-calculator -p /dev/ttyUSB0

# startup d-bus service & monitor
bash $DIR/piracer_py/startup_py.sh&

# wait until python3_main_process appears
while ! pgrep -f python3_main_process ; do
  loading_chars="/-\|"
  for ((i=0; i<${#loading_chars}; i++)); do
    echo -ne "Waiting for main_python process..... ${loading_chars:$i:1}" "\r"
    sleep 1
  done
done

echo "Waiting for main_python process..... Done"


bash $DIR/piracer_py/startup_monitor.sh&

# startup to build application
cd $DIR/dashboard
./build.sh
