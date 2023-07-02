# grafana安装

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
   docker run -d --restart=always -p 3000:3000 --name=grafana -v E:\grafana:/var/lib/grafana -v E:\grafana\grafana.ini:
   /etc/grafana/grafana.ini -v E:\grafana\log:/var/log/grafana grafana/grafana-enterprise

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

## 配置通用oauth2认证方式登录

```
[server]
root_url = http://localhost:3000
[auth.generic_oauth]
enabled = true
allow_sign_up = true
auto_login = true
team_ids =
allowed_organizations =
name = Auth0
client_id = <client id>
client_secret = <client secret>
scopes = openid profile email offline_access
auth_url = https://<domain>/authorize
token_url = https://<domain>/oauth/token
api_url = https://<domain>/userinfo
use_pkce = true
```