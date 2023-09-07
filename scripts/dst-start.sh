#!/bin/bash
#author cuukenn
set -e

bin=$1
cd $bin
export SteamAppId=$2
export SteamGameId=$2
./dontstarve_dedicated_server_nullrenderer -console -cluster ${4:-Cluster_1} -shard $3
