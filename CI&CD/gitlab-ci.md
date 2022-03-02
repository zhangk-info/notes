## 官网
https://docs.gitlab.com/ee/ci/quick_start/index.html

### CI&CD
* CI: Continuous Integration（持续集成）
* CD: Continuous Delivery（连续交付）
* CD: Continuous Deployment（持续部署）    

### gitlab-ci涉及的抽象概念(Runner/PipeLine/Executor/Job)

**1. Pipeline & Job**

`Pipeline是Gitlab根据项目的.gitlab-ci.yml文件执行的流程，
它由许多个任务节点组成, 而这些Pipeline上的每一个任务节点，都是一个独立的Job
每个Job都会配置一个stage属性，来表示这个Job所处的阶段。
一个Pipeline有若干个stage,每个stage上有至少一个Job`

**2. Runner**

`Runner可以理解为：在特定机器上根据项目的.gitlab-ci.yml文件，对项目执行pipeline的程序。`
* Runner可以分为两种： Specific Runner 和 Shared Runner

  1. Shared Runner是Gitlab平台提供的免费使用的runner程序，它由Google云平台提供支持，每个开发团队有十几个。对于公共开源项目是免费使用的，如果是私人项目则有每月2000分钟的CI时间上限。
  2. Specific Runner是我们自定义的，在自己选择的机器上运行的runner程序，gitlab给我们提供了一个叫gitlab-runner的命令行软件，只要在对应机器上下载安装这个软件，并且运行gitlab-runner register命令，然后输入从gitlab-ci交互界面获取的token进行注册, 就可以在自己的机器上远程运行pipeline程序了。

* Gitlab-runner下载链接：https://docs.gitlab.com/runner/install/

* Shared Runner 和 Specific Runner的区别

  1. Shared Runner是所有项目都可以使用的，而Specific Runner只能针对特定项目运行
  2. Shared Runner默认基于docker运行，没有提前装配的执行pipeline的环境，例如node等。而Specific Runner你可以自由选择平台，可以是各种类型的机器，如Linux/Windows等，并在上面装配必需的运行环境，当然也可以选择Docker/K8s等
  3. 私人项目使用Shared Runner受运行时间的限制，而Specific Runner的使用则是完全自由的。
  
**3. Executor**

`什么是Executor？ 我们上面说过 Specific Runner是在我们自己选择的平台上执行的，这个平台就是我们现在说到的“Executor”，我们在特定机器上通过gitlab-runner这个命令行软件注册runner的时候，命令行就会提示我们输入相应的平台类型。`

### gitlab-ci 关键字
* stages
  
    一个pipeline有多个stages
* image

    当前job使用的基础镜像
* before_script
* script
* variables
* only&except
  
    **Choose when to run jobs**: https://docs.gitlab.com/ee/ci/jobs/job_control.html#onlyrefs--exceptrefs-examples
    With except, individual keys are logically joined by an OR. A job is not added if the following is true
```
  only:
    - tags
    - triggers
    - schedules
    refs:
      - merge_requests
    changes:
      - Dockerfile
      - service-one/**/*
      - "README.md"
    variables:
      - $CI_COMMIT_MESSAGE =~ /run-end-to-end-tests/
    kubernetes: active
```
* tags

  tags 属性可以标记这个任务将在含有特定 tag 的 CI Runner 上运行
* cache关键字
```
cache关键字是需要特别着重讲的一个关键字。顾名思义，它是用来做缓存的。
先说一下gitlab-ci的一个特点：
    它在运行下一个Job的时候，会默认把前一个Job新增的资源删除得干干静静
    没错，也就是说，我们上面bulid阶段编译生成的包，会在deploy阶段运行前被默认删除！
而cache的作用就在这里体现出来了
    如果我们把bulid生产的包的路径添加到cache里面，虽然gitlab还是会删除bulid目录，但
    是因为在删除前我们已经重新上传了cache，并且在下个Job运行时又把cache给pull下来，
    那么这个时候就可以实现在下一个Job里面使用前一个Job的资源了
总而言之，cache的功能体现在两点：
    在不同pipeline之间重用资源
    在同一pipeline的不同Job之间重用资源
```
* artifacts关键字

    这个关键字的作用是：将生成的资源作为pipeline运行成功的附件上传，并在gitlab交互界面上提供下载

    例如我们新增以下YML
```
build-job:
  stage: build
  script:
  - 'npm run build'
  artifacts:
    name: 'bundle'
    paths:
      - build/
```
* When

    表示当前Job在何种状态下运行，它可设置为3个值
  1. on_success: 仅当先前pipeline中的所有Job都成功（或因为已标记，被视为成功allow_failure）时才执行当前Job这是默认值。
  2. on_failure: 仅当至少一个先前阶段的Job失败时才执行当前Job。
  3. always: 执行当前Job，而不管先前pipeline的Job状态如何。
* retry

    顾名思义，指明的是当前Job的失败重试次数的上限。

    但是这个值只能在0 ～2之间，也就是重试次数最多为2次，包括第一次运行在内，Job最多自动运行3次
* allow_failure

    值为true/false, 表示当前Job是否允许允许失败。
    * 默认是false,也就是如果当前Job因为报错而失败，则当前pipeline停止
    * 如果是true，则即使当前Job失败，pipeline也会继续运行下去。

