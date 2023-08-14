# !/bin/bash
./clean.sh
qmake dashboard.pro
make
cd dashboard.app
open .
