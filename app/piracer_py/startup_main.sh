#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 0: Store process id in text file
sudo echo $$ >> $SCRIPT_DIR/../../pid.txt

# Check if the virtual environment exists
VENV_NAME="venv"
if [ ! -d "$SCRIPT_DIR/$VENV_NAME" ]; then
    echo "Creating a new virtual environment..."
    python3 -m venv "$SCRIPT_DIR/$VENV_NAME"
fi

# Activate the virtual environment
source "$SCRIPT_DIR/$VENV_NAME/bin/activate"

# Install dependencies
pip install -r "$SCRIPT_DIR/requirements.txt" &> /dev/null
echo "Python Dependencies installed."

# kill all python processes
sudo pkill -f "python3"
sudo pkill -f "python3_main_process"
sudo pkill -f "python3_car_info"
sudo pkill -f "python3_car_control"
sudo pkill -f "python3_recieve_data"
sudo pkill -f "python3_send_data"

sleep 3

# Run main.py
python "$SCRIPT_DIR/main.py"