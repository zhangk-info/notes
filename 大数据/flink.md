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
    flink:1.18.0-scala_2.12 jobmanager
    
    
$ docker run \
    -d --restart=always \
    --name=taskmanager \
    --network flink-network \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    flink:1.18.0-scala_2.12 taskmanager


$ docker run \
    -d --restart=always \
    --name=jobmanager \
    --network flink-network \
    --publish 18081:8081 \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    -v /data/flink/jdbc-jars:/opt/flink/lib/jdbc-jars \
    -v /data/flink/checkpoints:/checkpoints \
    flink:1.16.2-scala_2.12 jobmanager
    
$ docker run \
    -d --restart=always \
    --name=taskmanager \
    --network flink-network \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    -v /data/flink/jdbc-jars:/opt/flink/lib/jdbc-jars \
    -v /data/flink/checkpoints:/checkpoints \
    flink:1.16.2-scala_2.12 taskmanager
    
-- 记得chomod -R 777

$ docker run \
    -d --restart=always \
    --name=jobmanager \
    --network flink-network \
    --publish 18081:8081 \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    flink:1.14.4-scala_2.11 jobmanager
    
    
$ docker run \
    -d --restart=always \
    --name=taskmanager \
    --network flink-network \
    --env FLINK_PROPERTIES="${FLINK_PROPERTIES}" \
    flink:1.14.4-scala_2.11 taskmanager


```