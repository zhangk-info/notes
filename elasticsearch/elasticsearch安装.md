
#elasticsearch docker 启动
```
docker run --name elasticsearch -p 9200:9200 -p 9300:9300 \
-e "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
-v /mnt/docker-volumes/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /mnt/docker-volumes/elasticsearch/data:/usr/share/elasticsearch/data \
-v /mnt/docker-volumes/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.10.1


docker run --name elasticsearch -p 9200:9200 -p 9300:9300 \
-e "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms512m -Xmx512m" \
-v /mnt/docker-volumes/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v /mnt/docker-volumes/elasticsearch/data:/usr/share/elasticsearch/data \
-v /mnt/docker-volumes/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
-d elasticsearch:7.10.1

chmod -R 777 /mnt/docker-volumes/elasticsearch
在elasticsearch中写入 
http.host : 0.0.0.0
cluster.name : elasticsearch

重启 访问 ： http://ip:9200/

```


* docker run --name elasticsearch 创建一个es容器并起一个名字；
* -p 9200:9200 将linux的9200端口映射到docker容器的9200端口，用来给es发送http请求
* -p 9300:9300 9300是es在分布式集群状态下节点之间的通信端口  \ 换行符
* -e 指定一个参数，当前es以单节点模式运行
* *注意，ES_JAVA_OPTS非常重要，指定开发时es运行时的最小和最大内存占用为64M和128M，否则就会占用全部可用内存
* -v 挂载命令，将虚拟机中的路径和docker中的路径进行关联
* -d 后台启动服务


#安装可视化界面
```

docker run --name kibana -e ELASTICSEARCH_HOSTS=http://192.168.200.30:9200/ -p 5601:5601 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.10.1

docker run --name kibana --link YOUR_ELASTICSEARCH_CONTAINER_NAME_OR_ID:elasticsearch -p 5601:5601 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.10.1


docker run --name kibana --link elasticsearch:elasticsearch -p 5601:5601 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.10.1 

http://ip:5601/


server.port: 5602
# !important
server.host: "0.0.0.0"
server.name: "kibana"
# !important
elasticsearch.url: ["http://192.168.200.30:9200"]
kibana.index: ".kibana"
elasticsearch.username: "elastic"
elasticsearch.password: "paic1234A"
xpack.security.enabled: true
xpack.security.encryptionKey: "something_at_least_32_characters"
xpack.encryptedSavedObjects.encryptionKey: encryptedSavedObjects12345678909876543210
xpack.reporting.encryptionKey: encryptionKeyreporting12345678909876543210

docker run --name kibana -e ELASTICSEARCH_HOSTS=http://192.168.200.30:9200/ -p 5602:5602 \
-v /mnt/docker-volumes/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml \
-d kibana:7.10.1

```

#安装中文分词器
在plugins目录下创建目录ik 下载插件并解压授权
wget https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.10.1/elasticsearch-analysis-ik-7.10.1.zip