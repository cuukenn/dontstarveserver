#!/bin/bash
#author changgg
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR
export SteamAppId=322330
export SteamGameId=322330
./dontstarve_dedicated_server_nullrenderer -console -cluster Cluster_1 -shard Caves
