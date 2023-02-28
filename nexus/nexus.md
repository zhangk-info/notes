## docker nexus搭建
* mkdir /data/nexus/data
* chmod 777 -R /data/nexus/data
* docker run -d --name nexus3 -p 6000:6000 -p 82:8081 -v /data/nexus/data:/nexus-data --restart=always --privileged=true sonatype/nexus3
* 查看admin密码： cat /data/nexus/data/admin.password   5U$gtJ$wFLEBUWMj
* 设置国内maven镜像仓库 proxy setting->Repository->Repositories http://maven.aliyun.com/nexus/content/groups/public/
* 设置docker镜像仓库 proxy
* 设置docker自有仓库 hosted 设置http端口6000
* 设置访问密码方式  https://blog.csdn.net/sasafa/article/details/126222609
```
1. Security->Realms bearer
2. Security->Roles 创建 放入全部规则 放入admin
3. 创建用户 放入role
```
* docker login 仓库主机ip:6000
* docker tag 原镜像名称:版本 仓库主机ip:6000/新镜像名字:版本号
* docker push ip:port/imageName
* docker rmi 
```
不允许使用http方式
missing signature key

修改 /etc/docker/daemon.json 文件
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"],
  "insecure-registries": ["ip:port"]
}
systemctl daemon-reload
systemctl restart docker 
```
* docker pull ip:port/imageName

```

Repository:仓储系统
Blob Stores:这个可以看成是存储空间,管理空间,主要是进行管理Repositorles中仓库的,默认有一个default存储,可以创建存储空间
Reposltorles:仓库,这就是我们所说的仓库的概念了,仓库一共分为三种类型,宿主(hosted),代理(proxy)和分组(group)
    宿主:第三方构建所能上传的仓库,可以创建多个name属性不同的宿主仓库,用于管理不同的项目
    代理:访问网络nexus服务器,用途:打个比方的说,想使用Junit包,但是分组仓库中没有,就需要去访问网络上的中央仓库中下载到你的代理仓库.(因为实际从网络仓库中download的是代理仓库,ps:默认访问网络中仓库的是游客,这个无需去计较了!)
    分组:分组仓库的主要作用就是将你的宿主仓库和代理仓库进行连接,比如说不同的项目创建的不通的宿主仓库,却使用了相同的代理仓库.这种就可以使用分组仓库进行连接!!!!!!!
Content Selectors:未知,不了解.从大概的意思上就是nexus组件的使用,和创建自己的组件
Security:安全管理,账号的权限,SSL证书的配置都在这里
Prlvileges:每种仓库的增删改查,浏览等权限,可以单独进行配置,被使用于Roles
Roles:角色权限,相当于一个权限模板,提供给User使用!默认有两种权限,一个是游客(anonymous),一个是管理员(admin)
Users:用户,这个就是访问nexus私服的用户了,默认同样是有两个,一个是管理员(admin),一个是游客(anonymous),管理员继承了Roles中admin权限模板,具有所有管理权限,而游客只有浏览权限
Anonymous:游客(或者叫匿名用户) 请忽略他
LDAP:通讯录? 不了解,请忽略他
Realms:领域?什么领域? 不了解,请忽略他
SSL Certlficates:SSL证书配置
Support:支持,分析系统运行状态,系统信息,日志查看都在这里
Analytlcs:分析你的组组件在如何的使用Nexus
Logging:系统各项组件日志
Metrlcs:内存,线程,磁盘目前使用图
Support ZIP:选择Support中各种分析文件打成ZIP文件,其中包括系统的运行状态啊,JVM啊,配置文件啊,日志啊等等之类的!
System InforMation:系统信息,这个比较常用,可以看Nexus运行状态,版本信息,配置文件,组件信息等..... -- System:系统设置
Bundles:系统插件具体信息的查看,我是这么理解的!有问题,请留言!
Capabilities:管理和配置你的Nexus具有什么能力,正常使用默认的就好!
Email Server:Email服务的配置,用于发邮件(在系统出现问题时)
HTTP: 整体传输协议的配置,默认的就好!
Licensing:许可证配置,SSL许可证?
Recent Connections:7天内访问系统信息,都谁访问过nexus服务器
Nodes:节点管理?
Tasks:系统任务

```

#### group 组类型，能够组合多个仓库为一个地址提供服务
* 将私有仓库和public组合起来