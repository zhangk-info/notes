# mariadb-db安装
docker run -p 3306:3306 --name mariadb-db -v /data/mysql/db/conf/:/etc/mysql/conf.d/ -v /data/mysql/db/logs:/var/log/mysql -v /data/mysql/db/data:/var/lib/mysql --restart=always --privileged=true -e MYSQL_ROOT_PASSWORD=mariadb-db -d mariadb:latest


```
# 连接断开时间ms
connect_timeout=3600000

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