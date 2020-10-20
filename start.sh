#!/bin/bash
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR
nohup ./start_master.sh  >/dev/null 2>&1 &
nohup ./start_cave.sh    >/dev/null 2>&1 &
