#!/bin/bash
PROCESS_NAME="python3_main_process"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
RESTART_SCRIPT="$SCRIPT_DIR/restart.sh"
inter=3
wait=3

while true; do
  isAliveProcess=$(ps -ef | grep "$PROCESS_NAME" |
                  grep -v grep | wc -l)

  if [ $isAliveProcess -eq 0 ]; then
    echo "x:${PROCESS_NAME} process"
    /bin/bash $RESTART_SCRIPT &
  fi

  sleep $inter
done
