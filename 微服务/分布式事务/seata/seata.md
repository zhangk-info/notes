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

## Seata各事务模式
* AT
  * 一阶段提交：解析sql并记录前镜像（之前的数据），执行语句，记录后镜像，根据前后镜像生成undo log，生成全局事务ID
  * 二阶段回滚：通过xID和branchId查询到undo log，数据校验：将存储的后镜像与当前数据做比较，如果不一致根据配置策略做处理，如果一致则根据undo log前镜像生成相应的sql并执行回滚
  * 三阶段提交：开启一个异步线程并将结果里面返回成功给TC；异步线程批量删除相应的undo log
* TCC
  * 和at的区别是需要自定义的prepare、commit、rollback逻辑
* SAGA
  * 长事务
* XA
  * 需要数据库支持xa协议；由数据库xa协议支持来保证持久化和可回滚
        
        