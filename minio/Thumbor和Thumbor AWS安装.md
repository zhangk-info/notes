1. 安装python需要的环境
(1) yum -y groupinstall development
(2) yum -y install zlib-devel
2. 接着就可以安装Python3.6了，依次运行下面几条命令：
- wget https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz

- tar xJf Python-3.6.0.tar.xz

- cd Python-3.6.0

- ./configure
 运行配置程序的命令 configure
- make

- make install


3. 验证是否安装成功
which python3 
python3 -V
4. 假若想用python运行脚本，而不是python2.7.9，运行以下指令即可完成修改：
ln -s /usr/local/bin/python3 /usr/bin/python
这里我们就用python3和pip3来运行命令
5. 安装thumber 它是一个基于Python的开源项目，在python环境下可以通过pip安装
pip install thumbor
这里我们应该是pip3 install thumbor

ps:6-14为解决 提示 ModuleNotFoundError: No module named '_ssl'问题 如未出现问题，请直接跳到15

6. python3.6.2 提示 ModuleNotFoundError: No module named '_ssl' 模块问题 
cd python3.6.2/Modules/Setup.dist
大约在209 行
209 SSL=/usr/local/ssl
210 _ssl _ssl.c \
211 -DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
212 -L$(SSL)/lib -lssl -lcrypto
将注释放开

7. 重复
- ./configure 
- make 
- make install
8.发现还是报错
(1) 运行
python3
(2) python3中运行
import ssl
(3) 结果还是报错
9.使用python2
(1) 运行
python2 或者 python (前提是python -V指向python2地址)
(2) python2中运行
import ssl
(3) 结果可以
10. 用回系统自带python2
11. 运行pip2 install thumbor 
12. 还是报错
13. pip -V 发现pip在安装高版本python后指向了高版本python的安装路径
14. 找到解决方案
python2 -m pip install thumbor
或者
python -m pip install thumbor
(前提是python -V查看到python指向的是你能import ssl 的python地址)

15. 配置thumbor文件 thumbor依赖python的 tornado
thumbor-config > ./thumbor.conf
16. 启动
thumbor --port=8888 --conf=thumbor.conf 
17. 访问
http://ip:8888/unsafe/200x300<图片大小>/<img_url>
例：http://ip:8888/unsafe/300x200/http://pic25.nipic.com/20121112/9252150_150552938000_2.jpg


Thumbor AWS安装

ps:最终就可以达成，利用Minio上传存储图片，利用Thumbor取出图片做处理。
意思是：minio图片上传，thumbor图片处理，而tc_aws用于“跳过”minio的认证；即不需要再需要minio生成文件分享url了。
1. pip安装
pip install tc_aws
这里我们还用python2:
python2 -m pip install tc_aws
2.创建一个名为credentials的文件
3.复制文件到linux服务器的~/.aws/<credentials>



ps：误删除系统自带python和yum后恢复
https://www.cnblogs.com/mashuqi/p/10955089.html

