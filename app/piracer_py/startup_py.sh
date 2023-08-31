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
pip install -r $SCRIPT_DIR/requirements.txt
python $SCRIPT_DIR/main.py
