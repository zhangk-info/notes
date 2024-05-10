## k8s优化或问题处理

### 问题
* failed to create fsnotify watcher: too many open files

#### 查看
ulimit -n


## 修改文件数（连接数）
* 方法1：ulimit -n 65535
* 方法2：
```
vim /etc/security/limits.conf

* hard nofile 20000
* soft nofile 15000
* soft nproc 65535
* hard nproc 65535

```

sudo sysctl -p


#### 配置解释
max_user_watches:设置inotifywait或inotifywatch命令可以监视的文件数量（单进程）
max_user_instances:设置每个用户可以运行的inotifywait或inotifywatch命令的进程数。
max_queued_events：设置inotify实例事件（event）队列可容纳的事件数量。

#### 最大值（不建议）
echo fs.inotify.max_user_instances=8192| tee -a /etc/sysctl.conf && sudo sysctl -p
echo fs.inotify.max_user_watches=524288| tee -a /etc/sysctl.conf && sudo sysctl -p

#### 适中值
echo fs.inotify.max_user_instances=4096| tee -a /etc/sysctl.conf && sudo sysctl -p
echo fs.inotify.max_user_watches=314288| tee -a /etc/sysctl.conf && sudo sysctl -p



