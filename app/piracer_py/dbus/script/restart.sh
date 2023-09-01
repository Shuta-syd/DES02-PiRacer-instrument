#!/bin/bash
DIR="$(pwd)"

sudo pkill -f "python3"
source $DIR/piracer_py/venv/bin/activate
python3 $DIR/piracer_py/main.py
