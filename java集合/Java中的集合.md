# Java中的集合
* List
  * ArrayList  数组  增删慢，查询快  线程不安全
  * Vector  数据  增删慢，查询快  线程安全
  * LinkedList  链表  增删快，查询慢  线程不安全  提供了操作头部和尾部的方法，可以当做堆栈、队列或双向队列试用
* Queue
  
* Set 不可重复
  * HashSet  HashTable实现
  * TreeSet  
  * LinkedHashSet  HashTable实现
* Map 可重复
  * HashMap  线程不安全
  * ConcurrentHashMap  线程安全，1.7segment分段锁&数组+链表，1.8Synchronized和CAS控制并发&数组+链表+红黑树
  * HashTable  线程安全
  * TreeMap
  * LinkedHashMap HashTable实现

### adk -1 0 1
### 副本数>=2 retry 回调
### 指定index 幂等
### 手动offset  重平衡 允许重复或重复不消费

### kafka为什么快
1. 磁盘顺序读写
2. 零拷贝
3. 分区分段+索引 1G一个段并且每个段有index文件
4. 批量压缩
5. 批量读写
  1. 写可以批量写
  2. 读是一批消息发出去，处理了之后更改offset
6. 直接操作page cache而不是jvm，避免对象创建和GC，读写速度更高，进程重启缓存也不会丢失；log 刷盘;
