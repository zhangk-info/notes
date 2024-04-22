# Sonar

## 安装SonarQube

docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
账号密码：admin/admin 第一次会要求更改

## idea安装SonarLint并配置连接

## 建立project并执行

```
mvn clean verify -D sonar.projectKey=xx -D sonar.projectName='xxx' -D sonar.host.url='http://localhost:9000' -D sonar.token=sqa_53cf2d757b7046511498372656cc42e7b619eba6  sonar:sonar
```

## 测试覆盖率 coverage

jacoco配置

```

<!-- 在根目录加这个plugin配置，研发云不管多模块还是单模块都只加这个，研发云会自动收集所有的target/site/jacoco/jacoco.xml-->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.10</version>
    <executions>
        <execution>
            <id>prepare-agent</id>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
            <configuration>
                <formats>
                    <format>XML</format>
                    <format>HTML</format>
                </formats>
            </configuration>
        </execution>
    </executions>
</plugin>

多模块还需要做以下操作：

1. 
<!-- 多模块在根目录加这个，单体的话不需要这个配置。作用：更改报告路径，需更改report-aggregate为你自建的module的名字 -->
<properties>
    <sonar.coverage.jacoco.xmlReportPaths>${project.basedir}/report-aggregate/target/site/jacoco-aggregate/jacoco.xml</sonar.coverage.jacoco.xmlReportPaths>
</properties>

2. 
新增一个module并引入你的所有其他module

3. 
<!-- 在新增的聚合用的module里面增加聚合 module名字叫report-aggregate和配置在根里面的路径要一致 -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.10</version>
    <executions>
        <execution>
            <id>report-aggregate</id>
            <phase>package</phase>
            <goals>
                <goal>report-aggregate</goal>
            </goals>
        </execution>
    </executions>
</plugin>

```