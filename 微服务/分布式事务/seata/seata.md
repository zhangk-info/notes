### 客户端配置


### docker安装seata - 文件模式

1. 创建registry.conf
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
    cluster = "default_cluster"
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
    # 可选，不选默认是 配置的服务名.yml data-id: seataServer.properties
  }
}
```

2. 创建配置文件 用于指定store.model
   1. 如果config.type是file,需要将registry.conf的config.file.name的值改为类似file:/root/file.conf
   2. 如果配置到其他地方，如nacos，在nacos中配置指定的文件
```
# 数据存储方式，db代表数据库
seataServer.properties
store.mode=db
store.db.datasource=druid
store.db.dbType=mysql
store.db.driverClassName=com.mysql.cj.jdbc.Driver
store.db.url=jdbc:mysql://localhost:3306/seata?useUnicode=true&rewriteBatchedStatements=true
store.db.user=root
store.db.password=root
store.db.minConn=5
store.db.maxConn=30
store.db.globalTable=global_table
store.db.branchTable=branch_table
store.db.queryLimit=100
store.db.lockTable=lock_table
store.db.maxWait=5000
# 事务、日志等配置
server.recovery.committingRetryPeriod=1000
server.recovery.asynCommittingRetryPeriod=1000
server.recovery.rollbackingRetryPeriod=1000
server.recovery.timeoutRetryPeriod=1000
server.maxCommitRetryTimeout=-1
server.maxRollbackRetryTimeout=-1
server.rollbackRetryTimeoutUnlockEnable=false
server.undo.logSaveDays=7
server.undo.logDeletePeriod=86400000

# 客户端与服务端传输方式
transport.serialization=seata
transport.compressor=none
# 关闭metrics功能，提高性能
metrics.enabled=false
metrics.registryType=compact
metrics.exporterList=prometheus
metrics.exporterPrometheusPort=9898
```
3. 创建数据库和表

   https://github.com/seata/seata/blob/2.x/script/server/db/mysql.sql

4. 启动 7091是ui可以不开 默认账号密码是 seata seata
   docker run -d --name seata-server \
   -p 8091:8091 \
   -p 7091:7091 \
   -e SEATA_CONFIG_NAME=file:/root/seata-config/registry \
   -v /data/seata/config:/root/seata-config  \
   seataio/seata-server

5. 使用 https://seata.io/zh-cn/docs/ops/deploy-guide-beginner
   1. 添加undo_log到业务库

   https://github.com/seata/seata/blob/2.x/script/client/at/db/mysql.sql   

   2. 添加依赖和配置到客户端（业务服务）
```
    <dependency>
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-starter-alibaba-seata</artifactId>
    </dependency>
    
    
    # 更多配置参考 http://seata.io/zh-cn/docs/user/configurations.html
seata:
    enabled: true
    registry: # tc服务在注册中心的配置，微服务根据这些信息去注册中心获取tc服务地址
        # 参考tc服务自己的registry.conf中的配置
        type: nacos
        nacos: # tc
            server-addr: ${spring.cloud.nacos.config.server-addr}
            namespace: ${spring.cloud.nacos.config.namespace}
            group: ${spring.cloud.nacos.config.group}
            application: seata-server # tc服务在nacos中的服务名称
            cluster: default_cluster
            username: nacos
            password: nacos
    tx-service-group: my-seata-group # 事务组，根据这个获取tc服务的cluster名称（可以每个应用独立取名，也可使用相同名字）
    service:
        vgroup-mapping: # 事务组与tc服务cluster的映射关系
            my-seata-group: default_cluster
    data-source-proxy-mode: AT  # !!非常重要 慎重选择
    client:
        rm:
            report-success-enable: true
            table-meta-check-enable: false  # 自动刷新缓存中的表结构（默认false）
            report-retry-count: 5  # 一阶段结果上报tc重试次数（默认5）
            async-commit-buffer-limit: 10000 # 异步提交缓存队列长度（默认10000）
            lock:
                retry-interval: 10 # 校验或占用全局锁重试间隔（默认10ms）
                retry-times: 30 # 校验或占用全局锁重试次数（默认30）
                retry-policy-branch-rollback-on-conflict: true # 分支事务与其它全局回滚事务冲突时锁策略（优先释放本地锁让回滚成功）
        tm:
            commit-retry-count: 3 # 一阶段全局提交结果上报tc重试次数（默认1次，建议大于1）
            rollback-retry-count: 3 # 一阶段全局回滚结果上报tc重试次数（默认1次，建议大于1）
        undo:
            data-validation: true # 二阶段回滚镜像校验（默认true开启）
            log-serialization: kryo # undo序列化方式（默认jackson 不支持 LocalDateTime）
            log-table: undo_log  # 自定义undo表名（默认undo_log
        log:
            exception-rate: 100 # 日志异常输出概率（默认100）
    transport:
        shutdown:
            wait: 3
        thread-factory:
            boss-thread-prefix: NettyBoss
            worker-thread-prefix: NettyServerNIOWorker
            server-executor-thread-prefix: NettyServerBizHandler
            share-boss-worker: false
            client-selector-thread-prefix: NettyClientSelector
            client-selector-thread-size: 1
            client-worker-thread-prefix: NettyClientWorkerThread
        type: TCP
        server: NIO
        heartbeat: true
        serialization: seata
        compressor: none
        enable-client-batch-send-request: true # 客户端事务消息请求是否批量合并发送（默认true）
```
    3. 开始使用 @GlobalTransactional
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
        
        