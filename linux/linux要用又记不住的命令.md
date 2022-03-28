# mariadb-db安装
docker run -p 31001:3306 --name mariadb-db -v /data/mysql/db/conf/:/etc/mysql/conf.d/ -v /data/mysql/db/logs:/var/log/mysql -v /data/mysql/db/data:/var/lib/mysql --restart=always --privileged=true -e MYSQL_ROOT_PASSWORD=mariadb-db -d mariadb:latest

# docker compose 安装
https://docs.docker.com/compose/install/

# redis压测：
./redis-benchmark -n 1000 -c 50 -d 102400 -r 1000 -t set,get -h 192.168.0.148 -p 16379 -a "cmdi..123" -q


# 1）共享主机的localtime
创建容器的时候指定启动参数，挂载localtime文件到容器内，保证两者所采用的时区是一致的。
# docker run -ti -d --name my-nginx -v /etc/localtime:/etc/localtime:ro  docker.io/nginx  /bin/bash

# docker 启动nginx
docker run --name nginx -p80:80 -d -v /data/nginx/conf:/etc/nginx -v /data/nginx/html:/usr/share/nginx/html -v /data/ssl:/data/ssl nginx


docker run --name nginx -d -p 80:80 -p 443:443 -v /data/nginx/log:/var/log/nginx -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx/conf/conf.d:/etc/nginx/conf.d -v /data/nginx/html:/usr/share/nginx/html -v /data/ssl:/data/ssl nginx

--docker 仓库修改 /etc/docer/daemon.json
{
  "registry-mirrors": ["https://8qwj47tn.mirror.aliyuncs.com"],
  "data-root":"/home/docker"
}
记得重启 systemctl restart docker

# 从一个服务器复制文件到另一个服务器 
scp /data/backup.zip developer@192.168.1.100:/data/

# docker 镜像加速
创建或修改 /etc/docker/daemon.json 文件
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