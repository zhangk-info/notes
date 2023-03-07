# jenkins 
docker run -d --name my_jenkins -u root -p 8085:8080 -p 50000:50000 -v /data/jenkins_home:/var/jenkins_home -v /etc/localtime:/etc/localtime -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai --restart=always docker.io/jenkins/jenkins:2.319

# jenkins权限设置
1. 插件为Role-based Authorization Strategy
2. 全局安全设置使用Role-based Authorization Strategy并重启后会在系统设置-安全出现“Manage and Assign Roles”
3. 配置角色&分配角色给group或user
   * 全局角色
   * item角色： Pattern所填的内容是正则匹配 test1.*表示以test1开头的项目，test.*|Test.*表示以test或Test开头的项目
