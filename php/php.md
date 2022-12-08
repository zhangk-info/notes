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


docker run -d --name php -p80:80 -p443:443 --restart=always --privileged=true zhubao:1.0
