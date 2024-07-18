# docker全球仓库被限制拉取次数 匿名用户6小时100
docker login -u 
dckr_pat_40c4IlGSwT_QR-dqwuRA_tBw3sY



## 从外部保存镜像到私有仓库方法

1. docker pull openjdk:8
2. docker save openjdk:8 > openjdk.tar
3. docker load -i openjdk.tar
4. docker tag openjdk:8 192.168.10.150:8090/base/openjdk:8
5. docker login -u developer -p dev2021@FT 192.168.10.150:8090
6. docker push 192.168.10.150:8090/base/openjdk:8