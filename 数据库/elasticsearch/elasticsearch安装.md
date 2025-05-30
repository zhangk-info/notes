#elasticsearch docker 启动
官网 https://www.elastic.co/guide/en/elasticsearch/reference/7.13/docker.html#docker-cli-run-dev-mode

```

chmod -R 777 /home/frame/Public/docker_data/es

需要先生成密码文件再挂载方式(并需要输入秘钥)启动，否则：device_or_resource_busy:
https://www.elastic.co/guide/en/elasticsearch/reference/8.8/docker.html#_elasticsearch_keystore_device_or_resource_busy

-- 生成最高级密码文件 后续创建用户和更改密码都需要先输入这个文件的密码
docker run -it --rm --user=root --privileged=true -v /home/frame/Public/docker_data/es/config:/usr/share/elasticsearch/config docker.elastic.co/elasticsearch/elasticsearch:8.8.1 bin/elasticsearch-keystore create -p
上一步生成的密码用于修改配置登信息时需要，如下面的设置密码
docker run -d --name es --privileged=true -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v /home/frame/Public/docker_data/es/data:/usr/share/elasticsearch/data -v /home/frame/Public/docker_data/es/plugins:/usr/share/elasticsearch/plugins -v /home/frame/Public/docker_data/es/config/elasticsearch.keystore:/usr/share/elasticsearch/config/elasticsearch.keystore -e KEYSTORE_PASSWORD=password --restart=always docker.elastic.co/elasticsearch/elasticsearch:8.8.1 

重启 访问 ： http://ip:9200/

设置密码：docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-reset-password auto -u elastic
docker exec --user=root -it es /usr/share/elasticsearch/bin/elasticsearch-reset-password auto -u elastic
账号：elastic
rgW4rvClLke_7pKpnncc
```

/data/elastic/plugins:/usr/share/elasticsearch/plugins

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