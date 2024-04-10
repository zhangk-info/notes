# 同时部署两个前端示例

## nginx配置
```
location / {
        # 根路径 root 
        root /home/project1/dist;
        index index.html index.htm;
        try_files $uri $uri/ /test/index.html;
}

location /project2/ {
        # 前端根路径，alias 记得最后加 /
        alias /home/project2/dist/;
        index index.html index.htm;
        # index.html需要配置前缀路径
        try_files $uri $uri/ /project2/index.html;
}

```

### vue前端项目2配置路径前缀
```
1. src/router/index.js

export default new Router({
  // 配置路由前缀
  base:'project2',
})

2. vue.confifg.js

module.exports = {
  // 修改静载资源前缀
  publicPath: '/project2/',
}

```