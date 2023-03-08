## php 安装
安装PHP

我这里使用快捷的安装方式，采用yum直接安装。

分别执行命令：

* rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

* rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

* yum install php70w-common php70w-fpm php70w-opcache php70w-gd php70w-mysqlnd php70w-mbstring php70w-pecl-redis php70w-pecl-memcached php70w-devel

* systemctl restart httpd

## tar安装
```
yum install -y systemd-devel
yum install -y libxml2-devel 
yum install -y sqlite-devel 
yum install -y libcurl-devel 
yum install libpng-devel -y oniguruma-devel
yum install oniguruma-6.8.2-1.el7.x86_64.rpm 
yum install oniguruma-devel-6.8.2-1.el7.x86_64.rpm
```
* ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=root --with-fpm-group=  --with-curl --with-iconv --with-mhash --with-zlib --with-openssl --enable-mysqlnd --with-mysqli --with-pdo-mysql --disable-debug --enable-sockets --enable-soap --enable-inline-optimization --enable-xml --enable-ftp --enable-gd --enable-exif --enable-mbstring  --enable-bcmath --with-fpm-systemd
* make & make install


* https://blog.csdn.net/qq_45106132/article/details/120225506
* 不能用root启动php-fpm解决方案： https://www.qycn.com/xzx/article/2337.html

## nginx 
* wget 
* ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
* make & make install

### nginx 开机自启动
```

vim /lib/systemd/system/nginx.service


[Unit]
Description=nginx service
After=network.target
 
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
PrivateTmp=true
[Install]
WantedBy=multi-user.target



systemctl daemon-reload
systemctl enable nginx
```

## 容器安装
```
# 不建议更换alpine3.13之后会有问题，什么问题我也不知道，不要动就对了
FROM alpine:3.13

# 容器默认时区为UTC，如需使用上海时间请启用以下时区设置命令
#RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone

# 设置国内镜像源并安装PHP+Nginx+Zip
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories \
    && apk add --update --no-cache \
    php7 \
    php7-json \
    php7-ctype \
	php7-exif \
	php7-pdo \
    php7-session \
    php7-tokenizer \
    php7-pdo_mysql \
    php7-xml \
    php7-xmlrpc \
    php7-simplexml \
    php-dom \
    php7-fpm \
    php7-curl \   
    nginx \
    zip \
    && rm -f /var/cache/apk/*

# 设置网站目录，这个名字你喜欢就好
WORKDIR /app

# 将当前目录下所有文件拷贝到/app （.dockerignore中文件除外）
COPY . /app

# 替换nginx、fpm、php配置并赋予777权限，不赋予权限修改或写日志有问题，配置文件放到本地根目录conf目录下
RUN cp /app/conf/nginx.conf /etc/nginx/conf.d/default.conf \
    && cp /app/conf/fpm.conf /etc/php7/php-fpm.d/www.conf \
    && cp /app/conf/php.ini /etc/php7/php.ini \
    && mkdir -p /run/nginx \
    && chmod -R 777 /app \
    && chmod -R 777 /etc \
    && mv /usr/sbin/php-fpm7 /usr/sbin/php-fpm

# 暴露端口
# 此处端口必须与「服务设置」-「流水线」以及「手动上传代码包」部署时填写的端口一致，否则会部署失败。
EXPOSE 80

# 执行启动命令.
# 写多行独立的CMD命令是错误写法！只有最后一行CMD命令会被执行，之前的都会被忽略，导致业务报错。
# 请参考[Docker官方文档之CMD命令](https://docs.docker.com/engine/reference/builder/#cmd)
CMD ["sh", "run.sh"]
```

### 构建镜像
* docker build -t demo:1.0 /data/demo/demo-admin-new

### 启动容器并挂载
* docker run -d --name php -p80:80 -p443:443 --restart=always --privileged=true demo:1.0
* docker run -d --name php -p80:80 -p443:443 -v /data/demo/demo-admin-new:/app --restart=always --privileged=true demo:1.0


