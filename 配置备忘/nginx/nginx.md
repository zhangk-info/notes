## nginx对于安全相关的限制

```
# https://nginx.org/en/docs/http/ngx_http_limit_req_module.html
# zone定义在http模块中
# 定义一个20m的共享zone，zone存储的是变量（remote_addr)，限制一个地址速率为15r/s
# limit_req_zone key zone=name:size rate=rate [sync];
limit_req_zone $binary_remote_addr zone=perip:20m rate=15/s;
# limit_conn_zone key zone=name:size;
limit_conn_zone $binary_remote_addr zone=perip:20m;


# limit定义在server中
# 定义某个server使用某个zone规则，burst表示突发情况下的速率不超过30，nodelay则表示不希望超过的请求被延迟(delay则表示请求堆积)
# limit_req zone=name [burst=number] [nodelay | delay=number];
limit_req zone=perip2 burst=30 nodelay；
# 为给定键值 最大允许连接数。每个ip设置40个连接数
# limit_conn zone number;
limit_conn perip2 40;

# X-Frame-Options头 需要安装或集成插件 nginx-extras
add_header X-Frame-Options "SAMEORIGIN"; 

# http慢速攻击 slow http attack
 keepalive_timeout 5s;
```


```
在nginx 安装目录/conf中找到 nginx.conf配置文件，修改。
1、隐藏版本号：
http { 
    server_tokens off；
}
2、统一错误页面配置（400、403、413、404、500、502、503、504）
server {
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /path/to/50x.html;
    }
}
3、配置 Nginx 安全标头，配置含义参考：https://www.jianshu.com/p/b8979141c2dd
location / {
  add_header Content-Security-Policy "default-src 'self' xxx.xxx.com(允许的地址);
  add_header X-Content-Type-Options "nosniff";
  add_header X-XSS-Protection "1; mode=block";
  add_header X-Frame-Options SAMEORIGIN;
  add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
  add_header 'Referrer-Policy' 'origin'; 
  add_header X-Download-Options noopen;
  add_header X-Permitted-Cross-Domain-Policies none;
}
4、限制文件上传大小
在nginx.conf的http段增加如下配置参数：
client_max_body_size 10m; # 最大允许上传的文件大小根据业务需求来设置
如果上传的文件大小超过该设置，那么就会报413 Request Entity Too Large的错误。
5、禁用任何不会使用且不需要在 Web 服务器上实现的 HTTP 方法。
if ($request_method !~ ^(GET|HEAD|POST)$ ) {
    return 444; 
}
nginx收到不属于 GET HEAD POST 的请求后，不给任何答复，也不处理。
6、检查配置文件error_log配置
7、检查配置文件中是否存在access_log配置
8、检查配置文件中是否存在limit_conn设置
9、检查配置文件中是否存在limit_rate设置
参考https://segmentfault.com/a/1190000012714372
```

## nginx 实现短链

```
location ~^/s/(.*) {
                rewrite ^/s/(.*) https://www.zhangkun.space/h5/redirectByCode?code=$1 permanent;
        }
```

## docker 启动nginx

docker run --name nginx -p80:80 -d -v /data/nginx/conf:/etc/nginx -v /data/nginx/html:/usr/share/nginx/html -v
/data/ssl:/data/ssl nginx

docker run --name nginx -p30500:80 -d -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx/log:/var/log/nginx nginx


docker run --name nginx -d -p 80:80 -p 443:443 --restart=always -v /data/nginx/log:/var/log/nginx -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx/conf/conf.d:/etc/nginx/conf.d -v /data/nginx/html:/usr/share/nginx/html -v /data/ssl:/data/ssl nginx
