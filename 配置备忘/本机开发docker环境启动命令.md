# docker启动命令整理

## nginx

docker run --name nginx -p80:80 -d -v D:\docker/nginx/conf/:/etc/nginx -v D:\Workspace\demo\skywalking-booster-ui-9.5.0\dist:/etc/nginx/html -v D:\docker/nginx/ssl:/data/ssl nginx

## es

docker run -d --name elasticsearch --privileged=true -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -v D:\docker/elasticsearch/data:/usr/share/elasticsearch/data -v D:\docker/elasticsearch/plugins:/usr/share/elasticsearch/plugins --restart=always docker.elastic.co/elasticsearch/elasticsearch:8.8.1

账号&密码：elastic/rgW4rvClLke_7pKpnncc

## kibana

docker run -d --name kibana -p 5602:5602 -v D:\docker/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml kibana:8.8.1

账号&密码：kibana_system/7pPCu_qxSYYylqvZemJF

## mysql

docker run -d --restart=always -p 3306:3306 -v D:\docker\mysql\conf:/etc/mysql/conf.d -v D:\docker\mysql\data:/var/lib/mysql -v D:\docker\mysql\log:/var/log -e MYSQL_ROOT_PASSWORD=root..123 --name mysql mysql:latest

账号&密码：root/root..123

## nacos

docker run --name nacos -e MODE=standalone -e SPRING_DATASOURCE_PLATFORM=mysql -e MYSQL_SERVICE_HOST=192.168.50.167 -e MYSQL_SERVICE_PORT=3306 -e MYSQL_SERVICE_DB_NAME=nacos -e MYSQL_SERVICE_USER=root -e "MYSQL_SERVICE_PASSWORD=root..123" -e "MYSQL_SERVICE_DB_PARAM=characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true" -p 8848:8848 -p 9848:9848 -d --restart=always nacos/nacos-server:v2.2.0

## prometheus

docker run -d --restart=always -p 9090:9090 --name=prometheus -v D:\docker\prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v D:\docker\prometheus/prometheus-data:/prometheus prom/prometheus

## grafana

docker run -d --restart=always -p 3000:3000 --name=grafana -v D:\docker\grafana:/var/lib/grafana -v D:\docker\grafana\grafana.ini:/etc/grafana/grafana.ini -v D:\docker\grafana\log:/var/log/grafana grafana/grafana-enterprise

账号&密码：admin/123456

## skywalking

docker run --name oap --restart always -d -p 11800:11800 -p 12800:12800 -e SW_AUTHENTICATION=agent-password -e SW_STORAGE=elasticsearch -e SW_STORAGE_ES_CLUSTER_NODES=192.168.51.26:9200 -e SW_ES_USER=elastic -e SW_ES_PASSWORD=rgW4rvClLke_7pKpnncc apache/skywalking-oap-server:9.5.0

## skywalking-ui

```
docker run --name oap-ui --restart always -d -p 13800:8080 -e SW_OAP_ADDRESS="http://192.168.51.26:12800" apache/skywalking-ui:9.5.0
```

## redis

docker run -p 6379:6379 --name redis -v D:\docker/redis/redis.conf:/etc/redis/redis.conf -v D:\docker/redis/data:/data -d  --restart=always --privileged=true redis redis-server /etc/redis/redis.conf

## rabbitm

docker run -d --restart=always --name rabbitmq -p 5672:5672 -p 15672:15672 -v D:\docker/rabbitmq:/var/lib/rabbitmq --hostname myRabbit -e RABBITMQ_DEFAULT_VHOST=my_vhost -e RABBITMQ_DEFAULT_USER=rabbit -e RABBITMQ_DEFAULT_PASS=rabbit rabbitmq:management

# sonar

docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest

账号&密码：admin/zhangkun..123
global analysis token : sqa_53cf2d757b7046511498372656cc42e7b619eba6

mvn clean verify sonar:sonar \
  -Dsonar.projectKey=ft-fast-datax \
  -Dsonar.projectName='ft-fast-datax' \
  -Dsonar.host.url=<http://localhost:9000> \
  -Dsonar.token=sqa_53cf2d757b7046511498372656cc42e7b619eba6

```
mvn clean verify -D sonar.projectKey=ft-fast-datax -D sonar.projectName='ft-fast-datax' -D sonar.host.url='http://localhost:9000' -D sonar.token=sqa_53cf2d757b7046511498372656cc42e7b619eba6  sonar:sonar
```

# seata
--restart=always

docker run --name seata-server -p 8091:8091 -d  -p 7091:7091  -e SEATA_IP=192.168.50.167 -v D:\docker/seata/application.yml:/seata-server/resources/application.yml  seataio/seata-server

# neo4j

docker run -d --name neo4j -p 7474:7474 -p 7687:7687 -v D:\docker/neo4j/data:/data -v D:\docker/neo4j/logs:/logs -v D:\docker/neo4j/conf:/var/lib/neo4j/conf -v D:\docker/neo4j/import:/var/lib/neo4j/import --env NEO4J_AUTH=neo4j/root..123 neo4j

# mongodb

docker run -d --name mongo -v D:\docker/mongodb/data:/data/db -p 27017:27017 mongo --auth

# pgsql

docker run -d --name pgvector -p 5432:5432 -e POSTGRES_PASSWORD=root..123 -e POSTGRES_USER=root -e POSTGRES_DB=vector -v D:\docker/postgresql/data:/var/lib/postgresql/data pgvector/pgvector:pg17


# flowise 10.162 

docker run -d -p 3000:3000 --name flowise -e DATABASE_TYPE=postgres  -e DATABASE_PORT=5432  -e DATABASE_HOST=192.168.10.162  -e DATABASE_NAME=flowise  -e DATABASE_USER=root  -e DATABASE_PASSWORD=root..123 -e APIKEY_STORAGE_TYPE=db -e FLOWISE_USERNAME=root -e FLOWISE_PASSWORD=root..123 -e LOG_LEVEL=debug -v /data/flowise:/root/.flowise 192.168.10.150:8090/base/flowiseai/flowise:2.2.5


docker run -d -p 4000:3000 --name flowise2 -e DATABASE_TYPE=postgres  -e DATABASE_PORT=5432  -e DATABASE_HOST=192.168.10.162  -e DATABASE_NAME=flowise  -e DATABASE_USER=root  -e DATABASE_PASSWORD=root..123 -e APIKEY_STORAGE_TYPE=db -v /data/flowise:/root/.flowise 192.168.10.150:8090/base/flowise2


# minio
docker run -p 9000:9000 -p 9001:9001 --name minio -d -e "MINIO_ROOT_USER=Ig7TOshcmcgkqG4U" -e "MINIO_ROOT_PASSWORD=tB4x0rmuaW42qobIGq4eRjA39BS0VVbq" -v D:\docker/minio/data:/data/minio  -v D:\docker/minio/config:/etc/config.env minio/minio:RELEASE.2025-04-22T22-12-26Z server /data/minio --console-address ":9001"



docker run -p 9000:9000 -p 9001:9001 --name minio -d --restart=always -e "MINIO_ROOT_USER=Ig7TOshcmcgkqG4U" -e "MINIO_ROOT_PASSWORD=tB4x0rmuaW42qobIGq4eRjA39BS0VVbq" -v D:\docker/minio/data:/data/minio  -v D:\docker/minio/config:/etc/config.env minio/minio:RELEASE.2025-04-22T22-12-26Z server /data --console-address ":9001"