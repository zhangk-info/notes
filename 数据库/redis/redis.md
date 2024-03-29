## redis相关知识
    远程内存非关系型数据库

纯内存操作
单线程操作，避免了频繁的上下文切换
采用了非阻塞I/O多路复用机制
    
### redis数据类型：多样的数据结构
    https://redis.io/topics/data-types-intro
* String 二进制安全字符串。
* Lists 列表：根据插入顺序排序的字符串元素的集合。它们基本上是链表。
* Sets 集：唯一，未排序的字符串元素的集合。
* ZSets 与Sets相似的有序sets，但每个字符串元素都与一个称为score的浮点值相关联。元素总是按它们的分数排序，因此与Sets不同，可以检索一系列元素（例如，您可能会问：给我前10名或后10名）。
* Hashes 哈希，是由与值关联的字段组成的映射。字段和值都是字符串。这与Ruby或Python哈希非常相似。
* Bit arrays(or simply bitmaps) 位数组（或简称为位图）：可以使用特殊命令像位数组一样处理字符串值：您可以设置和清除单个位，计数所有设置为1的位，找到第一个设置或未设置的位，等等。
* geospatial indexes
* HyperLogLogs：这是一个概率数据结构，用于估计集合的基数。别害怕，它比看起来更简单...请参阅本教程的HyperLogLog部分。
* Streams 流：提供抽象日志数据类型的类地图项的仅追加集合。在“ Redis流简介”中对它们进行了深入 介绍。

### redis持久化：RDB和AOF持久化数据
#### RDB 镜像文件 save&bgsave每隔一段时间进行一次快照持久化
  ```
  缺点：
    每隔一段时间进行一次持久化，如果redis崩溃，可能会导致部分数据丢失问题；
    RDB使用fork()子进程进行数据的持久化，如果数据量大，可能花费的时间较长，redis会造成明显的卡顿几秒现象；
    很好的备份效果，容易进行数据恢复；
  优点:
    相比AOF，在数据量比较大的情况下，RDB的启动速度更快；
    子进程进行数据的持久化，本身不会有多余的IO操作；
  ```
#### AOF 日志形式 appendfsync指定更新日志条件fsync策略执行持久化
  * always：【同步】持久化，每次发生数据变化会立刻写入到aof_buffer中,下次循环将aof_buffer刷到磁盘。性能较差当数据完整性比较好（慢，安全）。即使设置为always，也会丢失一个循环的数据。
  * everysec：出厂默认推荐，每秒【异步】记录一次（默认值）
  * no：不同步
##### aof设置
  * AOF重写：auto-aof-rewrite-percentage 100 当前AOF文件大小是上次日志重写得到AOF文件大小的二倍时，自动启动新的日志重写过程。
  * auto-aof-rewrite-min-size 64mb 启动新的日志重写过程的最小值，避免刚刚启动Reids时由于文件尺寸较小导致频繁的重写。
### 高可用/分布式：哨兵模式（Sentinel） & 集群模式(Cluster)
* 哨兵模式（主master从slave模式）： 所有节点的记录都是一样的，当主节点挂了的时候哨兵选举一个从节点作为主。
* 集群模式（分布式）：将数据分散到不同节点，通过缓存key通过hash将数据路由到不同的节点



### 缓存雪崩、缓存穿透、缓存击穿
* 缓存雪崩：同一时间大面积失效。
    * 缓存预热；
    * 随机过期时间；
    * 缓存标记记录缓存是否失效；
    * 互斥锁；
* 缓存穿透：缓存和数据库中都没有的数据。
    * 布隆过滤器；
* 缓存击穿：缓存中没有但数据库中有；一般是指缓存失效了，多个并发同时打到了数据库中。
    * 热点数据永不过期；
    * 互斥锁；
    
### 事务： 不支持回滚，但可用于命令一次传输，整体执行
### 流水
### 发布/订阅 = 消息队列
### lua脚本


### redis不是强一致性的数据库 异步复制
    主节点挂了的时候，如果数据没有同步到备节点，是会出现数据丢失的情况
* 脑裂
* 分区

### redis与数据库的双写一致性问题
    redis只能保证最终一致性，如果对数据有强一致性要求，不能放缓存。或者加分布式锁处理。


### redis三种集群模式
https://www.cnblogs.com/wanghaokun/p/10366689.html
#### redis 分片集群
    工作原理如下

    客户端与Redis节点直连,不需要中间Proxy层，直接连接任意一个Master节点
    根据公式HASH_SLOT=CRC16(key) mod 16384，计算出映射到哪个分片上，然后Redis会去相应的节点进行操作
    具有如下优点:
    (1)无需Sentinel哨兵监控，如果Master挂了，Redis Cluster内部自动将Slave切换Master
    (2)可以进行水平扩容
    (3)支持自动化迁移，当出现某个Slave宕机了，那么就只有Master了，这时候的高可用性就无法很好的保证了，万一master也宕机了，咋办呢？ 针对这种情况，如果说其他Master有多余的Slave ，集群自动把多余的Slave迁移到没有Slave的Master 中。

    缺点:
    (1)批量操作是个坑
    (2)资源隔离性较差，容易出现相互影响的情况。


##### 用Bitmaps做日活统计
```
/**
* 更新并获取累计用户数
*/

```


##### 用Sets做性能监控

### redis删除策略
* 惰性删除
* 定期删除
* 定时删除

### redis淘汰策略

参数： maxmemory 2g可以设置redis内存大小
参数： maxmemory-policy noeviction可以设置淘汰策略
* noeviction(默认策略)：若是内存的大小达到阀值的时候，所有申请内存的指令都会报错。
* volatile-ttl：所有设置了过期时间的key根据过期时间进行淘汰，越早过期就越快被淘汰。
* allkeys-random：所有的key使用随机淘汰的方式进行淘汰。
* volatile-random：所有设置了过期时间的key使用随机淘汰的方式进行淘汰。
* allkeys-lru：所有key都是使用LRU算法进行淘汰。
* volatile-lru：所有设置了过期时间的key使用LRU算法进行淘汰。
* volatile-lfu：从所有配置了过期时间的键中驱逐使用频率最少的键
* allkeys-lfu：从所有键中驱逐使用频率最少的键

#### lru算法（Least Recently Used）：最近最少使用。数据的历史访问记录时间来进行淘汰数据。

redis的lru不是真正的lru算法。通过随机采集法淘汰key，每次都会随机选出5个key，然后淘汰里面最近最少使用的key。
参数： maxmemory-samples 5取值越大那么获取的数据就越全，淘汰中的数据的就越接近最近最少使用的数据。但是耗费的cpu也就更多。
假如在Redis中的数据有一部分是热点数据，而剩下的数据是冷门数据，或者我们不太清楚我们应用的缓存访问分布状况，这时可以使用allkeys-lru。

#### lfu算法（Least Frequently Used）：最近频繁被使用。最近的时间段的被访问次数的频率作为一种判断标准。

LFU算法反映了一个key的热度情况（热度），不会因为LRU算法的偶尔一次被访问被认为是热点数据。


#### 工具
https://github.com/qishibo/AnotherRedisDesktopManager
