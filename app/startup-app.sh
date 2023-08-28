#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "Startup Applications"

# run piracer_py main & monitor
chmod 755 $SCRIPT_DIR/piracer_py/startup_main.sh
$SCRIPT_DIR/piracer_py/startup_main.sh
#chmod 755 $SCRIPT_DIR/piracer_py/startup_monitor.sh
#$SCRIPT_DIR/piracer_py/startup_monitor.sh

# run (build) QT application
chmod 755 $SCRIPT_DIR/dashboard/build.sh
$SCRIPT_DIR/dashboard/build.sh