## tidb rancher部署

1. 部署 local-volume-provisioner
    *
    wget https://raw.githubusercontent.com/pingcap/tidb-operator/v1.5.2/examples/local-pv/local-volume-provisioner.yaml
    * kubectl apply -f ./local-volume-provisioner.yaml
2. 创建 CRD
    * wget https://raw.githubusercontent.com/pingcap/tidb-operator/v1.5.2/manifests/crd.yaml
    * kubectl create -f ./crd.yaml
3. 部署 TiDB Operator
    * charts仓库配置： http://charts.pingcap.org
    * 安装应用 Chart: tidb-operator (v1.5.2)
4. 部署 tidb-cluster
    * wget https://raw.githubusercontent.com/pingcap/tidb-operator/v1.5.2/examples/basic-cn/tidb-cluster.yaml
    * kubectl -n default apply -f ./tidb-cluster.yaml
    * 此时会挨个等待pv建立
        * 建立pd需要的pv 创建pv 名字随意 local-volume-provisioner 自动给pvc绑定 可以叫 local-ssd
        * 建立kv需要的pv 创建pv 名字随意 自动给pvc绑定
5. 初始化tidb集群 可能会失败，失败的话连接后手动更改密码 初始密码为空
    * kubectl create secret generic tidb-secret --from-literal=root=root..123 --namespace=default
    * https://raw.githubusercontent.com/pingcap/tidb-operator/v1.5.2/examples/initialize/tidb-initializer.yaml
    * kubectl apply -f ./tidb-initializer.yaml --namespace=default
7. 