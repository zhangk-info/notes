# JUV : Java util concurrent
* java并发编程工具类

## java多线程使用口诀 
1. 在高内聚 低耦合 的前提下  线程 操作 资源类
    * 高内聚：所有操作高度内聚在资源类中
    * 低耦合: 线程避免直接操作资源内容，使用资源类暴露的方法（操作）来操作资源内容
2. 交互过程: 判断、干活、通知
3. 多线程交互中，必须要防止多线程的虚假唤醒,也即,多线程判断中不许用if,只能用while
    * 交互: wait(); notify();
    * 虚假唤醒: 唤醒了，但是条件并没有再次校验.
    * 由于多线程唤醒之后,所有线程都会唤醒。比如刚好两个线程都在等待，两个线程都被唤醒，两个线程都生成/消费。但是条件并没有再次校验
4. 标志位
    * synchronized wait notify -> lock await signal
    


## java多线程实现的2种方式
* extends Thread / new Thread 并重写run方法
* implements Runnable 即 new Thread(new Runnable() {@Override public void run() { } }); 给Thread传入实现了run方法的Runnable对象target
```
@Override
public void run() {
    if (target != null) {
        target.run();
    }
}
```

### 其他所有方法的底层都是通过以上两种方式生成的Thread
* implements Callable<T> 通过FutureTask包装器来创建 FutureTask<V> implements RunnableFuture<V> extends Runnable, Future<V>
* Executors工具类 线程池 TreadPoolExecutor类  ThreadFactory.newThread(return new Thread())

#### 面试问题：如果一个Thread即实现了Runnable又重写了run方法，它会执行哪个run方法呢？
``` 
new Thread(() -> {
    System.out.println("实现了Runnable的run方法");
}) {
    @Override
    public void run() {
        System.out.println("重写了Thread的run方法");
    }
}.start();
```
 结论是会执行重写的run方法的代码；因为该Thread的run方法被重写了 “ if (target != null) { target.run(); } ”将会被覆盖消失，虽然传入了target但是无法调用target.run了 

#### 例子
* SaleTicket 竞争模式
* ThreadWaitNotifyDemo 生产消费模式


#### 关键字

ArrayList/Map/Set不安全： CopyOnWriteArrayList  ConcurrentHashMap CopyOnWriteArraySet
线程状态：new runnable blocked waiting timed_waiting terminated 
实现线程的2中方式：extends Thread并重写run方法 \ new Thread(new Runnable(public void run(){})) 传入实现了run方法的Runnable对象target
锁：synchronized ReentrantLock ReadWriteLock
锁通信： wait notify condition await signal 
多线程辅助类： countDownLatch cyclicBarrier semaphore
线程池：ThreadPoolExecutor Runtime.getRuntime().availableProcessors() workQueue(LinkedBlockQueue)
线程池的7个属性： corePoolSize maximumPoolSize keepAliveTime TimeUnit workQueue threadFactory rejectedExecutionHandler
线程池拒绝策略（RejectedExecutionHandler/Policy）: Abort/CallerRuns/DiscardOld/Discard
四大函数式接口： Consumer<T> t->{} Supplier<T> t->{return t} Function<T,R> t->{return R} Predicate<T> t->{return flag}


ArrayList/Map/Set不安全：
线程状态：
实现线程的2种方式：
锁：
锁通信： 
多线程辅助类：
线程池：
线程池的7个属性：
线程池拒绝策略（）: 
四大函数式接口：


