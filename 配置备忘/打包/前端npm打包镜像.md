# 前端npm打包

1. 检查当前账号是否是root账号
   su root
2. 进入工作目录
   cd /data/build/smart-park-front-client-web
3. 拉取代码
   git checkout .
   git checkout origin/develop -f
   git pull origin develop
4. 检查版本
   npm -v
   node -v
5. npm安装，使用unsafe，否则会使用一个没有操作文件权限的账号安装，导致报错npm install Error: EACCES: permission denied,
   open xxxx
   npm install --unsafe-perm
6. 打包
   npm run build:stage
7. 打包镜像 ${BUILD_NUMBER}是jenkins流水线号码
   docker build -f ./Dockerfile -t 192.168.1.150:8090/njjs/nginx-client:${BUILD_NUMBER} .

   docker build -f ./deploy/docker/Dockerfile -t 192.168.10.150:8090/base/dinky:1.1.0 --build-arg FLINK_VERSION=1.18 .
8. 登录镜像仓库
   docker login -u developer -p xxx 192.168.1.150:8090
9. 上传镜像
   docker push 192.168.1.150:8090/njjs/nginx-client:${BUILD_NUMBER}
10. 清除无用镜像
    echo y | docker image prune -a


## yarn 

yarn config set registry http://registry.npm.taobao.org/
npm

## 示例

docker tag nginx:latest 192.168.10.150:8090/base/nginx:latest
docker login -u developer -p dev2021@FT 192.168.10.150:8090
docker push 192.168.10.150:8090/base/nginx:latest