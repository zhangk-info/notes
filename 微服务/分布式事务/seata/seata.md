### 创建registry.conf
为了指定seata的配置模式是nacos : config.type
```
registry {
  # file 、nacos 、eureka、redis、zk、consul、etcd3、sofa
  type = "nacos"
  loadBalance = "RandomLoadBalance"
  loadBalanceVirtualNodes = 10

  nacos {
    application = "seata-server"
    serverAddr = "139.155.72.177:8848"
    group = "SEATA_GROUP"
    namespace = ""
    cluster = "default"
    username = "nacos"
    password = "zhangk..123"
  }
}

config {
  # file、nacos 、apollo、zk、consul、etcd3、springCloudConfig
  type = "nacos"

  nacos {
    serverAddr = "139.155.72.177:8848"
    namespace = ""
    group = "SEATA_GROUP"
    username = "nacos"
    password = "zhangk..123"
  }
}
```
### docker安装seata
docker run --name seata-server \
        -p 8091:8091 -d \
        -e SEATA_CONFIG_NAME=file:/root/seata-config/registry \
        -v /data/seata/config:/root/seata-config  \
        seataio/seata-server
        
        
        