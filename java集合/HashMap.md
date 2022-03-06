## 数组+链表/红黑树
## 初始化大小&加载因子（loadfactor)
默认16和0.75
如果传入是17 初始化大小是【更大的2的幂次方数】=32
如果size元素个数大于threshold阈值16*0.75=12，就会发生扩容

### put过程
key = null --> hash(key) = 0;
```java
    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        // 如果table为null
        if ((tab = table) == null || (n = tab.length) == 0)
            // table进行resize()进行初始化 16 0.75 12
            n = (tab = resize()).length;
        // 如果通过key.hashCode()计算出的hash再【按位与运算】找到的下标位置的节点为null
        if ((p = tab[i = (n - 1) & hash]) == null)
            // 新建节点放到当前下标
            tab[i] = newNode(hash, key, value, null);
        else {
            Node<K,V> e; K k;
            // 如果新的hash和原下标node的hash一样
            // 并且 key是同一对象或者【key的equal为true】
            // 那么值覆盖
            if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
            // 如果是下标node是红黑树
            else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            else {
                // 如果下标node是链表
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {
                        p.next = newNode(hash, key, value, null);
                        // 如果链表长度>16 treeifyBin中<64会扩容 >64会树化
                        // if (tab == null || (n = tab.length) < MIN_TREEIFY_CAPACITY) resize();
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            treeifyBin(tab, hash);
                        break;
                    }
                    //如果从链表中找到了就进行值覆盖
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    p = e;
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                // 当前节点e移至链表的尾部
                afterNodeAccess(e);
                return oldValue;
            }
        }
        // 修改次数+1
        ++modCount;// 引申出fast-fail快速失败机制 iterator中不能remove否则抛出ConcurrentModificationException
        if (++size > threshold)
            // 容量>阈值 扩容
            resize();
        afterNodeInsertion(evict);
        return null;
    }
```

### resize过程 ： 元素transfer转移到新数组
* 双倍扩容
* 链表元素会倒转
* 链表变短 : 链表的元素放到相同位置的两个index下，如原来是8扩容到16，原来下标7的链表会变短分散到7和15下标中
* 1.7头插法在多线程下同时resize可能产生循环链表
* rehash条件：initHashSeedAsNeeded() 扩容后的大小是否大于Integer.MAX_VALUE或者是否有jvm参数