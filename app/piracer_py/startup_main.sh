# #!/bin/bash

# echo "Startup piracer_py main"

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
pip install -r "$PROJECT_DIR/requirements.txt"

# Run main.py
python "$PROJECT_DIR/main.py"