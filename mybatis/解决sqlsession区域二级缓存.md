```
configuration:
    cache-enabled: false
    local-cache-scope: statement
```
* 使全局的映射器启用或禁用缓存。但是
* cache-enabled: false 关闭二级缓存
* 设置本地缓存范围 session:就会有数据的共享  statement:语句范围 (这样就不会有数据的共享 ) defalut:session
* local-cache-scope: statement 将缓存级别改成statement 即关闭一级缓存