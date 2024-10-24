
### 每次都会重新拉取snapshot
<profile>
     <id>alwaysActiveProfile</id>
     <activation>
      <!-- 是否默认激活 -->
      <activeByDefault>true</activeByDefault>
     </activation>
     <repositories>
        <repository>
          <id>alwaysActiveProfile</id>
          <name>alwaysActiveProfile Snapshots</name>
          <snapshots>
            <enabled>true</enabled>
            <!-- 重点在这里，每次都会重新拉取snapshot -->
            <updatePolicy>always</updatePolicy>
            <checksumPolicy>fail</checksumPolicy>
          </snapshots>
          <url>http://ip:host/repository/public</url>
          <url>http://username@password:ip:host/repository/public</url>
          <layout>default</layout>
        </repository>
      </repositories>
    </profile>
  </profiles>

doIncreaseColumnSynchronize(IDatabaseWriter writer, DbSwitchTableResult dbSwitchTableResult) {
doIncreaseSynchronize(IDatabaseWriter writer, DbSwitchTableResult dbSwitchTableResult) {
```
 do {
                Object[] record = new Object[sourceFields.size()];
                for (int i = 1; i <= sourceFields.size(); ++i) {
                    try {
                        record[i - 1] = rs.getObject(i);
                    } catch (Exception e) {
                        log.warn("!!! Read data from table [ {} ] use function ResultSet.getObject() error",
                            tableNameMapString, e);
                        record[i - 1] = null;
                    }
                }

                cache.add(record);
                long bytes = SizeOf.newInstance().sizeOf(record);
                cacheBytes += bytes;
                syncCount.getAndAdd(1);

                if (cache.size() >= BATCH_SIZE || cacheBytes >= MAX_CACHE_BYTES_SIZE) {
                    long ret = writer.write(targetFields, cache);
                    log.info("[FullCoverSync] handle table [{}] data count: {}, the batch bytes size: {}",
                        tableNameMapString, ret, BytesUnitUtils.bytesSizeToHuman(cacheBytes));
                    cache.clear();
                    /*totalBytes += cacheBytes;*/
                    syncBytes.getAndAdd(cacheBytes);
                    cacheBytes = 0;
                }
            } while ((rs.next()));

            if (cache.size() > 0) {
                long ret = writer.write(targetFields, cache);
                log.info("[FullCoverSync] handle table [{}] data count: {}, last batch bytes size: {}",
                    tableNameMapString, ret, BytesUnitUtils.bytesSizeToHuman(cacheBytes));
                cache.clear();
                /*totalBytes += cacheBytes;*/
                syncBytes.getAndAdd(cacheBytes);
            }

			/*log.info("[FullCoverSync] handle table [{}] total data count:{}, total bytes={}",
					tableNameMapString, totalCount, BytesUnitUtils.bytesSizeToHuman(totalBytes));*/
```