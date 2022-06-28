# gateway
SpringCloud Gateway 是 Spring Cloud 的一个全新项目，基于 Spring5.0 + Spring Boot 2.0 和 Project Reactor 等技术开发的网关，它旨在为微服务架构提供一种简单有效的统一的API路由管理方式。

SpringCloud GateWay 作为 Spring Cloud 生态系统中的网关，目标是替代Zuul,在Spring Cloud 2.0以上版本中,没有对新版本的Zuul 2.0以上最新高性能版本进行集成，仍然还是使用的Zuul1.x非Reactor模式的老版本。而为了提升网关的性能，SpringCloud Gateway是基于WebFlux框架实现的，而WebFlux框架底层则使用了高性能的Reactor模式通信框架Netty。

异步非阻塞框架，高性能编程框架
Webflux
Reactor-Netty

外部请求 -> 负载均衡 -> 网关 -> 微服务 ： 网关在负载均衡服务中间，这里的负载均衡指的是Nginx或f5等服务端负载均衡。


SpringCloud Gateway 具有以下特性：

基于 Spring5.0 + Spring Boot 2.0 和 Project Reactor 等技术开发；
动态路由：能够匹配任何请求属性；
可以对路由指定Predicate（断言） 和 Filter（过滤器）;
集成Hystrix的断路器功能；
集成Spring Cloud的服务发现功能；
易于编写的Predicate（断言）和 Filter （过滤器）；
请求限流功能；
支持路径重写；


Spring Webflux是什么：
  传统的Web框架,比如说：struts,springmvc等都是基于Servet API与Servlet容器基础之上运行的。
  但是在Servlet3.1之后有了异步非阻塞的支持。而WebFlux是一个典型的非阻塞异步的框架，它的核心是基于Reactor的相关API实现的。相对于传统的Web框架来说，它可以运行在诸如Netty,Undertow及支持Servlet3.1的容器上。
  Spring WebFlux是Spring5.0引入的新的响应式框架，区别于Sring MVC,它不需要依赖Servlet API,它是完全异步非阻塞的，并且基于Reactor来实现响应式流规范。


Spring Gateway 三大核心概念
Route(路由)：路由是构建网关的基本模块，它由ID，目标URI，一系列的断言和过滤器组成，如果断言为true则匹配该路由。
predicate(断言)：参考的是Java8的java.util.function.Predicate开发人员可以匹配HTTP请求中的所有内容(例如请求头或请求参数)，如果请求与断言相匹配则进行路由。
Filter(过滤器)：指的是Spring框架中的GatewayFilter的实力，使用过滤器，可以在骑牛被路由钱或者之后对请求进行修改。Filter在“pre”之前可以做参数校验、权限校验、流量控制、日志输出、协议转换等。Filter在“post”之后可以做响应内容、响应头的修改，日志输出，流量监控等。

外部请求 -> 【[Netty Server]+[{路由规则1，断言1，拦截器1},{路由规则2，断言2，拦截器2}...]+[Netty Client]】->微服务

## zuul和gateway的区别
* zuul使用web servlet： 同步阻塞 ； gateway使用webflux,底层是netty : 异步非阻塞；
* gateway线程开销少，支持各种长链接、websocket;

使用：
1.引入spring-cloud-starter-gateway且不能引入spring-boot-starter-web 
一个是mvc一个是webFlux
2.配置路由规则
spring:
    cloud:
      gateway:
        routes:
        - id: service-name_routh #路由的ID，没有固定规则但要求唯一，建议配合服务名
          uri: http://localhost:80   #匹配后提供服务的路由地址
          uri: lb://service-name/   #匹配后提供服务的路由地址
          predicates:
            - Path=/service-name/**   #断言,路径相匹配的进行路由


predicate的11种配置 :
5. Route Predicate Factories : https://cloud.spring.io/spring-cloud-gateway/2.1.x/multi/multi_gateway-request-predicates-factories.html

Filter的41种配置（GatewayFilter 31种，GlobalFilter 10种）：
6. GatewayFilter Factories : https://cloud.spring.io/spring-cloud-gateway/2.1.x/multi/multi__gatewayfilter_factories.html

7. Global Filters : https://cloud.spring.io/spring-cloud-gateway/2.1.x/multi/multi__global_filters.html


自定义过滤器
1.implements GlobalFilter,Ordered
2.@Component
3.实现filter和getOrder

