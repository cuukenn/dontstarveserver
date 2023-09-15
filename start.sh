#!/bin/bash
#author cuukenn

bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${bin}/config/config.properties

dst_log_path=$bin/$DST_LOG_PATH
mkdir -p $dst_log_path
sh scripts/dst-start.sh Master ${DST_CLUSTER_NAME} >>$dst_log_path/Master_${DST_CLUSTER_NAME}.log 2>&1
if [ $? -ne 0 ]; then
    echo "Dstserver(Master,$DST_CLUSTER_NAME) is running, no more instance to start"
    exit 1
fi
echo "Dstserver(Master,$DST_CLUSTER_NAME) is starting, service will be ready in several time..."
if [ $DST_CAVES_ENABLE -eq 1 ]; then
    sh scripts/dst-start.sh Caves ${DST_CLUSTER_NAME} >>$dst_log_path/Caves_${DST_CLUSTER_NAME}.log 2>&1
    if [ $? -ne 0 ]; then
        echo "Dstserver(Caves,$DST_CLUSTER_NAME) is running, no more instance to start"
        exit 1
    fi
    echo "Dstserver(Caves,$DST_CLUSTER_NAME) is starting, service will be ready in several time..."
fi
