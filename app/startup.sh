#!/bin/bash
DIR = /home/seame01/workspace/DES02-PiRacer-instrument

source $DIR/venv/bin/activate
python $DIR/app/piracer_py/main.py

# startup d-bus service & monitor
./$DIR/app/piracer_py/startup_main.sh&
./$DIR/app/piracer_py/startup_monitor.sh&

# startup to build application
./$DIR/app/dashboard/build.sh&
./$DIR/app/dashboard/clean.sh&
