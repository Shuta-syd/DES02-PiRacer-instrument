# !/bin/bash
echo "Building Dashboard ..."

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# delete old build files
.$SCRIPT_DIR/clean.sh

# build qmake application
qmake dashboard.pro
make

echo "Build done."

# start build
./dashboard
