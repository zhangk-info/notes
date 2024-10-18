```

SPRING_DATASOURCE_PLATFORM	单机模式下支持MYSQL数据库	mysql / 空 默认:空
MYSQL_SERVICE_HOST	数据库 连接地址	
MYSQL_SERVICE_PORT	数据库端口	默认 : 3306
MYSQL_SERVICE_DB_NAME	数据库库名	
MYSQL_SERVICE_USER	数据库用户名	
MYSQL_SERVICE_PASSWORD	数据库用户密码	
MYSQL_SERVICE_DB_PARAM	数据库连接参数 默认 : characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true


docker run --name nacos -e MODE=standalone -e SPRING_DATASOURCE_PLATFORM=mysql -e MYSQL_SERVICE_HOST=192.168.50.209 -e MYSQL_SERVICE_PORT=3306 -e MYSQL_SERVICE_DB_NAME=nacos -e MYSQL_SERVICE_USER=root -e "MYSQL_SERVICE_PASSWORD=root..123" -e "MYSQL_SERVICE_DB_PARAM=characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true" -p 8848:8848 -p 9848:9848 -d --restart=always nacos/nacos-server:v2.2.0


docker run -d -p 18848:8848 -p 19848:9848 -p 19849:9849 -e MODE=standalone -w /home/nacos -v /data/nacos/conf:/home/nacos/conf -v /data/nacos/data:/home/nacos/data --restart always --name nacos nacos/nacos-server:v2.0.4

https://nacos.io/en-us/docs/auth.html 开启注册认证

-e NACOS_AUTH_ENABLE=true

```
```
spring:
    cloud:
        config:     # 测试环境nacos不覆盖本地配置
            allow-override: false     # true 允许nacos被本地文件和和系统属性覆盖
            override-none: false     # true nacos不覆盖任何本地文件和系统属性
            override-system-properties: false   # true nacos 覆盖系统属性。注意本地文件不是系统属性。设置为false之后才能通过-D参数配置且不会被本地文件覆盖。

```