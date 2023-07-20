# mysql主从配置

1. 更改主从的server_id
2. 主库建立账号密码

    ```
    # 账号
    CREATE USER 'slave'@'%' identified by 'j:/?Nf_ha5::';
    grant replication slave, replication client on *.* to 'slave'@'%';
    flush privileges;
    
    
    alter USER 'slave'@'%' identified by 'j:/?Nf_ha5::';
    flush privileges;
    ```

3. mysqldump主库数据 --source-data

   --source-data如果选项赋值为2，那么CHANGE MASTER TO 语句会被写成一个SQL comment（注释），从而只提供信息;
   --source-data如果选项赋值为1，那么语句不会被写成注释并且在dump被载入时生效。
   --source-data如果没有指定，默认值为1。

* mysqldump -uroot -p --all-databases --source-data=2 > alldb.sql
* tail -n 1 alldb.sql 显示 -- Dump completed on 2023-07-20 15:35:08

4. 从库导入数据

* mysql -uroot -p < alldb.sql

5. 找到mysqldump中的语句change master to语句并改成我们正常需要的账号密码ip

```
stop slave;
reset slave; # 慎用，会清除所有信息
CHANGE MASTER TO MASTER_LOG_FILE='binlog.000046', MASTER_LOG_POS=147606812, master_host='192.168.10.149', master_user='slave', master_password='j:/?Nf_ha5::', master_port=3306;
```

6. # 启动从节点

* START SLAVE;

7. 查看备库状态

* SHOW SLAVE STATUS \G;

8. 如果两台Slave_IO_Running和Slave_SQL_Running都是Yes状态，代表配置成功

# 互为主从，需要没有新数据进入的情况下才能进行，否则无法指定准确的偏移量

```
查看当前数据库binlog文件和偏移量
show master status;

change master to master_host='主库ip', master_user='用于复制的用户名', master_password='密码', master_port=master节点端口, master_log_file='主节点对应的binlog文件', master_log_pos=主节点对应的binlog文件偏移量;

#互为主从
# 192.168.52.5上执行
* change master to master_host='192.168.52.6', master_user='slave', master_password='123456', master_port=3306, master_log_file='mysql-bin.000001', master_log_pos=328;
* START SLAVE;
# 192.168.52.6上执行
* change master to master_host='192.168.52.5', master_user='slave', master_password='123456', master_port=3306, master_log_file='mysql-bin.000002', master_log_pos=328;
* START SLAVE;

```

