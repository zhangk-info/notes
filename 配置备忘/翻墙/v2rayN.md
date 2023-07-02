## 自建v2ray:
  * https://github.com/233boy/
  bash <(curl -s -L https://git.io/v2ray-install.sh)
  bash <(curl -s -L https://git.io/v2ray-setup.sh)
  * https://github.com/Alvin9999/new-pac
  * https://tr3.freeair888.club
## v2rayN:A Windows GUI client for V2Ray.
https://github.com/2dust/v2rayN (中文GUI）
https://github.com/v2ray/V2RayN（英文GUI）
https://github.com/v2ray/v2ray-core (core)
## v2rayN文档手册
https://www.v2ray.com/
## 使用注意：
1. 阻止第三方cookie,且设置为不跟踪 do not track
2. 更改dns (平时没必要，伪装的时候有必要，并且需要改系统时区)

## wemod
wemod 使用报错需要改变360杀毒实时防护设置为低
## v2rayN路由增强版
https://github.com/Loyalsoldier/v2ray-rules-dat
* v2rayN路由模式
  4.x版本去掉pac模式使用geoip和domain
```
1. 白名单 = 绕过大陆 （国内已知网址列表直连）：
https://raw.githubusercontent.com/2dust/v2rayCustomRoutingList/master/custom_routing_rules_whitelist
  缺点：并不是所有网址都在收录里面，导致没收录的网址通过代理从国外走了一圈，速度变慢，且被认为是从国外访问
2. 黑名单 = 代理被墙地址 （国外已知网址列表代理）：
https://raw.githubusercontent.com/2dust/v2rayCustomRoutingList/master/custom_routing_rules_blacklist
  缺点：并不是所有网址都在收录里面，导致没收录的网址走直连导致连不上
3.  全局 = 所有地址都走代理
```
## 自定义路由规则
```
发现有以下规则在黑名单模式下出错
自定义代理 :

tiktok.com,
tiktokcdn.com,
byteoversea.com,
tiktokv.com,
```

#### 如果想看广告可以放开block：
category-ads-all: 包含了常见的广告域名，以及广告提供商的域名。


## 设置高优先级和开机自动设置高优先级
* shell:startup
打开开机启动文件位置并放入bat文件

