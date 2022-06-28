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
