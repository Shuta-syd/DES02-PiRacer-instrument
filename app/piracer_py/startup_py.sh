#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Navigate to piracer_py directory
if [[ "$SCRIPT_DIR" != */app/piracer_py ]]; then
    echo "Error: The script must be located in [PROJECT_DIR]/app/piracer_py"
    exit 1
fi
# Activate venv
python3 -m venv $SCRIPT_DIR/venv
source $SCRIPT_DIR/venv/bin/activate
echo "Installing dependencies..."
pip install -r $SCRIPT_DIR/requirements.txt &> /dev/null
echo "Installed dependencies"
echo "Starting main.py..."
python3 $SCRIPT_DIR/main.py
