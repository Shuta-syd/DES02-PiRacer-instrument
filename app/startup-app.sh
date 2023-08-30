#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# run piracer_py main
chmod 755 $SCRIPT_DIR/piracer_py/startup_main.sh
$SCRIPT_DIR/piracer_py/startup_main.sh & 

sleep 5

# run piracer_py process monitor
chmod 755 $SCRIPT_DIR/piracer_py/startup_monitor.sh
$SCRIPT_DIR/piracer_py/startup_monitor.sh & 

sleep 5

# build QT application
chmod 755 $SCRIPT_DIR/dashboard/build.sh
$SCRIPT_DIR/dashboard/build.sh 

sleep 5

# start dashboard
#.$SCRIPT_DIR/dashboard/dashboard