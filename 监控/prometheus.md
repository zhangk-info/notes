## 安装

```
docker run -d --restart=always -p 9090:9090 --name=prometheus -v E:\prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
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