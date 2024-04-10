# skywalking

## 安装（启动一个standalone使用 ElasticSearch 7 作为存储的容器，其地址为elasticsearch:9200）

docker run --name oap --restart always -d -p 11800:11800 -p 12800:12800 -e SW_AUTHENTICATION=agent-password -e SW_STORAGE=elasticsearch -e SW_STORAGE_ES_CLUSTER_NODES=192.168.51.26:9200 -e SW_ES_USER=elastic -e SW_ES_PASSWORD=rgW4rvClLke_7pKpnncc apache/skywalking-oap-server:9.5.0

ui:
docker run --name oap-ui --restart always -d -p 13800:8080 -e SW_OAP_ADDRESS=http://192.168.51.26:12800 apache/skywalking-ui:9.5.0

注意事项：

* 端口
  Backend listens on 0.0.0.0/11800 for gRPC APIs and 0.0.0.0/12800 for HTTP REST APIs.
  UI listens on 8080 port and request 127.0.0.1/12800 to run a GraphQL query.
* Before 8.8.0(<= 8.7.0), *-es6 image can only connect to Elasticsearch 6 when set SW_STORAGE=elasticsearch. You need to
  use *-es7 image when set SW_STORAGE=elasticsearch7.
* 如果您打算覆盖或添加配置文件/skywalking/config，/skywalking/ext-config则可以在其中放置额外文件。同名文件将被覆盖；否则，它们将被添加到/skywalking/config.

docker run --name nginx-oap-ui -d -p 13801:80 --restart=always -v /home/frame/Public/docker_data/oap-ui/log:/var/log/nginx  -v /home/frame/Public/docker_data/oap-ui/conf.d:/etc/nginx/conf.d -v /home/frame/Public/docker_data/oap-ui/html:/usr/share/nginx/html  nginx

更改了路由  
base: '/skywalking/',

更改了提示和代码
endpointTips: "这里最多展示20条endpoints。", -> endpointTips: "这里最多展示10条endpoints。",
async getEndpoints(params : limit: params.limit, -> limit: params.limit || 10,

1. 将static放入skywalking
2. 将index.html复制一份放入skywalking

### helm安装 
https://github.com/apache/skywalking-helm/tree/v4.5.0
ghcr.io Helm repository

helm -n istio-system install skywalking \
oci://ghcr.io/apache/skywalking-kubernetes/skywalking-helm \
--version "0.0.0-b670c41d94a82ddefcf466d54bab5c492d88d772" \
-n njjs \
--set oap.image.tag=9.2.0 \
--set oap.storageType=elasticsearch \
--set ui.image.tag=9.2.0

## 参考文档

* 官网

https://skywalking.apache.org/

* 中文文档

https://skyapm.github.io/document-cn-translation-of-skywalking/
https://github.com/SkyAPM/document-cn-translation-of-skywalking/blob/master/docs/zh/8.0.0/README.md

* 所有配置项

https://skywalking.apache.org/docs/main/v9.5.0/en/setup/backend/configuration-vocabulary/

* skywalking极简入门

https://skywalking.apache.org/zh/2020-04-19-skywalking-quick-start/

* 使用入门

https://skywalking.apache.org/zh/2018-12-18-apache-skywalking-5-0-userguide/

## 构建grafana Dashboard 需要开启9090的promql查询端口，然后下载dashboard的json并
文档地址 http://skywalking.incubator.apache.org/zh/2023-03-17-build-grafana-dashboards-for-apache-skywalking-native-promql-support/
演示地址 http://demo.skywalking.apache.org:3000/ skywalking/skywalking
dashboard下载地址 https://github.com/apache/skywalking-showcase/blob/main/deploy/platform/config/promql/dashboards/general-service.json
grafana插件下载地址 https://github.com/apache/skywalking-grafana-plugins
更改variable里面所有数据源和过滤条件，最后一个数据源是skywalking-plugin::12800/graphql
#### grafana自定义插件不加载
```
[plugins]
allow_loading_unsigned_plugins = skywalking-datasource

```

## agent使用
下载 解压

注意：对网关进行跟踪需要根据版本
选择apm-spring-cloud-gateway-plugin复制${skywalkingPath}/agent/optional-plugins到${skywalkingPath}/agent/plugins
选择apm-spring-webflux复制到${skywalkingPath}/agent/optional-plugins到${skywalkingPath}/agent/plugins

agent.service_name=group::service

-javaagent:D:\skywalking-agent\skywalking-agent.jar=agent.service_name=zk-local::
gateway,agent.authentication=agent-password

### 配置覆盖

https://github.com/SkyAPM/document-cn-translation-of-skywalking/blob/master/docs/zh/8.0.0/setup/service-agent/java-agent/Setting-override.md

### 所有配置

https://github.com/SkyAPM/document-cn-translation-of-skywalking/blob/master/docs/zh/8.0.0/setup/service-agent/java-agent/README.md

agent.namespace 命名空间，用于隔离跨进程传播的header。如果进行了配置，header将为HeaderName:Namespace. 未设置
agent.service_name 在SkyWalking UI中展示的服务名。5.x版本对应Application，6.x版本对应Service。
建议：为每个服务设置个唯一的名字，服务的多个服务实例为同样的服务名 Your_ApplicationName

## 日志收集

```
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-trace</artifactId>
    <version>8.16.0</version>
</dependency>
<!--  根据日志类型选择  -->
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-logback-1.x</artifactId>
    <version>8.16.0</version>
</dependency>


logback:
<!-- skywalking在console上 -->
<encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
    <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.mdc.TraceIdMDCPatternLogbackLayout">
        <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%X{sw_ctx}] [%thread] %-5level %logger{36} -%msg%n</Pattern>
    </layout>
</encoder>

<!--  skywalking grpc 采集日志  -->
<appender name="grpc-log" class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.log.GRPCLogClientAppender">
    <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
        <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.mdc.TraceIdMDCPatternLogbackLayout">
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%X{sw_ctx}] [%thread] %-5level %logger{36} -%msg%n</Pattern>
        </layout>
    </encoder>
</appender>
```

example: https://github.com/apache/skywalking/blob/727a722c735d7823cb3109c676086df99ab6b180/test/e2e-v2/java-test-service/e2e-service-provider/src/main/resources/logback.xml

```
<configuration scan="true" scanPeriod=" 5 seconds">

    <appender name="stdout" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
            <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.mdc.TraceIdMDCPatternLogbackLayout">
                <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%X{tid}] [%thread] %-5level %logger{36} -%msg%n</Pattern>
            </layout>
        </encoder>
    </appender>

    <appender name="grpc-log" class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.log.GRPCLogClientAppender">
        <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
            <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.mdc.TraceIdMDCPatternLogbackLayout">
                <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%X{sw_ctx}] [%thread] %-5level %logger{36} -%msg%n</Pattern>
            </layout>
        </encoder>
    </appender>

    <appender name="fileAppender" class="ch.qos.logback.core.FileAppender">
        <file>/tmp/skywalking-logs/logback/e2e-service-provider.log</file>
        <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
            <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.TraceIdPatternLogbackLayout">
                <Pattern>[%sw_ctx] [%level] %d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %logger:%line - %msg%n</Pattern>
            </layout>
        </encoder>
    </appender>

    <root level="INFO">
        <appender-ref ref="grpc-log"/>
        <appender-ref ref="stdout"/>
    </root>
    <logger name="fileLogger" level="INFO">
        <appender-ref ref="fileAppender"/>
    </logger>
</configuration>
```