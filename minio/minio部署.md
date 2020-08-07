## 以下为踩坑记录
1. 安装docker 
yum install docker
2. 部署docker镜像 并 启动一个容器
docker run -p 9000:9000 --name minio1   -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE"   -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"   -v /mnt/data:/data   -v /mnt/config:/root/.minio   minio/minio server /data
*如果没有正常下载镜像的话会
Unable to find image 'minio/minio:latest' locally
Trying to pull repository docker.io/minio/minio ... 
latest: Pulling from docker.io/minio/minio
自动搜索和下载镜像
*这里一定要修改账号和密码，允许常规字符串作为账号和密码，意味着可以使用加密后的字符串
3. 获取容器ID = 查看所有容器
docker ps -a
4. 启动容器
docker start <container_id>
5. 查看容器日志
docker logs <container_id>
6. 监控容器使用的资源
docker stats <container_id>
7. 停止容器 <此时我发现我的minio容器  账号和密码没有修改>
docker stop <container_id>
8. 删除容器
docker rm <container_id>
9. 查看所有镜像
docker image
10. 删除镜像
docker rmi <image_id>

# 以上为踩坑 下面开始使用正常操作流程 哈哈

1. 搜索镜像
docker search <key>
*这里我们 docker search minio
2. 下载镜像
docker pull <key>
*这里我们 docker pull minio/minio
3. 查看镜像
docker images
4. 直接创建 并 启动容器
docker run 
*等同于先执行docker create，再执行docker start
*这里我们使用官方的run例子
--要创建具有永久存储的MinIO容器，您需要将本地持久目录从主机操作系统映射到虚拟配置~/.minio 并导出/data目录
分两步执行
(1)  docker create -p 9000:9000 --name minio1   -e "MINIO_ACCESS_KEY=zhangk"   -e "MINIO_SECRET_KEY=zhangk.."   -v /mnt/data:/data   -v /mnt/config:/root/.minio   minio/minio server /data
(2)  docker ps -a
(3)  docker start <container_id>
5. 到此单机minio部署完成,可以使用端口直接进行访问了
服务器IP:9000
ip:9000
输入上面配置的账号密码进行登录

## 这里有文件安装的操作 没有试过

minio单台安装步骤

wget https://dl.minio.io/server/minio/release/linux-amd64/minio

chmod +x minio

./minio server /home/data

# 启动后会打印出AccessKey和SecretKey等信息

# 后台运行

nohup /usr/local/bin/minio server  /home/minio/data > /home/minio/data/minio.log 2>&1 &

# 自定义MINIO_ACCESS_KEY和MINIO_SECRET_KEY

export MINIO_ACCESS_KEY=minio

export MINIO_SECRET_KEY=miniostorage

./minio server /home/data

#自定义端口号

./minio server --address IP:PORT /home/data

//文件夹地址

 export MINIO_VOLUMES="/home/data"