#!/bin/bash
# create virtual environment in this directory
python3 -m venv venv
# activate virtual environment
source venv/bin/activate
# install dependencies
pip install -r requirements.txt
