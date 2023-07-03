## 安装

```
docker run -d --restart=always -p 9090:9090 --name=prometheus -v E:\prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v E:\prometheus/prometheus-data:/prometheus prom/prometheus
```

## 配置

```
global:
  scrape_interval:     15s # 默认抓取间隔, 15秒向目标抓取一次数据。
  external_labels:
    monitor: 'codelab-monitor'
rule_files:
  - "first.rules"
  - "my/*.rules"
# 存储配置
storage:
  tsdb:
    retention:
      time: 90d
      size: 1024MB
# 这里表示抓取对象的配置
scrape_configs:
  #这个配置是表示在这个配置内的时间序例，每一条都会自动添加上这个{job_name:"prometheus"}的标签  - job_name: 'prometheus'
  - job_name: 'prometheus'
    scrape_interval: 5s # 重写了全局抓取间隔时间，由15秒重写成5秒
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'spring'
    scrape_interval: 5s # 重写了全局抓取间隔时间，由15秒重写成5秒
    # 抓取的端点  
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['localhost:93']

```

###   

```
--storage.tsdb.path：Prometheus 写入数据库的地方。默认为data/.
--storage.tsdb.retention.time：何时删除旧数据。默认为15d. storage.tsdb.retention如果此标志设置为默认值以外的任何值，则覆盖。
--storage.tsdb.retention.size：要保留的存储块的最大字节数。最旧的数据将首先被删除。默认为0或禁用。支持的单位：B、KB、MB、GB、TB、PB、EB。例如：“512MB”。基于2的幂，所以1KB就是1024B。尽管 WAL 和 m 映射块计入总大小，但仅删除持久块以实现此保留。因此，对磁盘的最低要求是wal（WAL 和检查点）和chunks_head（m 映射的头块）目录组合所占用的峰值空间（每 2 小时达到峰值）。
--storage.tsdb.retention: 已弃用，赞成storage.tsdb.retention.time.
--storage.tsdb.wal-compression：启用预写日志 (WAL) 的压缩。根据您的数据，您可以预期 WAL 大小会减半，而几乎没有额外的 CPU 负载。该标志在 2.11.0 中引入，并在 2.20.0 中默认启用。请注意，一旦启用，将 Prometheus 降级到 2.11.0 以下的版本将需要删除 WAL。
```

##### 进入prometheus容器

* docker exec -it prometheus /bin/sh

## spring集成

#### maven

```
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

#### yaml

```
management:
  endpoints:
    web:
      exposure:
        include: '*'
  metrics:
    tags:      
      application: ${spring.application.name}
  endpoint:
    metrics:
      enabled: true
    prometheus:
      enabled: true
```