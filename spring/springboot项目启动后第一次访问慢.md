# springboot项目启动慢
1. 开启全局懒加载 延迟初始化定义：在启动时不初始化Bean，直到用到这个Bean的时候才去初始化。默认情况下，Bean在启动时进行初始化
spring.main.lazy-initialization=true

## springboot项目启动后第一次访问慢

1. 设置dispatcherServlet 即时加载

   spring.mvc.servlet.load-on-startup=1
2. 设置数据库连接池初始化链接数
3. 随机数生成器

    -Djava.security.egd=file:/dev/./urandom

## 接口预热
Warmup