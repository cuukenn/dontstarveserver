#!/bin/bash
#author cuukenn

#循环检测进程是否结束
wait_process_exit() {
    local remain_sleep=$1
    local each_sleep=$2
    for pid in $pids; do
        while kill -0 ${pid} >/dev/null 2>&1; do
            if [ $remain_sleep -le 0 ]; then
                return 1
            fi
            echo "Process Still running, waitting ${each_sleep}s to recheck, remain timeout is ${remain_sleep}s..."
            sleep $each_sleep
            ((remain_sleep -= $each_sleep))
        done
    done
    return 0
}

cd $(dirname $0)
bin=$(pwd)
source config/config.properties
cd ~/$DST_SCRIPT_PATH
sh stop.sh
pids=($(cat .lastpid | awk '{print $1}'))
echo "Waiting for process exit..."
wait_process_exit 60 5
if [ $? -ne 0 ]; then
    echo "Stop process timeout, try to stop process forcely......"
    sh stop.sh 9
    echo "Waiting for process exit forcely......"
    wait_process_exit 60 5
    echo "Process exited"
fi
update=${1:-0}
if [ $update -eq 1 ]; then
    echo "Start update dst-server..."
    sh scripts/setup-dst.sh $STEAMCMD_PATH $DST_SCRIPT_PATH $DST_SERVER_PATH $DST_GAME_ID
fi
sh start.sh
