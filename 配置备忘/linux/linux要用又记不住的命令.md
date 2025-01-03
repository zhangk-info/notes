
# docker compose 安装
https://docs.docker.com/compose/install/

# redis压测：
./redis-benchmark -n 1000 -c 50 -d 102400 -r 1000 -t set,get -h 192.168.0.148 -p 16379 -a "cmdi..123" -q


# 1）共享主机的localtime
创建容器的时候指定启动参数，挂载localtime文件到容器内，保证两者所采用的时区是一致的。
# docker run -ti -d --name my-nginx -v /etc/localtime:/etc/localtime:ro  docker.io/nginx  /bin/bash

# --docker 仓库修改 /etc/docer/daemon.json
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "data-root":"/home/docker"
}
记得重启 systemctl restart docker

# 从一个服务器复制文件到另一个服务器 
scp /data/backup.zip developer@192.168.1.100:/data/

# docker 镜像加速

https://docker.m.daocloud.io

增加前缀 (推荐方式): 
docker.io/library/busybox
        |
        V
m.daocloud.io/docker.io/library/busybox

创建或修改 /etc/docker/daemon.json 文件
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://noohub.ru",
    "https://huecker.io",
    "https://dockerhub.timeweb.cloud",
    "https://5tqw56kt.mirror.aliyuncs.com",
    "https://docker.1panel.live",
    "http://mirrors.ustc.edu.cn/",
    "http://mirror.azure.cn/",
    "https://hub.rat.dev/",
    "https://docker.ckyl.me/",
    "https://docker.chenby.cn",
    "https://docker.hpcloud.cloud",
    "https://docker.m.daocloud.io"
  ]
}

systemctl daemon-reload
systemctl restart docker 

# docker挂载目录 Permission denied
原因 centos7 selinux把权限禁用了
1. docker exec 加上  --user=root
2. docker run 加上   --privileged=true

# 升级系统软件
yum upgrade -y

# yum  rpmdb open failed
mv /var/lib/rpm/__db* /tmp;
rpm --rebuilddb;
yum clean all

# yum切换源

第1步：备份原有yum源：
mv /etc/yum.repos.d /etc/yum.repos.d.bak
第2步：创建yum源目录
mkdir /etc/yum.repos.d
第3步：下载阿里云yum源配置
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
第4步：重建yum缓存
yum clean all
yum makecache

# yum工具
安装yum-utils
yum install yum-utils
清理未完成事务
yum-complete-transaction --cleanup-only

# yum重装
uname -r

rpm -qa | grep yum | xargs rpm -e --nodeps
rpm -qa yum

```
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-3.4.3-168.el7.centos.noarch.rpm
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch.rpm
```

rpm -ivh yum-* 

rpm -qa yum


## npm 安装
1. wget https://nodejs.org/dist/v16.9.1/node-v16.9.1-linux-x64.tar.gz
2. tar -vxzf
3. ln -s ~/node-v16.9.1-linux-x64/bin/npm /usr/local/bin/npm
4. ln -s ~/node-v16.9.1-linux-x64/bin/node /usr/local/bin/node


# 切换yum源 All mirrors were tried
1. x
cd /etc/yum.repos.d/
2. x
rm *.repo
3. 选择版本 cat /etc/centos-release 查看版本
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
4. 重建缓存
   yum clean all
   yum makecache

5. 升级所有包
   yum upgrade -y
   yum -y update：升级所有包同时，也升级软件和系统内核；（时间比较久）
   yum -y upgrade：只升级所有包，不升级软件和系统内核，软件和内核保持原样


## 修改文件数（连接数）
* 方法1：ulimit -n 65535
* 方法2：
```
vim /etc/security/limits.conf

* hard nofile 20000
* soft nofile 15000
* soft nproc 65535
* hard nproc 65535

```


## kernel升级 先切换源
1. 查看当前系统内核版本，可升级的内核版本
  yum info kernel -q 
2. 升级当前版本支持的内核版本信息
  yum update kernel
3. 查看当前已经安装的内核版本情况
  yum list kernel
4. 系统重启后默认选择最高版本kernel
  reboot
5. 查看当前系统内核
  uname -a
  uname -sr

## 定时任务配置 vim /etc/crontab

```

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

# 每天凌晨2.20清理无用的docker镜像
20 2 * * * echo y | docker image prune -a

```


## 磁盘分区操作

在线扩容使用 resize2fs或xfs_growfs 对挂载目录在线扩容
resize2fs 针对文件系统ext2 ext3 ext4
* resize2fs /dev/sda4 80G -p 更改分区大小到80G 去掉80G表示更改到最大
xfs_growfs 针对文件系统xfs
* xfs_growfs /dev/sda3
parted
* resizepart 3 380G



# 文件导入
apt install lrzsz
rz-be