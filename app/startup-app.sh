#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Step1: Run piracer_py main
chmod 755 $SCRIPT_DIR/piracer_py/startup_main.sh
$SCRIPT_DIR/piracer_py/startup_main.sh & 

sleep 5

# Step2: Run piracer_py Process Monitor
chmod 755 $SCRIPT_DIR/piracer_py/startup_monitor.sh
$SCRIPT_DIR/piracer_py/startup_monitor.sh & 

sleep 5

# Step3: Build & Run QT Dashboard Application
chmod 755 $SCRIPT_DIR/dashboard/build.sh
cd $SCRIPT_DIR/dashboard
./build.sh 