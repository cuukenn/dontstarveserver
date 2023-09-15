# 饥荒服务器安装、启停及定时更新

注：

-   部分基础内容摘自：https://blog.csdn.net/szhiy/article/details/79996017
-   增加内容：定时更新、安装及启停脚本
-   内存不足增加 swap 分区参考：https://www.cnblogs.com/chentop/p/10330052.html

## 下载

```
git clone https://github.com/cuukenn/dontstarveserver.git
```

## 安装

```
sh setup.sh
```

## 准备

-   移动服务端 mods 到指定目录
-   移动存档到服务器指定目录

## 启动

-   安装完成后会有日志打印，按照顺序执行即可

## 定时更新服务器

-   操作系统开启定时服务

    -   centos7

        ```shell
        systemctl enable crond
        systemctl start  crond
        ```

    -   centos6

        ```shell
        service crond start
        ```

-   写入定时任务

    ```shell
    crontab -u ${STEAMCMD_USERNAME} /home/${STEAMCMD_USERNAME}/${DST_SCRIPT_PATH}/config/cron.cmd
    ```
