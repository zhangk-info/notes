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
limit_req zone=perip burst=30 nodelay；
# 为给定键值 最大允许连接数。每个ip设置40个连接数
# limit_conn zone number;
limit_conn perip 40;
```