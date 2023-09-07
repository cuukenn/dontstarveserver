#!/bin/bash
#author cuukenn
set -e

bin=$(dirname "$0")
bin=$(
    cd "${bin}"
    pwd
)

#加载配置文件
setup_config() {
    local config_path=${bin}/config
    echo "当前路径:$0, 配置文件路径: ${config_path}"
    source ${config_path}/config.properties
    echo "当前配置文件列表："
    cat ${config_path}/config.properties
    read -p "是否确认各项配置信息(Y/N)？" confirm
    if [[ "${confirm}" = *"y"* ]]; then
        echo "------------------------------------"
    else
        echo "请在确认配置调整完成后后重新执行！！！"
        exit -1
    fi
}

#检测系统类型
check_system() {
    if [[ -n $(find /etc -name "redhat-release") ]] || grep </proc/version -q -i "centos"; then
        release="centos"
    elif grep </etc/issue -q -i "debian" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "debian" && [[ -f "/proc/version" ]]; then
        release="debian"
    elif grep </etc/issue -q -i "ubuntu" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "ubuntu" && [[ -f "/proc/version" ]]; then
        release="ubuntu"
    fi
    if [[ -z ${release} ]]; then
        echo "其他系统，暂时不支持"
        exit -1
    fi
}

#初始化系统环境
setup_sys_env() {
    check_system
    local script="scripts/setup-sys-${release}_$(getconf LONG_BIT).sh"
    if [ -f $script ]; then
        $script
    else
        echo "暂不支持该系统，直接退出"
        exit -1
    fi
}

#创建专用用户
setup_user() {
    if id ${STEAMCMD_USERNAME} >/dev/null 2>&1; then
        echo "用户已经存在，跳过创建，执行剩余步骤"
    else
        useradd ${STEAMCMD_USERNAME}
        echo "请输入${STEAMCMD_USERNAME}的用户密码："
        passwd ${STEAMCMD_USERNAME}
        echo "创建${STEAMCMD_USERNAME}成功"
    fi
}

#初始化steamcmd
setup_steamcmd() {
    su - ${STEAMCMD_USERNAME} -c "
  mkdir -p ~/${STEAMCMD_PATH} \
  && cd ~/${STEAMCMD_PATH} \
  && wget -P ~/${STEAMCMD_PATH} https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
  && tar -xvzf ~/${STEAMCMD_PATH}/steamcmd_linux.tar.gz
  "
}

#拷贝脚本到指定目录
setup_scripts() {
    local targetPath=/home/${STEAMCMD_USERNAME}/${DST_SCRIPT_PATH}
    su - ${STEAMCMD_USERNAME} -c "mkdir -p ${targetPath}"
    cp -r ./* ${targetPath}
    find ${targetPath} -name \*.sh -print | xargs -n 1 chmod u+x
    chown -R ${STEAMCMD_USERNAME} ${targetPath}
}

setup_dstserver() {
    su - ${STEAMCMD_USERNAME} -c "~/$DST_SCRIPT_PATH/scripts/setup-dst.sh $STEAMCMD_PATH $DST_SCRIPT_PATH $DST_SERVER_PATH $DST_GAME_ID"
}

print_info() {
    echo ""
    echo "文件结构："
    tree -P '*.sh|*.properties|*.cmd' --prune /home/${STEAMCMD_USERNAME}
    echo "---------------------------------------------------------------------------------------"
    echo "关键目录："
    echo "  存档存放位置：/home/${STEAMCMD_USERNAME}/.Klei/DoNotStarveTogether/${DST_CLUSTER_NAME}"
    echo "  mods存放位置：/home/${STEAMCMD_USERNAME}/${DST_SERVER_PATH}/mods"
    echo ""
    echo "后续步骤："
    echo "  1、su ${STEAMCMD_USERNAME}"
    echo "  2、cd ~"
    echo "  3、mkdir -p ~/.Klei/DoNotStarveTogether"
    echo "  4、准备存档和mods,复制到指定目录"
    echo "  5、cd ~/${DST_SCRIPT_PATH}"
    echo "  6、start.sh"
    echo "如果想配置定时任务,请启动服务器crond服务,然后执行以下命令"
    echo "  crontab -u ${STEAMCMD_USERNAME} /home/${STEAMCMD_USERNAME}/${DST_SCRIPT_PATH}/config/cron.cmd"
    echo ""
    echo "---------------------------------------------------------------------------------------"
    echo ""
}

setup_config
setup_sys_env
setup_user
setup_steamcmd
setup_scripts
setup_dstserver
print_info
