## Map知识点

### 内存泄露
```
Map<key,vaue> 在使用对象作为key的时候需要重写对象的equals和hashCode方法，
否则每个key都会被作为新对象来存放，无法通过对象的值来去重
严重造成内存泄露
```

### 多线程下的数据不一致问题
```
例子：

ConcurrentHashMap<String,Integer> map = new ConcurrentHashMap<>();
Integer i = 0;
if(map.get(key) != null){
    i = map.get(key);
    i++;
    map.set(key,i);
}

这样写，就算是ConcurrentHashMap也没法保证原子性

解决方法一： 规范代码保证原子性，如：保证【判null,得值，赋值】三步操作同一时间只能一个线程访问
解决方法二： 使用ConcurrentHashMap保证原子性的代码完成【判null,得值，赋值】三步操作,
map.putIfAbsent()  putIfAbsent有NPE的bug   NPE:NullPointException
map.computeIfAbsent()
并使用atomic保证integer的原子性。

```

### Map类集合K/V能不能存储null值的情况，如下表格：
```
        集合类             key             value           super           线程
    HashTable           不允许为nul     不允许为nul     Dictionary          安全
ConcurrentHashMap       不允许为nul     不允许为nul     AbstractMap     分段锁技术
    TreeMap             不允许为nul     允许为nul       Dictionary         不安全
    HashTable             允许为nul     允许为nul       Dictionary         不安全
```


### ConcurrentHashMap分段锁技术
```
ConcurrentHashMap是Java 5中支持高并发、高吞吐量的线程安全HashMap实现。
我们以ConcurrentHashMap来说一下分段锁的含义以及设计思想
ConcurrentHashMap中的分段锁称为Segment
类似于HashMap（JDK7与JDK8中HashMap的实现）的结构，即内部拥有一个Entry数组，数组中的每个元素又是一个链表；同时又是一个ReentrantLock（Segment继承了ReentrantLock)。
当需要put元素的时候，并不是对整个hashmap进行加锁，而是先通过hashcode来知道他要放在哪一个分段中，然后对这个分段进行加锁，所以当多线程put的时候，只要不是放在一个分段中，就实现了真正的并行的插入。
但是，在统计size的时候，可就是获取hashmap全局信息的时候，就需要获取所有的分段锁才能统计。
分段锁的设计目的是细化锁的粒度，当操作不需要更新整个数组的时候，就仅仅针对数组中的一项进行加锁操作。
```
```
不过JDK8之后，ConcurrentHashMap舍弃了ReentrantLock，而重新使用了synchronized。其原因大致有一下几点：

加入多个分段锁浪费内存空间。
生产环境中， map 在放入时竞争同一个锁的概率非常小，分段锁反而会造成更新等操作的长时间等待。
为了提高 GC 的效率
```