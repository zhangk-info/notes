# ioc & aop
## ioc
* 容器化 依赖注入 控制反转

以往我们需要一个对象都是new出来的 ， ioc思想将所有对象实例化成bean放入容器中。spring就会自动的帮我们实例化并管理Bean。对象的创建管理的控制权都交给了Spring容器，所以这是一种控制权的反转。

## aop
* 面向切面编程

### aop的通知类型
before（执行前） around（执行前后） after（执行后）  AfterThrowing（执行异常后） AfterReturning（执行正常后）

### 动态代理

#### JDK的动态代理是基于接口 InvocationHandler
JDK的动态代理是基于反射实现。JDK通过反射，生成一个代理类，这个代理类实现了原来那个类的全部接口，并对接口中定义的所有方法进行了代理。当我们通过代理对象执行原来那个类的方法时，
代理类底层会通过反射机制，回调我们实现的InvocationHandler接口的invoke方法。并且这个代理类是Proxy类的子类。这就是JDK动态代理大致的实现方式。

1. 优点
JDK动态代理是JDK原生的，不需要任何依赖即可使用；
通过反射机制生成代理类的速度要比CGLib操作字节码生成代理类的速度更快；
2. 缺点
如果要使用JDK动态代理，被代理的类必须实现了接口，否则无法代理；
JDK动态代理无法为没有在接口中定义的方法实现代理，假设我们有一个实现了接口的类，我们为它的一个不属于接口中的方法配置了切面，Spring仍然会使用JDK的动态代理，但是由于配置了切面的方法不属于接口，为这个方法配置的切面将不会被织入。
JDK动态代理执行代理方法时，需要通过反射机制进行回调，此时方法执行的效率比较低；


#### CGLib子类方式

CGLib实现动态代理的原理是，底层采用了ASM字节码生成框架，直接对需要代理的类的字节码进行操作，生成这个类的一个子类，并重写了类的所有可以重写的方法，
在重写的过程中，将我们定义的额外的逻辑（简单理解为Spring中的切面）织入到方法中，对方法进行了增强。
而通过字节码操作生成的代理类，和我们自己编写并编译后的类没有太大区别。

1. 优点
使用CGLib代理的类，不需要实现接口，因为CGLib生成的代理类是直接继承自需要被代理的类；
CGLib生成的代理类是原来那个类的子类，这就意味着这个代理类可以为原来那个类中，所有能够被子类重写的方法进行代理；
CGLib生成的代理类，和我们自己编写并编译的类没有太大区别，对方法的调用和直接调用普通类的方式一致，所以CGLib执行代理方法的效率要高于JDK的动态代理；
2. 缺点
由于CGLib的代理类使用的是继承，这也就意味着如果需要被代理的类是一个final类，则无法使用CGLib代理；
由于CGLib实现代理方法的方式是重写父类的方法，所以无法对final方法，或者private方法进行代理，因为子类无法重写这些方法；
CGLib生成代理类的方式是通过操作字节码，这种方式生成代理类的速度要比JDK通过反射生成代理类的速度更慢；


# filter 和 interceptor

filter： 有一堆东西的时候，只选择符合要求的东西通过
interceptor： 是aop的一种实现是通过反射实现的。过滤前---拦截前---Action处理---拦截后---过滤后

1. filter是servlet规定的过滤器，只能用于 web 程序中。interceptor是spring框架支持即可用于web程序，也可用于application、Swing中。
2. filter通过dochain放行。interceptor通过prehandler放行。
3. filter只在方法前后执行。interceptor粒度更细，可以深入到方法前后，异常抛出前后。

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
