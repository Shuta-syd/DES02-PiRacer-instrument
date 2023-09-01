#!/bin/bash

# Define the folder and virtual environment name
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VENV_NAME="venv"

# Check if the virtual environment exists
if [ ! -d "$PROJECT_DIR/$VENV_NAME" ]; then
    echo "Creating a new virtual environment..."
    python3 -m venv "$PROJECT_DIR/$VENV_NAME"
fi

# Activate the virtual environment
source "$PROJECT_DIR/$VENV_NAME/bin/activate"

# Install dependencies
pip install -r "$PROJECT_DIR/requirements.txt" &> /dev/null
echo "Python Dependencies installed."

sudo pkill -f "python3"
sudo pkill -f "python3_main_process"
sudo pkill -f "python3_car_info"
sudo pkill -f "python3_car_control"
sudo pkill -f "python3_recieve_data"
sudo pkill -f "python3_send_data"

# Run main.py
python "$PROJECT_DIR/main.py"