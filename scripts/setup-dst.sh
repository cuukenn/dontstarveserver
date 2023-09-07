#!/bin/bash
#author cuukenn
set -e

dst_path=~/$3
mkdir -p $dst_path
dst_path=$(
    cd "${dst_path}"
    pwd
)
cmd_path=$2/config
#设置steamcmd命令
echo "force_install_dir ${dst_path}" >~/${cmd_path}/update_starve.cmd
echo "login anonymous" >>~/${cmd_path}/update_starve.cmd
echo "app_update $4 validate" >>~/${cmd_path}/update_starve.cmd
echo "quit" >>~/${cmd_path}/update_starve.cmd
#执行steamcmd
~/$1/steamcmd.sh <~/$cmd_path/update_starve.cmd
#解决lib缺失
cd $dst_path/bin/lib32
lib_file=libcurl-gnutls.so.4
if [ ! -L $lib_file ] && [ ! -f $lib_file ]; then
    ln -s /usr/lib/libcurl.so.4 $lib_file
fi
#写入cron表达式
echo "0 3 * * * $(
    cd ~/${STEAMCMD_USERNAME}/$2
    pwd
)/update.sh" >~/${cmd_path}/cron.cmd
