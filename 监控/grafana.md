# Grafana

## docker安装

Grafana的推荐和默认版本是Grafana Enterprise。它是免费的，包含了OSS版本的所有功能。此外，您还可以选择升级到完整的企业功能集，其中包括对企业插件的支持。

1. 创建空白文件夹和空白grafana.ini
2. 配置默认管理员密码或者第一次启动后会强制更改

   The password of the default Grafana Admin. Set once on first-run. Default is admin.

```
[security]
admin_user=admin
admin_password=123456
```

3. 配置用户默认语言为中文

```
[users]
default_language=zh-CN
```

4. docker启动
   docker run -d --restart=always -p 3000:3000 --name=grafana -v E:\grafana:/var/lib/grafana -v E:\grafana\grafana.ini:/etc/grafana/grafana.ini -v E:\grafana\log:/var/log/grafana grafana/grafana-enterprise


#### 默认文件路径

GF_PATHS_CONFIG /etc/grafana/grafana.ini
GF_PATHS_DATA /var/lib/grafana
GF_PATHS_HOME /usr/share/grafana
GF_PATHS_LOGS /var/log/grafana
GF_PATHS_PLUGINS /var/lib/grafana/plugins
GF_PATHS_PROVISIONING /etc/grafana/provisioning

#### 更改默认参数方式

1. 覆盖&新增
2. 移除默认配置

   Grafana uses semicolons (the ; char) to comment out lines in a .ini file.

## 配置jwt认证方式

```
[auth.jwt]
enabled = true
# 解析一个jwt中的字段作为名字
username_claim = sub
# 解析一个jwt中的字段作为邮箱
email_claim = sub
# auto-create users if they are not already matched
auto_sign_up = true
# 从url路径获取jwt。使用方式： &auth_token=eyJhbxxxxxxxxxxxxx
url_login = true
# 配置jwk地址
# jwk_set_url = https://your-auth-provider.example.com/.well-known/jwks.json
# 配置jwk文件地址
jwk_set_file = /var/lib/grafana/jwks.json
# 缓存jwk_set时间
cache_ttl = 1m
# Validate claims扩展
# expect_claims = {"iss": "https://your-token-issuer", "your-custom-claim": "foo"}

role_attribute_path=contains(authorities[*].role, 'admin') && 'Admin' || contains(authorities[*].role, 'editor') && 'Editor' || 'Viewer'
# 设置禁用角色分配 如果没有返回角色或返回无效角色，它将拒绝用户访问。
role_attribute_strict = false
skip_org_role_sync = true
```
```
http://localhost:3000/d/X034JGT7Gz/springboot-apm-dashboard?from=1688274393477&to=1688295993477&auth_token=eyJraWQiOiJzdGF0aWMtZmlsZS1rZXkiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxODk5MDQ0MjE1OCIsIm5pY2tOYW1lIjoi5p2oIiwiY3JlZGVudGlhbHNOb25FeHBpcmVkIjp0cnVlLCJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjkyLyIsInVzZXJJZCI6MSwiYXV0aG9yaXRpZXMiOlt7InJvbGUiOiJDVVNUT01FUiJ9XSwiZW5hYmxlZCI6dHJ1ZSwiYXVkIjoicGFzc3dvcmQiLCJyZWFsTmFtZSI6IuadqOaYn-WzsCIsInBhc3N3b3JkIjoiYjc0ZTY1YmYzYTAyZGNmYjY2ZDZlNzUzMTZlYjg2ZjIiLCJuYmYiOjE2ODgyOTY3NjYsInNjb3BlIjpbIkNVU1RPTUVSIl0sImFjY291bnROb25FeHBpcmVkIjp0cnVlLCJleHAiOjE2ODg5MDE1NjYsImlhdCI6MTY4ODI5Njc2NiwidXNlcm5hbWUiOiIxODk5MDQ0MjE1OCIsImFjY291bnROb25Mb2NrZWQiOnRydWV9.SkKuA3OXIpWPLYdpfJUH2Sa4WIBcYDbeGiDaRWqzaOYzUhk-BTnrkRXfblRySgSOLq0IuAS85DRbGyDzrvcjVagYz9CWofCIuz18jMrJnL-_D_Lq4NnJW8xFj-kKEIvkJ5hLlP_CHsc6AxNzw48a9JcFV9N33scN9gwnIMmgLMXJJ3I_pvNpF13JyoRlsGLvLmDPn4Bp_d5pd_socXIEjjxD29kVfzvOC5INLogJy9hNQBvmzL7b4Za91ansIFnT5xbGDwnlf7LqhrVn9VxP9ZvoPJ4Flm7MBZxBZxZCjdzkh_c-ydG1oYTQjFrkSxQTo5pw5qR2P0kaxedc2TpebA
```


### 复制出全量配置文件方式

* 运行
  docker run -d --name grafana -p 3000:3000 -v /mnt/docker-volumes/grafana/data:/var/lib/grafana grafana/grafana:
  7.5.5-ubuntu
* 复制出配置文件到root目录
  docker cp grafana:/etc/grafana ~

### 容器配置详解

https://grafana.com/docs/grafana/latest/administration/configure-docker/

### 配置文件 grafana.ini

https://grafana.com/docs/grafana/latest/administration/configuration/

### 插件下载地址

https://grafana.com/grafana/plugins/

### dashboard下载地址

https://grafana.com/grafana/dashboards

* Zabbix的dashboard

https://grafana.com/grafana/dashboards?category=zabbix&panelType=table&search=Zabbix&orderBy=reviewsAvgRating&direction=desc

### json方式数据源（网络请求）：都只支持basic auth

https://grafana.com/grafana/plugins/simpod-json-datasource/?tab=installation
https://grafana.com/grafana/plugins/marcusolsson-json-datasource/?tab=installation

### json方式数据源建议方式

* 使用第三方认证单点登录 https://blog.csdn.net/koppel/article/details/106269684
* 在数据源配置时使用 Forward OAuth Identity 即 通过第三方认证获取到的auth方式

### 插件开发文档

https://grafana.com/docs/grafana/latest/developers/plugins/

* panel开发文档

https://grafana.com/tutorials/build-a-panel-plugin/