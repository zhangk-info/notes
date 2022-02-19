#IO
```
内存 
kernel-内核程序 GDT(全局描述符表)-内存空间划分（用户空间/内核空间）-保护模式 
app（用户程序，如jvm）
中断 软中断/硬中断（驱动->事件） 硬中断例子：网卡，鼠标，键盘 
SystemCall 系统调用 
IO 硬件访问（读I写O） 

程序不能直接访问硬件，kernel能直接访问硬件，那么程序怎么访问硬件（进行io）？ 
程序产生软中断调用kernel提供的SystemCall访问硬件 

```
### BIO 
```
blockIO : 阻塞io
例子： 
    ServerSocket server = new ServerSocket(8090);// 启动一个8090端口的Socket服务
    while(true){// 无限循环
        Socket client = server.accept();// 得到一个连接
        new Thread(()->{// 得到一个连接之后就开启一个新线程
            try{
                InputStream in = client.getInputStream();
                BufferReader reader = new BufferReader(new InputStreamReader(in));
                While(true){// 从连接中不停的读取输入
                    System.out.println(reader.readLine());
                }
            }catch(Exception e){
            }
        })
    }

    如果client连接进来之后没有开启一个新的线程去处理这个client,那么他会一直等待输入阻塞住
    最早的处理方式：kernel阻塞，app多线程，每线程对应一个client连接

问题：
    1. 线程太多，资源消耗太大，一个线程1M的栈内存
    2. 系统调用太多，cpu切换频繁
    3. 根本问题，阻塞

```

### NIO
```
内核中： nonBlockIO-非阻塞IO jvm中： newIO-新IO
实现：
    每一个client连接进来就记录一个io的pid
    读的时候遍历所有pid读取
好处：
    1. 不用每个client都new Thread了

问题：（n：客户端数 m：有输入的客户端数,C10K:1万个客户端）
    1. 每循环内有O(n)的systemcall,其中有O(n-m)调用时无意义的

```
### SELECT
```
实现：（n：客户端数 m：输入的客户端数 select：一个systemcall）
    每一个client连接进来就记录一个io的pid
    读的时候传入所有pids给select,select返回有数据输入的m个client的io的pids
    每循环内有O(m)的systemcall
好处：（n：客户端数 m：有输入的客户端数）
    1. 每循环内有O(m)的systemcall，极大的较少了systemcall的浪费

问题：（n：客户端数 m：有输入的客户端数）
    1. 每次都要给select调用传入pids
    2. 需要app自己主动遍历读取

```

### EPOLL
```
实现： epoll_create epoll_ctl epoll_wait
    epoll_create在kernel中开辟一个空间返回一个pid
    server启动epoll_ctl放入server的pid并监听accept事件
    client连接epoll_ctl放入client的pid并监听读写事件
    client发生读写后产生网卡的硬中断，传入该client的pid，kernel主动调用app
    app产生一次读写
好处：
    1. app不需要记录pids且不需要产生循环调用
    2. app不需要主动遍历读取

问题：
    读写同步的

```

### AsynchronousI/O-异步IO
```
    用户进程发起read操作之后，立刻就可以开始去做其它的事。
    而另一方面，从kernel的角度，当它受到一个asynchronous read之后，首先它会立刻返回，所以不会对用户进程产生任何block。
    然后，kernel会等待数据准备完成，然后将数据拷贝到用户内存，当这一切都完成之后，kernel会给用户进程发送一个signal，告诉它read操作完成了。
```

### 其它知识
#### redis和nginx使用epoll的区别 accept
        1. redis是单线程，且线程中需要做很多事，所以轮询获取client连接
    2. nginx只有client产生才需要做事，所以nginx阻塞等待client连接

#### redis多线程
redis6.x之后的IO threads多线程读写分离，减少了O(n), 其实所有的计算和写还是worker线程在处理


#### ZeroCopy-零拷贝
```
以前的问题： （生产者和消费者是两个client）
    1. 读阶段： 
        1. 生产者therad发送数据存入磁盘中
        2. app进行systemcall读取数据后 对数据进行丰富加工 然后再systemcall写入磁盘中
    2. 写阶段：
        1. 消费者thread发送读请求
        2. app进行systemall读取数据 不对数据进行任何处理 systemcall写出给消费者
实现：
    1. mmap: 一个buffer实现，它打通了app内存空间和kernel内存空间，并直接刷新到磁盘中
        1. 它仅仅将n条数据put到mmap中，而不是进行n次systemcall写入到磁盘,较少了一次systemcall写入
    2. ”不对数据进行任何加工“的时候可以直接调用sendfile的systemcall较少了一次systemcall读取

```

#### java中的RandomAccessFile 
```
它有3中开辟空间的方式：
1. 堆内内存
2. 堆外内存
3. 直接到文件的mmap
```
