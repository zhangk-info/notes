# 学习笔记


* 方式1

git config --global --unset http.proxy
git config --global --unset https.proxy
* 方式2

git config --global http.proxy http://127.0.0.1:10809
git config --global http.postBuffer 524288000


git config --global http.proxy 'socks5://127.0.0.1:10808'