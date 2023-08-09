# get absolute path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# create virtual environment in this directory
python3 -m venv venv
# activate virtual environment
source "$SCRIPT_DIR/venv/bin/activate"
which python3
# install dependencies
pip install -r requirements.txt
