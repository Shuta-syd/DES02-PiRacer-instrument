# !/bin/bash
echo "Building Dashboard"
./clean.sh
qmake dashboard.pro
make
./dashboard
