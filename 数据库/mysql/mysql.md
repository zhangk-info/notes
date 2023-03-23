# mariadb-db安装
docker run -p 3306:3306 --name mariadb-db -v /data/mysql/conf/:/etc/mysql/conf.d/ -v /data/mysql/logs:/var/log/mysql -v /data/mysql/data:/var/lib/mysql --restart=always --privileged=true -e MYSQL_ROOT_PASSWORD=mariadb-db -d mariadb:latest

# mysql安装
docker run -d --restart=always -p 3306:3306 -v /data/mysql/conf:/etc/mysql/conf.d -v /data/mysql/data:/var/lib/mysql -v /data/mysql/log:/var/log -v /etc/localtime:/etc/localtime -e MYSQL_ROOT_PASSWORD=Qcd@2022 --name mysql5.7 mysql:5.7
docker run -d --restart=always -p 3306:3306 -v /data/mysql/conf:/etc/mysql/conf.d/ -v /data/mysql/data:/var/lib/mysql -v /data/mysql/log:/var/log -v /data/mysql/mysql-files:/var/lib/mysql-files -v /etc/localtime:/etc/localtime  -e MYSQL_ROOT_PASSWORD='RlcGFy36' --name mysql8.0 mysql:8.0

## vi /data/mysql/conf/my.cnf
```
# 连接断开时间 12小时
connect_timeout=43200

# 临时表大小 当查询sql出来的临时表过大时调整
tmp_table_size=1G
max_heap_table_size=1G

# 锁超时时间 有长时间处理的sql可以增大，不能大于程序连接池时间
innodb_lock_wait_timeout=300

# 运行传入的sql语句大小，当批量操作sql过大时调整（如通过sql文件执行），一般够用
max_allowed_packet=16M

# 缓冲池大小
innodb_buffer_pool_size=2G
# 缓冲池数量 cpu超过8线程时建议增大
innodb_buffer_pool_instances=8

# 查询排序时所能使用的缓冲区大小。注意：该参数对应的分配内存是每连接独占，如果有100个连接，那么实际分配的总共排序缓冲区大小为100 × 6 ＝ 600MB。所以，对于内存在4GB左右的服务器推荐设置为6-8M。
read_buffer_size = 4M
# 读查询操作所能使用的缓冲区大小。和sort_buffer_size一样，该参数对应的分配内存也是每连接独享。
join_buffer_size = 8M

# 一些连接的配置
# 最大连接数
max_connections=2000
# 线程缓存数 防止线程频繁销毁创建造成的消耗增大
thread_cache_size=200



```

## rewriteBatchedStatements=true MySQL JDBC驱动在默认情况下会无视executeBatch()语句，把我们期望批量执行的一组sql语句拆散，一条一条地发给MySQL数据库，批量插入实际上是单条插入。 把rewriteBatchedStatements参数置为true, 驱动才会帮你批量执行SQL
url: jdbc:mysql://ip:3306/silver?useSSL=false&useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&rewriteBatchedStatements=true&autoReconnect=true&failOverReadOnly=false&allowPublicKeyRetrieval=true