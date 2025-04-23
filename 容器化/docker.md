# docker全球仓库被限制拉取次数 匿名用户6小时100
docker login -u 
dckr_pat_40c4IlGSwT_QR-dqwuRA_tBw3sY



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