# 连接断开时间ms
connect_timeout=3600000

# 临时表大小 当查询sql出来的临时表过大时调整
tmp_table_size=1G
max_heap_table_size=1G

# 锁超时时间 有长时间处理的sql可以增大，不能大于程序连接池时间
innodb_lock_wait_timeout=300

# 运行传入的sql语句大小，当批量操作sql过大时调整（如通过sql文件执行），一般够用
max_allowed_packet=16M

# https://www.cnblogs.com/wanbin/p/9530833.html
# 缓冲池大小
innodb_buffer_pool_size=3G
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

# 默 认的设置在中等强度写入负载以及较短事务的情况下，服务器性能还可 以。如果存在更新操作峰值或者负载较大，就应该考虑加大它的值了。如果它的值设置太高了，可能会浪费内存 — 它每秒都会刷新一次，因此无需设置超过1秒所需的内存空间。通常 8-16MB 就足够了。越小的系统它的值越小。
# 当我们调整innodb_buffer_pool_size大小时，innodb_log_buffer_size和innodb_log_file_size也应该做出相应的调整。
innodb_log_buffer_size


# 大小写不敏感
lower_case_table_names=1

# 其他优化参考 https://www.cnblogs.com/wangsongbai/p/11382536.html

