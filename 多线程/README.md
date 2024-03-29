# JUV : Java util concurrent
* java并发编程工具类

## 并发编程的三大特性

## java多线程使用口诀 
1. 在高内聚 低耦合 的前提下  线程 操作 资源类
    * 高内聚：所有操作高度内聚在资源类中
    * 低耦合: 线程避免直接操作资源内容，使用资源类暴露的方法（操作）来操作资源内容
2. 交互过程: 判断、干活、通知
3. 多线程交互中，必须要防止多线程的虚假唤醒,也即,多线程判断中不许用if,只能用while
    * 交互: wait();notify(); wait();wait();notifyAll();
    * 虚假唤醒: 唤醒了，但是条件并没有再次校验.
    * 由于多线程唤醒之后,所有线程都会唤醒。比如刚好两个线程都在等待，两个线程都被唤醒，两个线程都生成/消费。但是条件并没有再次校验
4. 标志位
    * synchronized wait notify -> lock await signal
    
### sleep和wait的区别
* sleep属于Thread类的静态方法、wait属于object类的方法
* sleep是timed_waiting状态，自动唤醒、wait是waiting状态，需要手动唤醒
* sleep不会释放持有的锁住的资源、wait会释放锁住的资源
* sleep可以在不持有锁的时候执行、wait方法只能在持有对象（线程）的锁时才可执行（必须和synchronized一起使用）

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


#### 线程池
线程池：ThreadPoolExecutor Runtime.getRuntime().availableProcessors() workQueue(LinkedBlockQueue)
线程池的7个属性： corePoolSize maximumPoolSize keepAliveTime TimeUnit workQueue threadFactory rejectedExecutionHandler
线程池拒绝策略（RejectedExecutionHandler/Policy）: Abort/CallerRuns/DiscardOld/Discard
线程池的状态： running stop shutdown tidying terminated
* running：运行中
* stop：不接收并中断；阻塞队列一个不管
* shutdown： 不接收但会接续执行直到完成。阻塞队列也会执行完成
* tidying：中间状态
* terminated：终结
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
线程池的状态： running stop shutdown tidying terminated
四大函数式接口： Consumer<T> t->{} Supplier<T> t->{return t} Function<T,R> t->{return R} Predicate<T> t->{return flag}


ArrayList/Map/Set不安全：
线程状态：new runnable blocked waiting timed_waiting terminated
实现线程的2种方式：
锁：synchronized reentrantlock 
锁通信： wait notify await signal
多线程辅助类：countdownlatch semphare cyclicbarrier
线程池：
线程池的7个属性：corepoolsize maximumpoolsize keepalivetime timeunit workqueue 
线程池拒绝策略（）: 
四大函数式接口：


