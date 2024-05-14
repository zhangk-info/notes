# tidb参数和问题

#### 问题
* tidb_mem_quota_query
  当内存使用超过一定阈值后也能采取一些操作来预防 OOM

https://docs.pingcap.com/zh/tidb/stable/configure-memory-usage
set global tidb_mem_oom_action = log;
 
* 掉电后tikv的raft数据损坏

https://asktug.com/t/topic/1006099
https://docs.pingcap.com/zh/tidb/stable/tikv-configuration-file#wal-recovery-mode
https://docs.pingcap.com/zh/tidb/stable/tikv-configuration-file#recovery-mode

wal-recovery-mode = "tolerate-corrupted-tail-records"

[raft-engine]
recovery-mode = "tolerate-any-corruption"
recovery-read-block-size = "100MB"