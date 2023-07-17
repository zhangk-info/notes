# Sonar 

## 安装SonarQube

docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
账号密码：admin/admin

## idea安装SonarLint并配置连接

## 建立project并执行
```
mvn clean verify -D sonar.projectKey=ft-fast-datax -D sonar.projectName='ft-fast-datax' -D sonar.host.url='http://localhost:9000' -D sonar.token=sqa_53cf2d757b7046511498372656cc42e7b619eba6  sonar:sonar
```