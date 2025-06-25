# docker全球仓库被限制拉取次数 匿名用户6小时100
docker login -u 
dckr_pat_40c4IlGSwT_QR-dqwuRA_tBw3sY


## docker 卸载

步骤 1：彻底卸载旧版 Docker
```
# 停止 Docker 服务
sudo systemctl stop docker docker.socket containerd

# 卸载 Docker 相关软件包
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker.io runc

# 删除所有 Docker 相关文件和目录
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm -rf /var/run/docker.sock

# 删除 Docker 仓库配置
sudo rm /etc/apt/sources.list.d/docker*.list

# 删除残留依赖
sudo apt-get autoremove -y --purge
```

## docker 安装

### 安装依赖工具

```
sudo apt-get update
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common
```
### 
方式1 最新版
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

方式2 指定版本
```

# 添加官方 GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 使用 20.04 (Focal) 的仓库
sudo rm /etc/apt/sources.list.d/docker.list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list

# 更新并安装

sudo apt-get update
sudo apt-get install -y docker-ce=5:20.10.24~3-0~ubuntu-focal \
docker-ce-cli=5:20.10.24~3-0~ubuntu-focal \
containerd.io


# 开机启动
systemctl enable docker
```

## 给其他用户操作docker服务的权限（执行docker命令）
chown <user> /var/run/docker.sock


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
busybox = docker.io/library/busybox
docker.io/library/busybox
|
V
m.daocloud.io/docker.io/library/busybox

创建或修改 /etc/docker/daemon.json 文件
{
"registry-mirrors": [
"https://docker.m.daocloud.io",
"https://docker.mirrors.ustc.edu.cn",
"https://docker.1panel.live",
"https://reg-mirror.qiniu.com",
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
"https://registry.docker-cn.com"
]
}

systemctl daemon-reload
systemctl restart docker

# docker挂载目录 Permission denied
原因 centos7 selinux把权限禁用了
1. docker exec 加上  --user=root
2. docker run 加上   --privileged=true



## 从外部保存镜像到私有仓库方法

1. docker pull openjdk:8
2. docker save openjdk:8 > openjdk.tar   或者  docker save -o openjdk.tar openjdk:8
3. docker load -i openjdk.tar
4. docker tag dinkydocker/dinky:1.1.0-flink1.18 192.168.10.150:8090/base/dinkydocker/dinky:1.1.0-flink1.18
5. docker login -u developer -p dev2021@FT 192.168.10.150:8090
6. docker push 192.168.10.150:8090/base/dinkydocker/dinky:1.1.0-flink1.18


docker tag pgvector/pgvector:pg17 192.168.10.150:8090/base/pgvector/pgvector:pg17
docker push 192.168.10.150:8090/base/pgvector/pgvector:pg17


docker run -d -p 3000:3000 --name flowise -e DATABASE_TYPE=postgresdb  -e DATABASE_PORT=5432  -e DATABASE_HOST=192.168.10.162  -e DATABASE_NAME=flowise  -e DATABASE_USER=root  -e DATABASE_PASSWORD=root..123 -e APIKEY_STORAGE_TYPE=db -e FLOWISE_USERNAME=root -e FLOWISE_PASSWORD=root..123 -e BLOB_STORAGE_PATH=/.flowise/storage -v /data/flowise/storage:/.flowise/storage 192.168.10.150:8090/base/flowiseai/flowise