#!/bin/bash
#author cuukenn
set -e

bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${bin}/config/config.properties

dst_log_path=$bin/$DST_LOG_PATH
mkdir -p $dst_log_path
dst_server_bin=/home/$STEAMCMD_USERNAME/$DST_SERVER_PATH/bin
nohup scripts/dst-start.sh $dst_server_bin $DST_GAME_ID Master ${DST_CLUSTER_NAME} >>$dst_log_path/Master.log 2>&1 &
if [ $DST_CAVES_ENABLE -eq 1 ]; then
    nohup scripts/dst-start.sh $dst_server_bin $DST_GAME_ID Caves ${DST_CLUSTER_NAME} >>$dst_log_path/Caves.log 2>&1 &
fi
