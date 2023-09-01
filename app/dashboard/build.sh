#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Building Dashboard ..."
qmake $SCRIPT_DIR/dashboard.pro
make

echo "Build done."

$SCRIPT_DIR/dashboard
