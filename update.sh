#!/bin/bash
#author cuukenn
set -e

bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${bin}/config/config.propertie

su - ${STEAMCMD_USERNAME} -c "~/$DST_SCRIPT_PATH/stop.sh"
sleep 5
su - ${STEAMCMD_USERNAME} -c "~/$DST_SCRIPT_PATH/scripts/setup-dst.sh $STEAMCMD_PATH $DST_SCRIPT_PATH $DST_SERVER_PATH $DST_GAME_ID"
su - ${STEAMCMD_USERNAME} -c "~/$DST_SCRIPT_PATH/start.sh"
