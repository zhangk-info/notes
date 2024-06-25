
# tidb

<https://docs-archive.pingcap.com/zh/tidb/v3.0/test-deployment-using-docker>

## tipd

```
docker run -d --name tipd1 -p 2379:2379 -p 2380:2380 -v D:\docker/tidb/pd/data:/data -v D:\docker/tidb/conf/pd.toml:/pd.toml:ro pingcap/pd:v7.5.0 --name="pd1" --data-dir="/data/pd1" --client-urls="http://0.0.0.0:2379" --advertise-client-urls="http://192.168.50.203:2379" --peer-urls="http://0.0.0.0:2380" --advertise-peer-urls="http://192.168.50.203:2380" --initial-cluster="pd1=http://192.168.50.203:2380" --config="/pd.toml" --log-file="/log/pd.log"
-- 不需要配置
docker run -d --name tipd1 -p 2379:2379 -p 2380:2380 -v D:\docker/tidb/pd/data:/data pingcap/pd:v7.5.0 --name="pd1" --data-dir="/data/pd1" --client-urls="http://0.0.0.0:2379" --advertise-client-urls="http://192.168.50.203:2379" --peer-urls="http://0.0.0.0:2380" --advertise-peer-urls="http://192.168.50.203:2380" --initial-cluster="pd1=http://192.168.50.203:2380"

docker run -d --name tipd1 -p 2379:2379 -p 2380:2380 -v /data2/tidb/pd/data:/data pingcap/pd:v7.5.0 --name="pd1" --data-dir="/data/pd1" --client-urls="http://0.0.0.0:2379" --advertise-client-urls="http://192.168.1.149:2379" --peer-urls="http://0.0.0.0:2380" --advertise-peer-urls="http://192.168.1.149:2380" --initial-cluster="pd1=http://192.168.1.149:2380"
```

## tikv

```
docker run -d --name tikv1 -p 20160:20160 --ulimit nofile=1000000:1000000 -v D:\docker/tidb/kv/data:/data -v D:\docker/tidb/conf/tikv.toml:/tikv.toml:ro -v D:\docker/tidb/log/tikv.log:/log/tikv.log pingcap/tikv:v7.5.0 --addr="0.0.0.0:20160" --advertise-addr="192.168.50.203:20160" --data-dir="/data/tikv1" --pd="192.168.50.203:2379" --config="/tikv.toml" --log-file="/log/tikv.log"
-- 不需要配置
docker run -d --name tikv1 -p 20160:20160 --ulimit nofile=1000000:1000000 -v D:\docker/tidb/kv/data:/data -v D:\docker/tidb/log/tikv.log:/log/tikv.log pingcap/tikv:v7.5.0 --addr="0.0.0.0:20160" --advertise-addr="192.168.50.203:20160" --data-dir="/data/tikv1" --pd="192.168.50.203:2379" --log-file="/log/tikv.log"

docker run -d --name tikv1 -p 20160:20160 --ulimit nofile=1000000:1000000 -v /data2/tidb/kv/data:/data pingcap/tikv:v7.5.0 --addr="0.0.0.0:20160" --advertise-addr="192.168.1.149:20160" --data-dir="/data/tikv1" --pd="192.168.1.149:2379"
```

## tidb

```
docker run -d --name tidb -p 4000:4000 -p 10080:10080 -v D:\docker/tidb/log/tidb.log:/log/tidb.log pingcap/tidb:v7.5.0 --store=tikv --path="192.168.50.203:2379" --log-file="/log/tidb.log"

-- 不需要log
docker run -d --name tidb -p 4000:4000 -p 10080:10080 pingcap/tidb:v7.5.0 --store=tikv --path="192.168.1.149:2379"
```

```
mysql -h 127.0.0.1 -P 4000 -u root -D test
```


## 开启binlog

``` 
启动binlog
docker run -d --name tipump -p 8250:8250 -v /data2/tidb/data/binlog/data:/data/pump pingcap/tidb-binlog:v7.5.0 /pump --addr="0.0.0.0:8250" --advertise-addr="192.168.1.149:8250" --data-dir="/data/pump" --pd-urls="http://192.168.1.149:2379"
```

tidb.toml
```
[config.pump]
enable = true
addr = "192.168.1.149:8250"

[binlog]
enable = true
ignore-error = false
write-timeout = "15s"
flush-interval = "1s"
binlog-socket = ""
binlog-format = "ROW"
```

```
-- 配置并 启动
docker run -d --name tidb -p 4000:4000 -p 10080:10080 -v /data2/tidb/conf/tidb.toml:/tidb.toml:ro pingcap/tidb:v7.5.0 --store=tikv --path="192.168.1.149:2379" --config="/tidb.toml"
```
uhub.service.ucloud.cn/
```
# 如果binlog-format没生效
set binlog_format = "ROW";
flush logs;
show variables like '%bin%';
```

##  drainer
tidrainer.toml 用于实时数据同步和数据迁移 （主从备份）
```
# 数据库地址
addr = "0.0.0.0:8260"

# 日志文件位置
# log-file = "/path/to/drainer.log"

# PD 地址
pd-urls = "192.168.1.149:2379"

# 下游的 TiDB 服务器地址
# 同步任务的配置
[syncer]
# 目标文件系统的配置
db-type = "file"
# 存储同步数据的目录
dir = "/sync_data_directory"
```

```
启动drainer
docker run -d --name tidrainer -p 8260:8260 -v /data2/tidb/conf/tidrainer.toml:/tidrainer.toml:ro -v /data2/tidb/data/sync_data_directory:/sync_data_directory pingcap/drainer --config="/tidrainer.toml"
```