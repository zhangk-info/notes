# flink

https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/deployment/resource-providers/standalone/docker/

## docker 安装

```
// 配置solt数量、集群高可用选举地址、文件默认存储地址、状态后端增加存储、checkpoints存储地址
$ FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager
taskmanager.numberOfTaskSlots: 10
high-availability.type: zookeeper
high-availability.zookeeper.quorum: 192.168.10.149:2181
high-availability.zookeeper.path.root: /flink
high-availability.cluster-id: /cluster_one
fs.default-scheme: hdfs://hadoop:9000/
high-availability.storageDir: /flink
execution.checkpointing.interval: 3min
state.backend: rocksdb
state.backend.incremental: true
state.checkpoints.dir: hdfs://hadoop:9000/checkpoints
"

// s3支持
$ FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager
taskmanager.numberOfTaskSlots: 20
high-availability.type: zookeeper
high-availability.zookeeper.quorum: 192.168.10.149:2181
high-availability.zookeeper.path.root: /flink
high-availability.cluster-id: /cluster_one1
high-availability.storageDir: /flink
state.backend: rocksdb
fs.allowed-fallback-filesystems: s3
state.checkpoints.dir: s3://flink/checkpoints 
state.savepoints.dir: s3://flink/savepoints
state.backend.incremental: true
s3.access-key: Ig7TOshcmcgkqG4U
s3.secret-key: tB4x0rmuaW42qobIGq4eRjA39BS0VVbq
s3.ssl.enabled: false
s3.path.style.access: true
s3.endpoint: http://192.168.1.150:9000
"

$ docker network create flink-network

$ docker run \
    -d --restart=always \
    --name=hadoop \
    --network flink-network \
    -p 9870:9870 -p 50070:50070 -p 9000:9000 -v /data/hadoop/data:/tmp/hadoop-root/dfs/name \
    sequenceiq/hadoop-docker
    
-v 挂载启动失败了?  
进入hadoop创建两个文件夹 /user/local/hadoop/bin
 hadoop fs -mkdir flink
 hadoop fs -mkdir checkpoints

$ docker run \
    -d --restart=always \
    --name=jobmanager \
    --network flink-network \
    --publish 18081:8081 \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    -v /data/flink/log:/opt/flink/log \
    -v /data/flink/jdbc-jars:/opt/flink/lib/jdbc-jars \
    -v /data/flink/checkpoints:/checkpoints \
    192.168.10.150:8090/base/dinky:flink1.16.3-2 jobmanager
    
$ docker run \
    -d --restart=always \
    --name=taskmanager \
    --network flink-network \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    -v /data/flink/log:/opt/flink/log \
    -v /data/flink/jdbc-jars:/opt/flink/lib/jdbc-jars \
    -v /data/flink/checkpoints:/checkpoints \
    flink:1.16.3-scala_2.12-java8 taskmanager
    
-- 记得chomod -R 777

```

## flink中的窗口

### group windows

    根据时间或行计数间隔，将行聚合到有限的组中，并对每个组的数据执行聚合函数

#### thump 滚动窗口 开一定时间或步长的窗口（数据均分）

#### slide 滑动窗口 开一定时间或步长的窗口并且一定时间或步长滑动一次（有重复数据）

#### session 会话窗口

#### global 全局窗口

### over windows

    针对每个输入行，计算相邻行范围内的聚合

#### over 根据当前流数据的上下界进行开窗





五、Dinky
部署命令：
    dinkydocker/dinky-standalone-server:1.0.0-rc3
端口：
    dinky：8888
配置：
    DB_ACTIVE mysql
    MYSQL_ADDR 192.168.10.149:3306
    MYSQL_DATABASE dinky
    MYSQL_USERNAME root
    MYSQL_PASSWORD Ftwj@2022
挂载：
    挂载点为： /opt/dinky/customJar  挂在到主机的 /data/dinky
开放网络：clusterip增加ip 或者使用nodeport
访问地址：
    192.168.10.160:8888

六、Flink镜像构建
    1.jar包准备
    2.在当前extends目录下准备以下几个jar包
        ●commons-cli-1.3.1.jar
        ●dinky-app-1.15-1.0.0-SNAPSHOT-jar-with-dependencies.jar
        ●flink-table-planner_2.12-1.15.4.jar
    放入flink运行需要的自定义连接器等相关包到extends目录下
    3.编写Dockerfile，在extends中运行
```
ARG FLINK_VERSION=1.16.2

FROM m.daocloud.io/flink:${FLINK_VERSION}-scala_2.12-java8

COPY . /opt/flink/lib/extends

RUN rm -rf ${FLINK_HOME}/lib/flink-table-planner-loader-*.jar    
```

4.执行构建命令
    docker build -t dinky-flink:1.0.0-1.16.2-2 . -f Dockerfile

5.推送镜像到私有仓库
    docker tag dinky-flink:1.0.0-1.16.2-2 192.168.10.150:8090/base/dinky:flink1.16.2-2
    docker push 192.168.10.150:8090/base/dinky:flink1.16.2-2


6.拉取镜像文件
    docker pull 192.168.10.150:8090/base/dinky:flink1.16.3

七、k8s与flink集成
    1.权限
    kubectl delete clusterrolebinding flink-role-binding-default
    kubectl create clusterrolebinding flink-role-binding-default --clusterrole=cluster-admin --serviceaccount=bigdata:default
    2.定义k8s自定义资源组 使用应用商店安装不需要这一步
    将https://github.com/apache/flink-kubernetes-operator/tree/main/helm/flink-kubernetes-operator
    crd中的两个配置文件导入到自定义资源组CRD中
    
    3.安装flink-kubernetes-operator
        a.添加helm charts仓库
    
        b.配置应用商店从应用商店安装:flink-kubernetes-operator
        https://downloads.apache.org/flink/flink-kubernetes-operator-1.xx/
        注意：从应用商店安装同样需要第一步或者--set webhook.create=false
    
c.或者参考官方文档安装flink-kubernetes-operator
https://nightlies.apache.org/flink/flink-kubernetes-operator-docs-main/docs/try-flink-kubernetes-operator/quick-start/
第一步的cert-manager可以不用配置
第二步install时增加参数--set webhook.create=false 同时指定namespace  --namespace=bigdata
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator --set webhook.create=false  --namespace=bigdata
查看运行情况：
kubectl get pods


八、AQS
1.访问不到或者不能访问其他主机
关闭防火墙
或正确配置出入端口
sudo ufw allow 22/tcp
sudo ufw reload
https://ranchermanager.docs.rancher.com/zh/getting-started/installation-and-upgrade/installation-requirements/port-requirements
https://docs.rancher.cn/docs/rancher2.5/installation/resources/advanced/firewall/_index
2.iptables: No chain/target/match by that name
防火墙关闭了，同时关闭了iptables服务，docker启动不能映射端口了
3.同一节点安装rancher和rancher-agent端口冲突问题
更改rancher映射端口：将 -p 80:80 -p 443:443 替换为 -p 8080:80 -p 8443:443


