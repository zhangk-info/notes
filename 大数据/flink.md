# flink

https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/deployment/resource-providers/standalone/docker/

## docker 安装

```

$ FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager
taskmanager.numberOfTaskSlots: 10
"

$ docker network create flink-network


$ docker run \
    -d --restart=always \
    --name=jobmanager \
    --network flink-network \
    --publish 18081:8081 \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    -v /data/flink/log:/opt/flink/log \
    -v /data/flink/jdbc-jars:/opt/flink/lib/jdbc-jars \
    -v /data/flink/checkpoints:/checkpoints \
    flink:1.16.2-scala_2.12 jobmanager
    
$ docker run \
    -d --restart=always \
    --name=taskmanager \
    --network flink-network \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    -v /data/flink/log:/opt/flink/log \
    -v /data/flink/jdbc-jars:/opt/flink/lib/jdbc-jars \
    -v /data/flink/checkpoints:/checkpoints \
    flink:1.16.2-scala_2.12 taskmanager
    
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

#### over 根据当前流数据的上下界进行开创