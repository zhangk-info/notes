# flink sql

## flink窗口tvf

## 滚动窗口

## 滑动窗口

窗口长度=滑动步长的整数倍（底层会优化成多个小滚动窗口）

## 累计窗口

## over聚合

## flink中的join

### regular join

sql: a inner join b on a.id=b.id

* inner
* left
* right
* full

### interval join

等待时间范围上下界 sql中用,做笛卡尔积
sql ： select * from a,b where a.id=b.id and a.et BETWEEN b.et - interval '2' second and b.et + interval '2' second;

### lookup join 查询维度表需要的

从外部获取当前系统时间存储的值：FOR SYSTEM TIME AS OF
sql :  a join dim FOR SYSTEM TIME AS OF dim.ts as dimA on dimA.id = a.id

## order by & limit 流式处理一般不用

### order by

必须时间字段再前切只能升序 order by ts [ asc],id

### limit

#### 属性

## SQL Hints（sql暗示）

可以在sql过程中修改表参数，只对当前job生效
语法：select * from xx /*+ OPTIONS('a'='','b'='') */

-- 设置状态缓存时间，用于丢弃长时间不使用的状态，如：join时状态会被存下来直到on的数据到
table.exec.state.ttl=1000;

## union / union all & intersect / intersect all & except / except all

union并集
intersect交集
except差集
不带all会去重,带all不会去重