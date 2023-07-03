#elasticsearch docker 启动
官网 https://www.elastic.co/guide/en/elasticsearch/reference/7.13/docker.html#docker-cli-run-dev-mode

```
docker run --name elasticsearch -p 9200:9200 -p 9300:9300 \
-e "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
-v /mnt/docker-volumes/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /mnt/docker-volumes/elasticsearch/data:/usr/share/elasticsearch/data \
-v /mnt/docker-volumes/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
-d docker.elastic.co/elasticsearch/elasticsearch:7.13.4

这里不建议用docker.elastic.co/elasticsearch/elasticsearch:7.13.4外网的

docker run --name elasticsearch -p 9200:9200 -p 9300:9300 \
-e "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
-v /data/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /data/elasticsearch/data:/usr/share/elasticsearch/data \
-v /data/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
--restart=always --privileged=true \
-d docker.elastic.co/elasticsearch/elasticsearch:8.1.1

docker run --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v D:/docker/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v D:\docker/elasticsearch/data:/usr/share/elasticsearch/data -v D:\docker/elasticsearch/plugins:/usr/share/elasticsearch/plugins --restart=always --privileged=true -d docker.elastic.co/elasticsearch/elasticsearch:8.8.1

可能会出现 container init exited prematurely 是文件的问题 elasticsearch.yml需要先创建
chmod -R 777 /mnt/docker-volumes/elasticsearch

在elasticsearch.yml中写入 
network.host: 0.0.0.0
cluster.name : elasticsearch

重启 访问 ： http://ip:9200/

设置密码：docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-reset-password auto -u elastic
账号：elastic
rgW4rvClLke_7pKpnncc
```

* docker run --name elasticsearch 创建一个es容器并起一个名字；
* -p 9200:9200 将linux的9200端口映射到docker容器的9200端口，用来给es发送http请求
* -p 9300:9300 9300是es在分布式集群状态下节点之间的通信端口 \ 换行符
* -e 指定一个参数，当前es以单节点模式运行
* *注意，ES_JAVA_OPTS非常重要，指定开发时es运行时的最小和最大内存占用为64M和128M，否则就会占用全部可用内存
* -v 挂载命令，将虚拟机中的路径和docker中的路径进行关联
* -d 后台启动服务

# 安装可视化界面

```

docker run --name kibana -e ELASTICSEARCH_HOSTS=http://192.168.51.26:9200/ -p 5601:5601 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.13.4

docker run --name kibana --link YOUR_ELASTICSEARCH_CONTAINER_NAME_OR_ID:elasticsearch -p 5601:5601 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.13.4


docker run --name kibana --link elasticsearch:elasticsearch -p 5601:5601 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.13.4 

http://ip:5601/

server.port: 5602
server.host: "0.0.0.0" # !important
server.name: "kibana" # !important
elasticsearch.hosts: ["http://192.168.51.26:9200"] # !important
elasticsearch.username: "kibana_system"
elasticsearch.password: "7pPCu_qxSYYylqvZemJF"
# 可选
xpack.security.enabled: true
xpack.security.encryptionKey: "something_at_least_32_characters"
xpack.encryptedSavedObjects.encryptionKey: encryptedSavedObjects12345678909876543210
xpack.reporting.encryptionKey: encryptionKeyreporting12345678909876543210

docker run --name kibana -e ELASTICSEARCH_HOSTS=http://192.168.51.26:9200/ -p 5602:5602 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.13.4

docker run -d --name kibana -p 5602:5602 -v D:\docker/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml kibana:8.8.1

docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-reset-password auto -u kibana_system
账号：kibana_system
7pPCu_qxSYYylqvZemJF

访问后使用 elstic账号登录

```

* 注意 8.0之后kibana不可以使用elastic账号登录

https://www.elastic.co/guide/en/elasticsearch/reference/8.0/service-accounts.html

https://www.elastic.co/guide/en/elasticsearch/reference/8.0/built-in-roles.html


# 安装中文分词器
在plugins目录下创建目录ik 下载插件并解压授权
wget https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.13.4/elasticsearch-analysis-ik-7.13.4.zip

# elasticsearch设置密码

docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-reset-password auto -u elastic

https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls-docker.html