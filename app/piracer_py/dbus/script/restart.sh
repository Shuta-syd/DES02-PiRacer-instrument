#!/bin/bash
sudo pkill -f "python3"
source /home/seame01/workspace/DES02-PiRacer-instrument/app/piracer_py/venv/bin/activate
python3 /home/seame01/workspace/DES02-PiRacer-instrument/app/piracer_py/main.py
