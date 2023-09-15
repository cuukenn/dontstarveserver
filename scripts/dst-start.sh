#!/bin/bash
#author cuukenn

run_server() {
    echo $$ >$lock_file
    ./dontstarve_dedicated_server_nullrenderer -console -cluster $cluster_name -shard $server_type
    rm -rf $lock_file
}

cd $(dirname $0)/../
bin=$(pwd)
source config/config.properties

server_type=$1
cluster_name=${2:-Cluster_1}
dst_server_bin=~/$DST_SERVER_PATH/bin
cd ${dst_server_bin}
export SteamAppId=$DST_GAME_ID
export SteamGameId=$DST_GAME_ID
mkdir -p $DST_RUN_PATH
lock_file=$DST_RUN_PATH/${server_type}_${cluster_name}.lock
if [ -f $lock_file ]; then
    exit 1
fi
nohup $(run_server) >/dev/null 2>&1 &
