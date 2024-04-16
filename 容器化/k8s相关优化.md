## k8s优化或问题处理

### 问题
* failed to create fsnotify watcher: too many open files


max_user_watches:设置inotifywait或inotifywatch命令可以监视的文件数量（单进程）
max_user_instances:设置每个用户可以运行的inotifywait或inotifywatch命令的进程数。
max_queued_events：设置inotify实例事件（event）队列可容纳的事件数量。

echo fs.inotify.max_user_instances=8192| tee -a /etc/sysctl.conf && sudo sysctl -p
echo fs.inotify.max_user_watches=524288| tee -a /etc/sysctl.conf && sudo sysctl -p


* 