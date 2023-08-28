#!/bin/bash

# Get absolute path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Navigate to piracer_py directory
if [[ "$SCRIPT_DIR" != */app/piracer_py ]]; then
    echo "Error: The script must be located in [PROJECT_DIR]/app/piracer_py"
    exit 1
fi

# check if virtual environment in this directory already exists
if [ ! -d "$SCRIPT_DIR/venv" ]; then
    echo "Virtual environment not found."
    # create a virtual envirement and install dependencies
    python3 -m venv venv
    # install dependencies
    pip install -r $SCRIPT_DIR/requirement.txt
fi
# Activate venv
source "$SCRIPT_DIR/venv/bin/activate"
#
# which python3
# run pun.py
sudo python3 run.py