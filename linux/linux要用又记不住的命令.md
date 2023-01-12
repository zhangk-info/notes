
# docker compose 安装
https://docs.docker.com/compose/install/

# redis压测：
./redis-benchmark -n 1000 -c 50 -d 102400 -r 1000 -t set,get -h 192.168.0.148 -p 16379 -a "cmdi..123" -q


# 1）共享主机的localtime
创建容器的时候指定启动参数，挂载localtime文件到容器内，保证两者所采用的时区是一致的。
# docker run -ti -d --name my-nginx -v /etc/localtime:/etc/localtime:ro  docker.io/nginx  /bin/bash

# docker 启动nginx
docker run --name nginx -p80:80 -d -v /data/nginx/conf:/etc/nginx -v /data/nginx/html:/usr/share/nginx/html -v /data/ssl:/data/ssl nginx


docker run --name nginx -d -p 80:80 -p 443:443 --restart=always -v /data/nginx/log:/var/log/nginx -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx/conf/conf.d:/etc/nginx/conf.d -v /data/nginx/html:/usr/share/nginx/html -v /data/ssl:/data/ssl nginx

--docker 仓库修改 /etc/docer/daemon.json
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "data-root":"/home/docker"
}
记得重启 systemctl restart docker

# 从一个服务器复制文件到另一个服务器 
scp /data/backup.zip developer@192.168.1.100:/data/

# docker 镜像加速
创建或修改 /etc/docker/da  emon.json 文件
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}

systemctl daemon-reload
systemctl restart docker 

# 升级系统软件
yum upgrade -y

# yum  rpmdb open failed
mv /var/lib/rpm/__db* /tmp;
rpm --rebuilddb;
yum clean all

# yum切换源
cd /etc/yum.repos.d/
mv CentOS-Base.repo CentOS-Base.repo.backup
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
mv CentOS6-Base-163.repo CentOS-Base.repo
yum makecache
yum -y install update
yum clean all


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