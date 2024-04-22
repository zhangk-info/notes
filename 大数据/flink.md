# flink

https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/deployment/resource-providers/standalone/docker/

## docker 安装

```
// 配置solt数量、集群高可用选举地址、文件默认存储地址、状态后端增加存储、checkpoints存储地址
$ FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager
taskmanager.numberOfTaskSlots: 10
high-availability.type: zookeeper
high-availability.zookeeper.quorum: 192.168.1.149:2181
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
high-availability.zookeeper.quorum: 192.168.1.149:2181
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
    registry.cn-hangzhou.aliyuncs.com/data_big/dinky:flink1.16.3-2 jobmanager
    
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
