### 安装
* 运行
docker run  -d --name grafana -p 3000:3000  -v /mnt/docker-volumes/grafana/data:/var/lib/grafana  grafana/grafana:7.5.5-ubuntu
* 复制出配置文件到root目录
docker cp grafana:/etc/grafana ~
* 复制ini到容器映射文件config下
cp grafana/grafana.ini /mnt/docker-volumes/grafana/config
* 删除容器后重新启动
docker run -d -p 3000:3000 \
--volume "/mnt/docker-volumes/grafana/plugins:/var/lib/grafana/plugins" \
--volume "/mnt/docker-volumes/grafana/config:/etc/grafana" \
--volume "/mnt/docker-volumes/grafana/data:/var/lib/grafana" \
--volume "/mnt/docker-volumes/grafana/log:/var/log/grafana" \
--user root \
--privileged=true \
--name=grafana \
grafana/grafana:7.5.5-ubuntu
### 容器配置详解
https://grafana.com/docs/grafana/latest/administration/configure-docker/
### 配置文件 grafana.ini
https://grafana.com/docs/grafana/latest/administration/configuration/

### 插件下载地址
https://grafana.com/grafana/plugins/

### dashboard下载地址
https://grafana.com/grafana/dashboards
* Zabbix的dashboard : https://grafana.com/grafana/dashboards?category=zabbix&panelType=table&search=Zabbix&orderBy=reviewsAvgRating&direction=desc

## json方式数据源（网络请求）：都只支持basic auth
https://grafana.com/grafana/plugins/simpod-json-datasource/?tab=installation
https://grafana.com/grafana/plugins/marcusolsson-json-datasource/?tab=installation 
### json方式数据源建议方式
* 使用第三方认证单点登录 https://blog.csdn.net/koppel/article/details/106269684
* 在数据源配置时使用 Forward OAuth Identity 即 通过第三方认证获取到的auth方式

### 插件开发文档
https://grafana.com/docs/grafana/latest/developers/plugins/
* panel开发文档
https://grafana.com/tutorials/build-a-panel-plugin/

### 3.* 版本的中国地图(使用了echarts)
https://gitee.com/Gaytutu/grafana-chinamap-panel/tree/master/src
todo 看看是否可改成7.x的react版本的方式