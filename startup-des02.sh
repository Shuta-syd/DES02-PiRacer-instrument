#!/bin/bash

echo "Startup DES02 Piracer Instrument"

#get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Start CAN Modules
chmod 755 $SCRIPT_DIR/can-modules/speedsensor/startup-can.sh
$SCRIPT_DIR/can-modules/speedsensor/startup-can.sh

# Step 2: Start Applications
chmod 755 $SCRIPT_DIR/app/startup-app.sh
$SCRIPT_DIR/app/startup-app.sh
