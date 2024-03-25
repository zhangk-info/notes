# gitlab

docker run -itd  \
-p 8082:80 \
-p 9922:22 \
-v /opt/soft/docker/gitlab/etc:/etc/gitlab  \
-v /opt/soft/docker/gitlab/log:/var/log/gitlab \
-v /opt/soft/docker/gitlab/opt:/var/opt/gitlab \
--restart always \
--privileged=true \
--name gitlab \
gitlab/gitlab-ce:14.0.5-ce.0


docker run -d  \
-p 8082:80 \
-p 9922:22 \
-v /opt/gitlab:/var/opt/gitlab  \
-v /etc/gitlab:/etc/gitlab \
-e GITLAB_SKIP_UNMIGRATED_DATA_CHECK=true \
--restart always \
--privileged=true \
--name gitlab \
gitlab/gitlab-ce:latest


## gitlab迁移 

docker run -d  \
-p 8082:80 \
-p 9922:22 \
-v /opt/gitlab:/var/opt/gitlab  \
-v /opt/gitlab-conf:/etc/gitlab \
-e GITLAB_SKIP_UNMIGRATED_DATA_CHECK=true \
--restart always \
--privileged=true \
--name gitlab \
gitlab/gitlab-ce:14.0.6-ce.0

-- 权限问题：
docker exec -it gitlab update-permissions
docker restart gitlab

-- 语言环境问题：
apt update 
apt install locales
apt install language-pack-en

-- 端口检查
检查以下两个文件中配置的端口是80还是8082
修改E:/gitlab/etc/gitlab.rb
把external_url改成部署机器的域名或者IP地址（端口映射的时候，尽量设置成一样吧，忘记端口号填的内部还是外部了）
external_url 'http://192.168.31.56'		# ip填你自己的
# external_url 'http://192.168.31.56:80'  #这行是注释掉的

修改 E:/gitlab/data/gitlab-rails/etc/gitlab.yml
查找 ## Web server settings 改host和port
host: 192.168.31.56
port: 80
# 将host的值改成映射的宿主机的ip地址和端口，这里会显示在gitlab克隆地址上
