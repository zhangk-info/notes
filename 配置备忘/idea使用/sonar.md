# Sonar

## 安装SonarQube

docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
账号密码：admin/admin 第一次会要求更改

## idea安装SonarLint并配置连接

## 建立project并执行

```
mvn clean verify -D sonar.projectKey=ft-fast-datax -D sonar.projectName='ft-fast-datax' -D sonar.host.url='http://localhost:9000' -D sonar.token=sqa_53cf2d757b7046511498372656cc42e7b619eba6  sonar:sonar
```

## 测试覆盖率 coverage

jacoco配置

```
<sonar.coverage.jacoco.xmlReportPaths>
    ${project.basedir}/ft-fast-report-aggregate/target/site/jacoco-aggregate/jacoco.xml
</sonar.coverage.jacoco.xmlReportPaths>

<!-- 在根目录加这个 单体的话只需要这个不需要上面的配置更改报告路径-->
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
                </formats>
            </configuration>
        </execution>
    </executions>
</plugin>

<!-- 在新增的聚合用的module里面增加聚合 module名字叫ft-fast-report-aggregate和配置在根里面的路径要一直 -->
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