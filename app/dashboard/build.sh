# !/bin/bash
echo "Building Dashboard ..."

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# delete old build files
$SCRIPT_DIR/clean.sh

# Build qmake Application
#{
    qmake $SCRIPT_DIR/dashboard.pro
    make
#}&> /dev/null

$SCRIPT_DIR/dashboard

# if [xrandr | grep "DSI-1 connected"]; then
#     # Wenn der Bildschirm angeschlossen ist, öffnen dashboard im Vollbildmodus
#     echo "DSI-1 connected."
#     # öffne auf dem Bildschirm DSI-1
#     DISPLAY=:1.0 $SCRIPT_DIR/dashboard --fullscreen
# else
#     echo "DSI-1 not connected."
#     $SCRIPT_DIR/dashboard
# fi