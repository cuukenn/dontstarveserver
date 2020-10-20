# 饥荒服务器安装、启停及定时更新
注：
 - 部分基础内容摘自：https://blog.csdn.net/szhiy/article/details/79996017
 - 增加内容：定时更新、安装及启停脚本

###  一、解决环境依赖   ###

- Ubuntu 系统需要的依赖：
```shell
sudo apt-get install libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 lib32gcc1
```
- CentOS 系统需要的依赖 (仅供参考)：
```shell
yum -y install glibc.i686 libstdc++.i686 libcurl4-gnutls-dev.i686 libcurl.i686
```

### 二，创建专用用户 ###

 ```shell
useradd steam
password steam
su steam
 ```
 注：相关脚本涉及根路径为/home/steam,不创建特定用户修改对应脚本路径也没问题
### 二、安装 SteamCMD ###
- 此目录用于 steam 程序的安装目录。
```shell
mkdir ~/steamcmd
```
- 下载 SteamCMD 安装文件
```shell
wget -P ~/steamcmd https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
```
- 解压压缩包
```shell
cd ~/steamcmd
tar -xvzf ~/steamcmd/steamcmd_linux.tar.gz
```

### 三、安装饥荒服务端 ###
- 准备好相关文件(暂时放到/home/steam目录)
  - cron_update_starve.sh：用于cron定时调度调度、进行服务器更新得的脚本
  - update_starve.cmd：用于下载饥荒服务器至指定目录
  - update_starve.sh：steamcmd运行时实际命令
  - start.sh：在后台启动地上地上服务器
  - start_master.sh：前台启动地上服务器
  - start_cave.sh：前台启动地下服务器
  - stop.sh：停止所有服务器
- 赋予执行权限
```shell
 - chmod u+x *.sh
```
- 启动安装脚本
```shell
./update_starve.sh
```
- 移动启停脚本
```shell
 mv start* /home/steam/common/dstserver/bin
 mv stop*  /home/steam/common/dstserver/bin
```

### 四，准备游戏存档及mods ###
- 复制相关mods至/home/steam/common/dstserver/mods
- 复制存档至/home/steam/.Klei\DoNotStarveTogether\Cluster_1

### 五，解决一个 lib 缺失 ###
```shell
cd /home/steam/common/dstserver/bin/lib32
ln -s /usr/lib/libcurl.so.4 libcurl-gnutls.so.4
```

### 六，设置定时调度 ###
- centos
```shell
  systemctl enable crond
  systemctl start  crond
```
  使用crontab -e后写入：0 0 3 * * ? * /home/steam/cron_update_starve.sh，保存
```shell
  crontab -e
```

### 七、预期文件目录结构（仅保留核心内容） ###
- ├── common
│   └── dstserver
│       ├── bin
│       │   ├── start_cave.sh
│       │   ├── start_master.sh
│       │   ├── start.sh
│       │   ├── steam_appid.txt
│       │   └── stop.sh
├── steamcmd
│   └── steamcmd.sh
├── update_starve.cmd
└── update_starve.sh
├── cron_update_starve.sh


### 八、启动及验证 ###
- 启动
```shell
/home/steam/common/dstserver/bin/start.sh
```
- 验证
```shell
ps aux | grep donts
```