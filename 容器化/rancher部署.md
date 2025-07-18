# 部署命令：
https://docs.rancher.cn/docs/rancher2.5/installation/other-installation-methods/single-node-docker/_index
https://www.suse.com/ja-jp/suse-rancher/support-matrix/all-supported-versions/rancher-v2-7-9/
注意：rancher所有版本均不支持centos8，k8s集群使用iptables1.16管理网络
1. 获取root权限
sudo su root
2. 开启ssh
apt update
apt install ssh
3. 其他工具安装
apt install net-tools
4. 开放22端口
ufw allow 22/tcp
ufw reload
5. docker安装
apt install curl
curl https://releases.rancher.com/install-docker/20.10.sh | sh
或者
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
6. 修改linux的内核参数，添加网桥过滤和地址转发功能
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
7. 加载网桥过滤模块
modprobe br_netfilter
lsmod | grep br_netfilter

8. 启动docker并设置开机自启
systemctl start docker
systemctl enable docker
9. 时间同步（待定检测必要性）
kubernetes要求集群中的节点时间必须精确一致，这里直接使用chronyd服务从网络同步时间；也可以使用网络授时NTP。
企业中建议配置内部的时间同步服务器。
#若chrony不存在,使用apt-get安装
$ apt-get install -y chrony
# 启动chronyd服务 若启动出现错误 查看问题汇总中问题10
$ systemctl start chronyd
# 设置chronyd服务开机自启
$ systemctl enable chronyd
# chronyd服务启动稍等几秒钟，就可以使用date命令验证时间了
$ date
10. 其他前置要求（ubuntu暂时不需要）
https://docs.rancher.cn/docs/k3s/advanced/_index/#%E5%9C%A8-raspbian-buster-%E4%B8%8A%E5%90%AF%E7%94%A8%E6%97%A7%E7%89%88%E7%9A%84-iptables
11. rancher安装
标签	描述
rancher/rancher:latest	我们的最新版本。这些构建通过了我们的 CI 自动化验证。我们不建议将这些版本用于生产环境。
rancher/rancher:stable	我们最新的稳定版本。建议将此标签用于生产。
rancher/rancher:<v2.X.X>	您可以使用标签来安装特定版本的 Rancher。您到 DockerHub 上查看有哪些可用的版本
docker run -d --restart=unless-stopped \
-p 8080:80 -p 8443:443 \
-v /data/log/rancher/auditlog:/var/log/auditlog \
-e AUDIT_LEVEL=1 \
-v /data/rancher:/var/lib/rancher \
--name=rancher \
--privileged=true \
rancher/rancher:stable
12. 获取rancher密码
docker logs rancher 2>&1 | grep "Bootstrap Password:"
jpfbtv8zwllwt2xrglr8vgwzb4w8wppb4gbqprh7vh4q2wwzt2ck59
访问地址：https://192.168.1.160:8443/
账号密码：admin / yWvqigR3A3A8dZPb	jsyq / HTLQaM1KL3WBtmmg
13. 部署k3s集群(没有https证书，跳过了tls验证)
版本：v.126.8+rke2r1
● couldn't get resource list for management.cattle.io/v3问题，删除集群重新建一个再试
● error loading CA cert for probe (kube-controller-manager) /var/lib/rancher/rke2/server/tls/kube-controller-manager/kube-controller-manager.crt: no such file or directory, 等一下 10分钟左右，等controller plane启动起来

● K8s] received secret to process that was older than the last secret operated on. (3165701 vs 3165703)
● node名不唯一造成一直在waitting for xx join plane
● error syncing 'fleet-default/custom-9fa48dfe3725-machine-plan': handler secret-watch: secret received was too old, requeuing"
或者 duplicate hostname or contents of '/etc/rancher/node/password' may not match server node-passwd entry, try enabling a unique node name with the --with-node-id flag
从集群节点中删除不可用的重名节点

● 401 unauthorization
rm -rf /etc/rancher 之后它会重新拉password
● waiting for probes: calico calico一直上不去 pull image拉不下来 重启电脑解决
● 建议rancher的安装机器只部署worker （docker方式的话可以加所有）
严格来说，rancher所在的集群不能其他集群混用

/usr/local/bin/ 下提供了k3s卸载命令
实时查看systemctl服务日志:
journalctl -u rancher-system-agent -f
journalctl -u rke2-server -f
journalctl -u rke2-agent -f
journalctl -u k3s-agent -f

掉电后处理：
1. 无法从快照恢复：
    1. 备份etcd
    2. 删除etcd rancher启动
    3. 进入docker 恢复etcd
    etcdctl snapshot restore snapshots/xxx --data-dir /var/lib/rancher/k3s/server/db/etcd
    4.   重启rancher
2. 自定义集群从快照恢复
    1. 备份etcd
    2. 删除etcd
    3. 恢复etcd
    ETCDCTL_API=3 etcdctl snapshot restore <etcd的数据存储目录> --data-dir  <备份存放目录>
    --cert=/etc/kubernetes/pki/etcd/server.crt  \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt  \
    --key=/etc/kubernetes/pki/etcd/server.key \
    --endpoints=<https://当前主机IP:2379> \
    --name=<你当前主机的etcd名称> \
    --initial-cluster-token=<etcd的token>  \
    --initial-advertise-peer-urls=<https://当前主机IP:2380>  \
    --initial-cluster=<etcd集群>  \
    解释：以上需要的参数大多都在ETCD的配置文件中可以找到，若不指定则使用默认配置恢复，可能会导致全体leader状态。 一定要保留config和name文件
    /var/lib/rancher/rke2/agent/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots/4/fs/usr/local/bin/etcdctl snapshot \
    restore snapshots/on-demand-161-1706256411 --data-dir ./etcd \
    --endpoints=https://192.168.1.161:2379 \
    --initial-cluster="default=https://192.168.1.161:2380" \
    --initial-advertise-peer-urls="https://192.168.1.161:2380"

rancher-local:
/var/lib/docker/overlay2/5ef7d5c21b9db89e07540555ef05bd107f7cbdd8f9727cb054461c3af34deb41/diff/usr/bin/etcdctl snapshot \
restore snapshots/etcd-snapshot-local-node-1730203202 --data-dir ./etcd

一定要保留config和name文件

集群etcd异常后恢复尽量使用rancher自带的快照恢复，kube-apiserver连上就可以恢复，不一定所有服务都连上
161：
/var/lib/rancher/rke2/agent/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots/4/fs/usr/local/bin/etcdctl snapshot \
restore snapshots/etcd-snapshot-161-1718744401 --data-dir ./etcd \
--initial-cluster="162-173593c8=https://192.168.10.162:2380,default=https://192.168.10.161:2380" \
--initial-advertise-peer-urls="https://192.168.10.161:2380"

162：
/var/lib/rancher/rke2/agent/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots/4/fs/usr/local/bin/etcdctl snapshot \
restore snapshots/etcd-snapshot-162-1718762401 --data-dir ./etcd \
--initial-cluster="default=https://192.168.10.162:2380,161-8fed7818=https://192.168.10.161:2380" \
--initial-advertise-peer-urls="https://192.168.10.162:2380"  


恢复集群方式2：
1. 在1个etcd节点执行
rke2 server --cluster-reset --cluster-reset-restore-path=/var/lib/rancher/rke2/server/db/snapshots/etcd-snapshot-161-1730217604

启动rke2-server
2. 其他etcd节点
停止rke2-server 
删除 /var/lib/rancher/rke2/server/db/
启动rke2-server
3. 启动集群中其他节点


    4. 启动或重启k8s
3. 可能遇到的问题
   * a.crt newer than datastore and could cause a cluster outage
   删除tls文件 tls会从snapshot重新生成
   * b.his server is a not a member of the etcd cluster. Found [161-55d03930=http://localhost:2380], expect: 161-55d03930=https://192.168.1.161:2380"
   在config中增加


### 更改charts为国内
https://gitee.com/rancher/

## 集群连接：

```
kubectl 选项

      --alsologtostderr[=false]: 同时输出日志到标准错误控制台和文件。
      --api-version="": 和服务端交互使用的API版本。
      --certificate-authority="": 用以进行认证授权的.cert文件路径。
      --client-certificate="": TLS使用的客户端证书路径。
      --client-key="": TLS使用的客户端密钥路径。
      --cluster="": 指定使用的kubeconfig配置文件中的集群名。
      --context="": 指定使用的kubeconfig配置文件中的环境名。
      --insecure-skip-tls-verify[=false]: 如果为true，将不会检查服务器凭证的有效性，这会导致你的HTTPS链接变得不安全。
      --kubeconfig="": 命令行请求使用的配置文件路径。
      --log-backtrace-at=:0: 当日志长度超过定义的行数时，忽略堆栈信息。
      --log-dir="": 如果不为空，将日志文件写入此目录。
      --log-flush-frequency=5s: 刷新日志的最大时间间隔。
      --logtostderr[=true]: 输出日志到标准错误控制台，不输出到文件。
      --match-server-version[=false]: 要求服务端和客户端版本匹配。
      --namespace="": 如果不为空，命令将使用此namespace。
      --password="": API Server进行简单认证使用的密码。
  -s, --server="": Kubernetes API Server的地址和端口号。
      --stderrthreshold=2: 高于此级别的日志将被输出到错误控制台。
      --token="": 认证到API Server使用的令牌。
      --user="": 指定使用的kubeconfig配置文件中的用户名。
      --username="": API Server进行简单认证使用的用户名。
      --v=0: 指定输出日志的级别。
      --vmodule=: 指定输出日志的模块，格式如下：pattern=N，使用逗号分隔。
      
      --all-namespaces 所有命名空间
```


-- 获取所有命名空间下的所有pods
kubectl --client-certificate=/var/lib/rancher/rke2/agent/client-kubelet.crt --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --client-key=/var/lib/rancher/rke2/agent/client-kubelet.key --insecure-skip-tls-verify=true  get pods --all-namespaces

kubectl --client-certificate=/var/lib/rancher/rke2/agent/client-kubelet.crt --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --client-key=/var/lib/rancher/rke2/agent/client-kubelet.key --insecure-skip-tls-verify=true  get pods -n njjs -A -o wide | grep 160
以下只能在管理节点操作 切换到管理人员的client-certificate
-- 获取deployments
kubectl --client-certificate=/var/lib/rancher/rke2/server/tls/client-admin.crt --client-key=/var/lib/rancher/rke2/server/tls/client-admin.key --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --insecure-skip-tls-verify=true  get deployments --namespace=njjs
-- 查看集群节点
kubectl --client-certificate=/var/lib/rancher/rke2/server/tls/client-admin.crt --client-key=/var/lib/rancher/rke2/server/tls/client-admin.key --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --insecure-skip-tls-verify=true  get nodes
--查看app日志
kubectl --client-certificate=/var/lib/rancher/rke2/server/tls/client-admin.crt --client-key=/var/lib/rancher/rke2/server/tls/client-admin.key --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --insecure-skip-tls-verify=true -n cattle-system logs -l app=cattle-cluster-agent 
### 更改资源节点数量 
kubectl --client-certificate=/var/lib/rancher/rke2/server/tls/client-admin.crt --client-key=/var/lib/rancher/rke2/server/tls/client-admin.key --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --insecure-skip-tls-verify=true --namespace=njjs scale --replicas=0 deployment/park-server-access

kubectl apply -f https://192.168.10.160:8443/v3/import/zb7c6qvvz4kbpvhmckmlclkj4vpfmfcpzf8gl5bz2tmclpnrgnrhd8_c-m-g9xj445l.yaml --client-certificate=/var/lib/rancher/rke2/server/tls/client-admin.crt --client-key=/var/lib/rancher/rke2/server/tls/client-admin.key --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --insecure-skip-tls-verify=true



### rke 方式
rke up

kubectl --kubeconfig kube_config_cluster.yml get nodes

rke etcd snapshot-restore --config cluster.yml --name 2025-06-26T00:36:39Z_etcd

kubectl  --kubeconfig kube_config_cluster.yml get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.capacity.cpu}{"\t"}{.status.capacity.memory}{"\n"}{end}'


1. 查看rancher状态 docker logs -n10 -f rancher
2. 恢复 rancher etcd
    * docker stop rancher
    * cd /data/rancher/k3s/server/db
    * 找到snapshots下最新的文件
    * etcd恢复：/var/lib/docker/overlay2/5ef7d5c21b9db89e07540555ef05bd107f7cbdd8f9727cb054461c3af34deb41/diff/usr/bin/etcdctl snapshot \
   restore snapshots/etcd-snapshot-xx --data-dir ./etcd
    * docker start rancher
3. 查看rke2-server状态 systemctl status rke2-server  /  journalctl -u rke2-server -f
4. 恢复rke2-server etcd
    * systemctl stop rke2-server
    * 找到snapshots下最新的文件 /var/lib/rancher/rke2/server/db/snapshots
    * etcd恢复：rke2 server --cluster-reset --cluster-reset-restore-path=/var/lib/rancher/rke2/server/db/snapshots/etcd-snapshot-161-xxx
    * 查看状态，如果没启动再启动一下 systemctl start rke2-server
5. 查看rke2-agent状态 systemctl status rke2-agent 
6. 查看k8s集群状态
   * 160执行：kubectl --client-certificate=/var/lib/rancher/rke2/server/tls/client-admin.crt --client-key=/var/lib/rancher/rke2/server/tls/client-admin.key --kubeconfig=/var/lib/rancher/rke2/agent/kubelet.kubeconfig --insecure-skip-tls-verify=true  get nodes
   * 所有节点active
7. 查看rancher等待集群中的pod恢复