#!/bin/bash
#author cuukenn

cd $(dirname $0)/../
bin=$(pwd)
source config/config.properties

server_type=$1
cluster_name=${2:-Cluster_1}

pid=($(ps aux | grep -i dontstarve | grep -i ${server_type} | grep -i ${cluster_name} | grep -v grep | awk '{print $2}'))
if [ -z ${pid} ]; then
    echo "No dstserver($server_type,$cluster_name) is running, skip"
    exit 1
fi
signal=${3:-5}
#正常停止
echo "The dstserver($server_type,$cluster_name) is running..."
kill -${signal} ${pid} >/dev/null 2>&1
echo "Sending shutdown signal(${signal}) to dstserver(${pid}) ok"
echo $pid >>.lastpid
