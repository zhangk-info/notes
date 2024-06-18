### 配置集群从私有仓库使用http和非tls方式拉取镜像

集群管理：
1. 镜像仓库中配置Mirror 配置mirror端点时必须使用http://标记
2. 仓库验证：为每个镜像仓库主机名和 Mirror 定义 TLS 和凭证配置。 仓库验证勾选跳过tls验证

### charts仓库

应用商店地址	RANCHER REPO地址	GITEE地址
https://git.rancher.io/helm3-charts	https://github.com/rancher/helm3-charts	https://gitee.com/rancher/helm3-charts
https://git.rancher.io/charts	https://github.com/rancher/charts	https://gitee.com/rancher/charts
https://git.rancher.io/system-charts	https://github.com/rancher/system-charts	https://gitee.com/rancher/system-charts