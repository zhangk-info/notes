# ShardingSphere

https://blog.csdn.net/wzy0623/article/details/124948877
https://blog.csdn.net/qq_44981526/article/details/127193650


```
# 数据源配置
spring.shardingsphere.datasource.names=master,slave1,slave2
spring.shardingsphere.datasource.master.type=${spring.datasource.type}
spring.shardingsphere.datasource.master.driver-class-name=${spring.datasource.driver-class-name}
spring.shardingsphere.datasource.master.jdbc-url=${spring.datasource.url}
spring.shardingsphere.datasource.master.username=${spring.datasource.username}
spring.shardingsphere.datasource.master.password=${spring.datasource.password}
spring.shardingsphere.datasource.slave1.type=${spring.datasource.type}
spring.shardingsphere.datasource.slave1.driver-class-name=${spring.datasource.driver-class-name}
spring.shardingsphere.datasource.slave1.jdbc-url=jdbc:mysql://192.168.10.149:3307/ft-fast-basic-v2?useSSL=false&useUnicode=true&characterEncoding=utf-8&autoReconnect=true&serverTimezone=Asia/Shanghai&allowMultiQueries=true
spring.shardingsphere.datasource.slave1.username=${spring.datasource.username}
spring.shardingsphere.datasource.slave1.password=${spring.datasource.password}
spring.shardingsphere.datasource.slave2.type=${spring.datasource.type}
spring.shardingsphere.datasource.slave2.driver-class-name=${spring.datasource.driver-class-name}
spring.shardingsphere.datasource.slave2.jdbc-url=jdbc:mysql://192.168.10.149:3308/ft-fast-basic-v2?useSSL=false&useUnicode=true&characterEncoding=utf-8&autoReconnect=true&serverTimezone=Asia/Shanghai&allowMultiQueries=true
spring.shardingsphere.datasource.slave2.username=${spring.datasource.username}
spring.shardingsphere.datasource.slave2.password=${spring.datasource.password}
spring.shardingsphere.masterslave.name=master_slave1_slave2_datasource
spring.shardingsphere.masterslave.master-data-source-name=master
spring.shardingsphere.masterslave.slave-data-source-names=slave1,slave2

# 读写分离类型，如: Static，Dynamic
spring.shardingsphere.rules.readwrite-splitting.data-sources.customize-name-mss.type=Static
# 写数据源名称
spring.shardingsphere.rules.readwrite-splitting.data-sources.customize-name-mss.props.write-data-source-name=master
# 读数据源名称，多个从数据源用逗号分隔
spring.shardingsphere.rules.readwrite-splitting.data-sources.customize-name-mss.props.read-data-source-names=slave1,slave2
 
 
# 打印SQl
spring.shardingsphere.props.sql-show=true

# 规则配置
spring.shardingsphere.rules.sharding.tables.gateway_access_logs.actual-data-nodes=ds-0.gateway_access_logs_2023${(6..12).collect{t ->t.toString().padLeft(2,'0')}},ds-0.gateway_access_logs_${2024..2050}${(1..12).collect{t ->t.toString().padLeft(2,'0')}}
spring.shardingsphere.rules.sharding.tables.gateway_access_logs.table-strategy.standard.sharding-column=create_time
spring.shardingsphere.rules.sharding.tables.gateway_access_logs.table-strategy.standard.sharding-algorithm-name=gateway-access-logs-interval
spring.shardingsphere.rules.sharding.sharding-algorithms.gateway-access-logs-interval.type=AUTO_CREATE_TABLE_INTERVAL
spring.shardingsphere.rules.sharding.sharding-algorithms.gateway-access-logs-interval.props.datetime-pattern="yyyy-MM-dd HH:mm:ss"
spring.shardingsphere.rules.sharding.sharding-algorithms.gateway-access-logs-interval.props.datetime-lower="2023-06-01 00:00:00"
spring.shardingsphere.rules.sharding.sharding-algorithms.gateway-access-logs-interval.props.sharding-suffix-pattern=yyyyMM
spring.shardingsphere.rules.sharding.sharding-algorithms.gateway-access-logs-interval.props.datetime-interval-amount=1
spring.shardingsphere.rules.sharding.sharding-algorithms.gateway-access-logs-interval.props.datetime-interval-unit=MONTHS

ft-fast.shardingsphere.autoCreateTableDataSources=master
spring.autoconfigure.exclude=com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceAutoConfigure,org.apache.shardingsphere.spring.boot.ShardingSphereAutoConfiguration
```



# 模式--实际项目中请配置集群模式Memory File Cluster 不需要 使用分布式治理或代理才需要（比如分布式事务）
spring.shardingsphere.mode.type=Cluster
# 持久化仓库类型
spring.shardingsphere.mode.repository.type=ZooKeeper
# 注册中心命名空间
spring.shardingsphere.mode.repository.props.namespace=dev-sharding-jdbc
# 注册中心连接地址
spring.shardingsphere.mode.repository.props.server-lists=192.168.10.149:2181
# 持久化仓库所需属性
spring.shardingsphere.mode.repository.props.retryIntervalMilliseconds=500
spring.shardingsphere.mode.repository.props.timeToLiveSeconds=60
spring.shardingsphere.mode.overwrite=false