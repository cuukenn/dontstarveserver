#!/bin/bash
#author changgg
set -e
~/common/dstserver/bin/stop.sh
sleep 5 
~/update_starve.sh
~/common/dstserver/bin/start.sh
