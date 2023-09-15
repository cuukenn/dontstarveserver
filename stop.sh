#!/bin/bash
#author cuukenn

cd $(dirname $0)
bin=$(pwd)
source config/config.properties

cat /dev/null >.lastpid
sh scripts/dst-stop.sh Master $DST_CLUSTER_NAME
sh scripts/dst-stop.sh Caves $DST_CLUSTER_NAME
