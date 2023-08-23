#!/bin/bash
sudo pkill -f "python3"
source /home/seame01/workspace/DES02-PiRacer-instrument/app/venv/bin/activate
python3 /home/seame01/workspace/DES02-PiRacer-instrument/app/d-bus/main.py
