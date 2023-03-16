# Bean的创建过程
* 推断构造函数
* 普通对象
* 属性注入
* 初始化前
* 初始化
* 初始化后（AOP)
* 代理对象
* 放入单例池

# 3级缓存
* singletonObjects
* earlySingletonObjects
* singletonFactories
* earlyProxyReferences

## spring使用3级缓存解决循环依赖
* CreatingSet设置对象构建中
* 推断构造函数
* 普通对象 -> singletonFactories放入当前对象和对象工厂ObjectFactory<>
* 属性注入 -> 多级缓存中取找，找到了返回，没找到继续向下
    * 单例池singletonObjects中找
        * CreatingSet中 -> 出现了循环依赖
        * earlySingletonObjects中去找
            * singletonFactories中找
                * ObjectFactory生成代理对象（提前AOP）或者普通对象
                * 提前aop了，earlyProxyReferences会存起来
                * 放入earlySingletonObjects并移除singletonFactories
* 初始化前
* 初始化
* 初始化后（earlyProxyReferences判断是否已经提前aop了，没有则aop)，
* 代理对象
* 放入单例池singletonObjects

## 使用@lazy解决循环依赖
* 只有在真正使用的时候才会对对象进行初始化


### @Valid与@Validated
```
@Valid与@Validated都是用来校验接收参数的。
 
@Valid是使用Hibernate validation的时候使用
 
@Validated是只用Spring Validator校验机制使用
 
说明：java的JSR303声明了@Valid这类接口，而Hibernate-validator对其进行了实现。
 
 
 
@Validated与@Valid区别：
 
@Validated：可以用在类型、方法和方法参数上。但是不能用在成员属性（字段）上，不支持嵌套检测
@Valid：可以用在方法、构造函数、方法参数和成员属性（字段）上，支持嵌套检测
 
 
 
注意:SpringBoot使用@Valid注解需要引入如下POM
 
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-validation</artifactId>
</dependency>

```
