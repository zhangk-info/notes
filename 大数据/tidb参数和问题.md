# tidb参数和问题

#### 问题
* tidb_mem_quota_query
  当内存使用超过一定阈值后也能采取一些操作来预防 OOM

https://docs.pingcap.com/zh/tidb/stable/configure-memory-usage
set global tidb_mem_oom_action = log;