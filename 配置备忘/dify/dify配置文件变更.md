# dify配置文件变更

## .env

```

# Upload file size limit, default 15M.更改为150M
UPLOAD_FILE_SIZE_LIMIT=150
# nginx客户端body大小
NGINX_CLIENT_MAX_BODY_SIZE=150M

# code执行深度 5 改成了50
CODE_MAX_DEPTH=50
# 50 更改为了1000
CODE_MAX_STRING_ARRAY_LENGTH=1000
# 50 更改为了1000
CODE_MAX_OBJECT_ARRAY_LENGTH=1000

```

## docker-compose.yaml

```

  # The DifySandbox
  sandbox:
    image: langgenius/dify-sandbox:0.2.10
    restart: always
    environment:
      # The DifySandbox configurations
      # Make sure you are changing this key for your deployment with a strong key.
      # You can generate a strong key using `openssl rand -base64 42`.
      API_KEY: ${SANDBOX_API_KEY:-dify-sandbox}
      GIN_MODE: ${SANDBOX_GIN_MODE:-release}
      WORKER_TIMEOUT: ${SANDBOX_WORKER_TIMEOUT:-15}
      ENABLE_NETWORK: ${SANDBOX_ENABLE_NETWORK:-true}
      HTTP_PROXY: ${SANDBOX_HTTP_PROXY:-http://ssrf_proxy:3128}
      HTTPS_PROXY: ${SANDBOX_HTTPS_PROXY:-http://ssrf_proxy:3128}
      SANDBOX_PORT: ${SANDBOX_PORT:-8194}
      # 配置pip国内镜像
      PIP_INDEX_URL: "https://mirrors.aliyun.com/pypi/simple/"
    volumes:
      - ./volumes/sandbox/dependencies:/dependencies
    healthcheck:
      test: [ 'CMD', 'curl', '-f', 'http://localhost:8194/health' ]
    networks:
      - ssrf_proxy_network
      # 增加外部可访问外部网络  
      - default
      
```


## volumes/sandbox/conf 开启sandbox限制的系统操作符 使代码执行时不受限制

```
app:
  port: 8194
  debug: True
  key: dify-sandbox
max_workers: 4
max_requests: 50
worker_timeout: 5
python_path: /usr/local/bin/python3
enable_network: True # please make sure there is no network risk in your environment
allowed_syscalls: # please leave it empty if you have no idea how seccomp works
  # 基础文件操作
  - 0   # read - 从文件描述符读取数据
  - 1   # write - 向文件描述符写入数据
  - 2   # open - 打开文件
  - 3   # close - 关闭文件描述符
  - 4   # stat - 获取文件状态
  - 5   # fstat - 获取文件描述符状态
  - 6   # lstat - 获取符号链接状态
  - 7   # poll - 等待文件描述符上的事件
  - 8   # lseek - 重新定位读/写文件偏移量
  - 9   # mmap - 将文件或设备映射到内存
  - 10  # mprotect - 设置内存区域的保护
  - 11  # munmap - 取消内存映射
  - 12  # brk - 改变数据段大小

  # 系统操作
  - 13  # rt_sigaction - 检查或修改信号处理
  - 14  # rt_sigprocmask - 检查或修改阻塞信号
  - 15  # rt_sigreturn - 从信号处理程序返回
  - 16  # ioctl - 控制设备
  - 17  # pread64 - 从指定偏移量读取
  - 18  # pwrite64 - 向指定偏移量写入
  - 19  # readv - 从文件描述符读取数据到多个缓冲区
  - 20  # writev - 从多个缓冲区写入数据到文件描述符
  - 21  # access - 检查文件访问权限
  - 22  # pipe - 创建管道
  - 23  # select - 同步 I/O 多路复用
  - 24  # sched_yield - 让出处理器
  - 25  # mremap - 重新映射虚拟内存地址

  # 高级内存管理
  - 26  # msync - 同步内存与物理存储
  - 27  # mincore - 确定内存页是否驻留在内存中
  - 28  # madvise - 给出内存使用建议
  - 29  # shmget - 获取共享内存段
  - 30  # shmat - 附加共享内存段
  - 31  # shmctl - 共享内存控制
  - 32  # dup - 复制文件描述符
  - 33  # dup2 - 复制文件描述符到指定编号
  - 34  # pause - 挂起进程直到收到信号

  # 进程管理
  - 35  # nanosleep - 高精度睡眠
  - 36  # getitimer - 获取定时器值
  - 37  # alarm - 设置定时器
  - 38  # setitimer - 设置定时器
  - 39  # getpid - 获取进程ID
  - 40  # sendfile - 在文件描述符之间传输数据

  # 网络操作
  - 41  # socket - 创建套接字
  - 42  # connect - 初始化套接字连接
  - 43  # accept - 接受套接字连接
  - 44  # sendto - 通过套接字发送消息
  - 45  # recvfrom - 从套接字接收消息
  - 46  # sendmsg - 通过套接字发送消息
  - 47  # recvmsg - 通过套接字接收消息
  - 48  # shutdown - 关闭套接字连接
  - 49  # bind - 绑定套接字到地址
  - 50  # listen - 监听套接字连接

  # 进程间通信
  - 51  # getsockname - 获取套接字本地地址
  - 52  # getpeername - 获取套接字对端地址
  - 53  # socketpair - 创建一对已连接的套接字
  - 54  # setsockopt - 设置套接字选项
  - 55  # getsockopt - 获取套接字选项

  # 进程控制
  - 56  # clone - 创建子进程
  - 57  # fork - 创建进程
  - 58  # vfork - 创建进程并阻塞父进程
  - 59  # execve - 执行程序
  - 60  # exit - 终止进程
  - 61  # wait4 - 等待进程改变状态
  - 62  # kill - 发送信号

  # 信号处理
  - 63  # uname - 获取系统信息
  - 64  # semget - 获取信号量集
  - 65  # semop - 信号量操作
  - 66  # semctl - 信号量控制
  - 67  # shmdt - 分离共享内存段
  - 68  # msgget - 获取消息队列
  - 69  # msgsnd - 发送消息到队列
  - 70  # msgrcv - 从队列接收消息
  - 71  # msgctl - 消息队列控制

  # 文件系统操作
  - 72  # fcntl - 文件描述符控制
  - 73  # flock - 应用或删除文件锁
  - 74  # fsync - 同步文件到存储设备
  - 75  # fdatasync - 同步文件数据
  - 76  # truncate - 截断文件
  - 77  # ftruncate - 截断文件描述符指向的文件
  - 78  # getdents - 获取目录项
  - 79  # getcwd - 获取当前工作目录
  - 80  # chdir - 改变当前工作目录

  # 文件系统管理
  - 81  # fchdir - 通过文件描述符改变当前工作目录
  - 82  # rename - 重命名文件
  - 83  # mkdir - 创建目录
  - 84  # rmdir - 删除目录
  - 85  # creat - 创建新文件
  - 86  # link - 创建硬链接
  - 87  # unlink - 删除文件名
  - 88  # symlink - 创建符号链接
  - 89  # readlink - 读取符号链接的值
  - 90  # chmod - 改变文件权限

  # 权限和所有权
  - 91  # fchmod - 改变文件描述符的权限
  - 92  # chown - 改变文件所有者和组
  - 93  # fchown - 改变文件描述符指向文件的所有者和组
  - 94  # lchown - 改变符号链接的所有者和组
  - 95  # umask - 设置文件模式创建掩码

  # 系统信息和统计
  - 96  # gettimeofday - 获取时间和日期
  - 97  # getrlimit - 获取资源限制
  - 98  # getrusage - 获取资源使用情况
  - 99  # sysinfo - 获取系统统计信息
  - 100 # times - 获取进程时间

  # 系统控制
  - 101 # ptrace - 进程跟踪
  - 102 # getuid - 获取用户ID
  - 103 # syslog - 读取或清除内核消息
  - 104 # getgid - 获取组ID
  - 105 # setuid - 设置用户ID
  - 106 # setgid - 设置组ID

  # 用户和组管理
  - 107 # geteuid - 获取有效用户ID
  - 108 # getegid - 获取有效组ID
  - 109 # setpgid - 设置进程组
  - 110 # getppid - 获取父进程ID
  - 111 # getpgrp - 获取进程组ID

  # 会话管理
  - 112 # setsid - 创建会话并设置进程组ID
  - 113 # setreuid - 设置实际和有效用户ID
  - 114 # setregid - 设置实际和有效组ID
  - 115 # getgroups - 获取附加组ID
  - 116 # setgroups - 设置附加组ID

  # 系统资源管理
  - 117 # setresuid - 设置实际、有效和保存的用户ID
  - 118 # getresuid - 获取实际、有效和保存的用户ID
  - 119 # setresgid - 设置实际、有效和保存的组ID
  - 120 # getresgid - 获取实际、有效和保存的组ID

  # 系统时间管理
  - 121 # getpgid - 获取进程组ID
  - 122 # setfsuid - 设置文件系统用户ID
  - 123 # setfsgid - 设置文件系统组ID
  - 124 # getsid - 获取会话ID
  - 125 # capget - 获取进程权能
  - 126 # capset - 设置进程权能

  # 实时调度
  - 127 # rt_sigpending - 检查待处理信号
  - 128 # rt_sigtimedwait - 同步等待信号
  - 129 # rt_sigqueueinfo - 排队一个信号和数据
  - 130 # rt_sigsuspend - 等待信号

  # 高级进程管理
  - 131 # sigaltstack - 设置和获取信号栈上下文
  - 132 # utime - 改变文件的访问和修改时间
  - 133 # mknod - 创建特殊文件
  - 134 # uselib - 加载共享库
  - 135 # personality - 设置进程执行域

  # 系统调用
  - 136 # ustat - 获取文件系统统计信息
  - 137 # statfs - 获取文件系统信息
  - 138 # fstatfs - 获取文件系统信息
  - 139 # sysfs - 获取文件系统类型信息
  - 140 # getpriority - 获取程序调度优先级

  # 进程优先级
  - 141 # setpriority - 设置程序调度优先级
  - 142 # sched_setparam - 设置调度参数
  - 143 # sched_getparam - 获取调度参数
  - 144 # sched_setscheduler - 设置调度策略和参数
  - 145 # sched_getscheduler - 获取调度策略

  # 调度策略
  - 146 # sched_get_priority_max - 获取静态优先级上限
  - 147 # sched_get_priority_min - 获取静态优先级下限
  - 148 # sched_rr_get_interval - 获取时间片
  - 149 # mlock - 锁定内存页
  - 150 # munlock - 解锁内存页

  # 内存锁定
  - 151 # mlockall - 锁定进程的地址空间
  - 152 # munlockall - 解锁进程的地址空间
  - 153 # vhangup - 虚拟挂起终端
  - 154 # modify_ldt - 读取或写入本地描述符表
  - 155 # pivot_root - 改变根文件系统

  # 系统引导
  - 156 # _sysctl - 读取/写入系统参数
  - 157 # prctl - 操作进程或线程
  - 158 # arch_prctl - 设置架构特定的线程状态
  - 159 # adjtimex - 调整系统时钟

  # 文件系统控制
  - 161 # chroot - 改变根目录
  - 162 # sync - 同步文件系统缓冲区
  - 163 # acct - 切换进程记账
  - 164 # settimeofday - 设置时间和日期
  - 165 # mount - 挂载文件系统

  # 系统维护
  - 166 # umount2 - 卸载文件系统
  - 167 # swapon - 开启交换设备和文件
  - 168 # swapoff - 关闭交换设备和文件
  - 169 # reboot - 重新启动系统
  - 170 # sethostname - 设置系统主机名

  # 网络配置
  - 171 # setdomainname - 设置系统域名
  - 172 # iopl - 改变I/O权限级别
  - 173 # ioperm - 设置端口I/O权限
  - 174 # create_module - 创建可加载的模块项
  - 175 # init_module - 初始化内核模块

  # 内核模块
  - 176 # delete_module - 删除内核模块
  - 177 # get_kernel_syms - 检索导出的内核符号
  - 178 # query_module - 查询内核模块信息
  - 179 # quotactl - 操作文件系统配额
  - 180 # nfsservctl - NFS服务器控制

  # 系统信息查询
  - 181 # getpmsg - 接收控制消息
  - 182 # putpmsg - 发送控制消息
  - 183 # afs_syscall - 未实现的系统调用
  - 184 # tuxcall - 未实现的系统调用
  - 185 # security - 未实现的系统调用

  # 新增系统调用
  - 186 # gettid - 获取线程标识符
  - 187 # readahead - 预读文件到页面缓存
  - 188 # setxattr - 设置扩展属性
  - 189 # lsetxattr - 设置符号链接的扩展属性
  - 190 # fsetxattr - 设置文件描述符的扩展属性

  # 扩展属性操作
  - 191 # getxattr - 获取扩展属性
  - 192 # lgetxattr - 获取符号链接的扩展属性
  - 193 # fgetxattr - 获取文件描述符的扩展属性
  - 194 # listxattr - 列出扩展属性
  - 195 # llistxattr - 列出符号链接的扩展属性

  # 高级文件系统特性
  - 196 # flistxattr - 列出文件描述符的扩展属性
  - 197 # removexattr - 删除扩展属性
  - 198 # lremovexattr - 删除符号链接的扩展属性
  - 199 # fremovexattr - 删除文件描述符的扩展属性
  - 200 # tkill - 发送信号到线程

  # 时间管理
  - 201 # time - 获取时间
  - 202 # futex - 快速用户空间锁定
  - 203 # sched_setaffinity - 设置进程的CPU亲和性掩码
  - 204 # sched_getaffinity - 获取进程的CPU亲和性掩码
  - 205 # set_thread_area - 设置线程本地存储

  # 进程/线程控制
  - 206 # io_setup - 创建异步I/O上下文
  - 207 # io_destroy - 销毁异步I/O上下文
  - 208 # io_getevents - 从完成队列读取异步I/O事件
  - 209 # io_submit - 提交异步I/O块
  - 210 # io_cancel - 取消异步I/O操作

  # 异步I/O
  - 211 # get_thread_area - 获取线程本地存储
  - 212 # lookup_dcookie - 获取目录cookie的路径
  - 213 # epoll_create - 创建epoll实例
  - 214 # epoll_ctl_old - 旧的epoll控制接口
  - 215 # epoll_wait_old - 旧的epoll等待接口

  # 事件通知
  - 216 # remap_file_pages - 创建非线性文件映射
  - 217 # getdents64 - 获取目录项（64位版本）
  - 218 # set_tid_address - 设置清除子线程ID的地址
  - 219 # restart_syscall - 重启被中断的系统调用
  - 220 # semtimedop - 带超时的信号量操作

  # 定时器和时钟
  - 221 # fadvise64 - 预声明访问模式
  - 222 # timer_create - 创建POSIX定时器
  - 223 # timer_settime - 设置定时器的时间
  - 224 # timer_gettime - 获取定时器的时间
  - 225 # timer_getoverrun - 获取定时器超限次数

  # POSIX定时器
  - 226 # timer_delete - 删除POSIX定时器
  - 227 # clock_settime - 设置指定时钟的时间
  - 228 # clock_gettime - 获取指定时钟的时间
  - 229 # clock_getres - 获取时钟精度
  - 230 # clock_nanosleep - 高精度睡眠

  # 进程终止
  - 231 # exit_group - 终止所有线程
  - 232 # epoll_wait - 等待epoll事件
  - 233 # epoll_ctl - 控制epoll实例
  - 234 # tgkill - 发送信号到线程
  - 235 # utimes - 更改文件访问和修改时间

  # 虚拟内存操作
  - 236 # vserver - Linux-VServer操作
  - 237 # mbind - 设置内存策略
  - 238 # set_mempolicy - 设置NUMA内存策略
  - 239 # get_mempolicy - 检索NUMA内存策略
  - 240 # mq_open - 打开消息队列

  # POSIX消息队列
  - 241 # mq_unlink - 删除消息队列
  - 242 # mq_timedsend - 发送消息到队列
  - 243 # mq_timedreceive - 从队列接收消息
  - 244 # mq_notify - 注册消息队列通知
  - 245 # mq_getsetattr - 获取/设置消息队列属性

  # 密钥管理
  - 246 # kexec_load - 加载新内核
  - 247 # waitid - 等待进程状态改变
  - 248 # add_key - 添加密钥到内核密钥管理系统
  - 249 # request_key - 请求操作密钥
  - 250 # keyctl - 密钥管理控制

  # 输入输出多路复用
  - 251 # ioprio_set - 设置I/O调度优先级
  - 252 # ioprio_get - 获取I/O调度优先级
  - 253 # inotify_init - 初始化inotify实例
  - 254 # inotify_add_watch - 添加inotify监视
  - 255 # inotify_rm_watch - 删除inotify监视

  # 文件系统监控
  - 256 # migrate_pages - 在NUMA系统中迁移进程页
  - 257 # openat - 相对路径打开文件
  - 258 # mkdirat - 相对路径创建目录
  - 259 # mknodat - 相对路径创建特殊文件
  - 260 # fchownat - 相对路径改变所有权

  # 相对路径操作
  - 261 # futimesat - 相对路径更改时间戳
  - 262 # newfstatat - 相对路径获取文件状态
  - 263 # unlinkat - 相对路径删除文件
  - 264 # renameat - 相对路径重命名
  - 265 # linkat - 相对路径创建硬链接

  # 符号链接操作
  - 266 # symlinkat - 相对路径创建符号链接
  - 267 # readlinkat - 相对路径读取符号链接
  - 268 # fchmodat - 相对路径改变权限
  - 269 # faccessat - 相对路径检查访问权限
  - 270 # pselect6 - 改进的select系统调用

  # 高级I/O操作
  - 271 # ppoll - 改进的poll系统调用
  - 272 # unshare - 解除共享命名空间
  - 273 # set_robust_list - 设置健壮的futex列表
  - 274 # get_robust_list - 获取健壮的futex列表
  - 275 # splice - 在文件描述符之间移动数据

  # 零拷贝操作
  - 276 # tee - 复制管道数据
  - 277 # sync_file_range - 同步文件段
  - 278 # vmsplice - 在进程和内核之间传输数据
  - 279 # move_pages - 在NUMA系统中移动页面
  - 280 # utimensat - 相对路径更改文件时间戳

  # 事件通知
  - 281 # epoll_pwait - 等待epoll事件，可中断
  - 282 # signalfd - 创建信号接收文件描述符
  - 283 # timerfd_create - 创建定时器文件描述符
  - 284 # eventfd - 创建事件通知文件描述符
  - 285 # fallocate - 预分配文件空间

  # 定时器操作
  - 286 # timerfd_settime - 设置定时器文件描述符
  - 287 # timerfd_gettime - 读取定时器文件描述符
  - 288 # accept4 - 接受带标志的连接
  - 289 # signalfd4 - 改进的signalfd
  - 290 # eventfd2 - 改进的eventfd

  # 文件系统操作
  - 291 # epoll_create1 - 改进的epoll_create
  - 292 # dup3 - 改进的dup2
  - 293 # pipe2 - 改进的pipe
  - 294 # inotify_init1 - 改进的inotify_init
  - 295 # preadv - 向量化的pread

  # 向量I/O操作
  - 296 # pwritev - 向量化的pwrite
  - 297 # rt_tgsigqueueinfo - 排队实时信号到线程组
  - 298 # perf_event_open - 性能监控
  - 299 # recvmmsg - 接收多个消息
  - 300 # fanotify_init - 初始化fanotify

  # 文件系统通知
  - 301 # fanotify_mark - 管理fanotify标记
  - 302 # prlimit64 - 获取/设置资源限制
  - 303 # name_to_handle_at - 文件句柄操作
  - 304 # open_by_handle_at - 通过文件句柄打开
  - 305 # clock_adjtime - 调整系统时钟

  # 同步操作
  - 306 # syncfs - 同步文件系统
  - 307 # sendmmsg - 发送多个消息
  - 308 # setns - 设置命名空间
  - 309 # getcpu - 获取CPU和NUMA节点
  - 310 # process_vm_readv - 进程间读取数据

  # 进程间通信
  - 311 # process_vm_writev - 进程间写入数据
  - 312 # kcmp - 内核比较两个进程
  - 313 # finit_module - 从文件描述符加载内核模块
  - 314 # sched_setattr - 设置调度属性
  - 315 # sched_getattr - 获取调度属性

  # 安全计算
  - 316 # renameat2 - 扩展的重命名操作
  - 317 # seccomp - 设置安全计算模式
  - 318 # getrandom - 获取随机数
  - 319 # memfd_create - 创建匿名文件
  - 320 # kexec_file_load - 从文件加载新内核

  # 命名空间操作
  - 321 # bpf - 扩展的BPF系统调用
  - 322 # execveat - 相对路径执行程序
  - 323 # userfaultfd - 用户页错误处理
  - 324 # membarrier - 发出内存屏障
  - 325 # mlock2 - 改进的内存锁定

  # 套接字操作
  - 326 # copy_file_range - 复制文件范围
  - 327 # preadv2 - 带标志的向量化pread
  - 328 # pwritev2 - 带标志的向量化pwrite
  - 329 # pkey_mprotect - 设置内存保护键
  - 330 # pkey_alloc - 分配内存保护键

  # 内存保护
  - 331 # pkey_free - 释放内存保护键
  - 332 # statx - 扩展的文件状态
  - 333 # io_pgetevents - 获取异步I/O事件
  - 334 # rseq - 重启序列
  - 335 # pidfd_send_signal - 通过文件描述符发送信号
proxy:
  socks5: ''
  http: ''
  https: ''

```

## volumes/sandbox/dependencies 增加python的包

```
mysql-connector==3.2.9
```


## ssrf_proxy/squid.conf.template

```
http_access deny !Safe_ports
# 允许非ssl访问
# http_access deny CONNECT !SSL_ports
http_access allow localhost manager
```