# docker

## 安装（启动一个standalone使用 ElasticSearch 7 作为存储的容器，其地址为elasticsearch:9200）

docker run --name oap --restart always -d -e SW_STORAGE=elasticsearch -e SW_STORAGE_ES_CLUSTER_NODES=192.168.51.26:9200 -v D:\docker\skywalking\config apache/skywalking-oap-server:9.0.0

### 如果您打算覆盖或添加配置文件/skywalking/config，/skywalking/ext-config则可以在其中放置额外文件。同名文件将被覆盖；否则，它们将被添加到/skywalking/config.

## 参考文档

* skywalking极简入门

https://skywalking.apache.org/zh/2020-04-19-skywalking-quick-start/

*

## 常见问题

1. SkyWalking 依赖 elasticsearch 集群，如果 elasticsearch 安装有 x-pack 插件的话，那么就会存在一个 Basic 认证，导致
   skywalking 无法调用 elasticsearch。

```
解决方法是使用 nginx 做代理，让 nginx 来做这个 Basic 认证，那么这个问题就自然解决了。

方法如下:

安装 nginx
yum install -y nginx

配置 nginx
server {
listen 9200 default_server;
server_name  _;

        location / {
                 proxy_set_header Host $host;
                 proxy_set_header X-Real-IP $remote_addr;
                 proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                 proxy_pass http://localhost:9200;
                 #Basic字符串就是使用你的用户名(admin),密码(12345)编码后的值
                 #注意:在进行Basic加密的时候要使用如下格式如:admin:123456 注意中间有个冒号
                 proxy_set_header Authorization "Basic YWRtaW4gMTIzNDU2";
        }
    }

验证
curl localhost:9200
```
