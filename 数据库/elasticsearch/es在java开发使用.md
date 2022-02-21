
## spring-data-elasticsearch 注解解释
* https://docs.spring.io/spring-data/elasticsearch/docs/4.0.3.RELEASE/reference/html/#elasticsearch.mapping.meta-model.annotations
### @Document
```
这个主键对应的ElasticsearchCase#createIndex()方法

indexName 索引名称
type 类型
useServerConfiguration 是否使用系统配置
shards 集群模式下分片存储，默认分5片
replicas 数据复制几份，默认一份
refreshInterval 多久刷新数据 默认:1s
indexStoreType 索引存储模式 默认:fs，为深入研究
createIndex 是否创建索引，默认:true
```

### @Id


### @Field
踩坑 字段类型对于es来说很重要 不能随便变更 比如从字符串到时间，从float到double，都是不能再有数据之后再转换的，此时必须使用 elasticsearch-dump数据转换（读取重插入）
这个主键对应的ElasticsearchCase#setMappings()方法
```
type 字段类型 默认根据java类型推断,可选类型：Text,Integer,Long,Date,Float,Double,Boolean,Object,Auto,Nested,Ip,Attachment,Keyword,新的数据类型请参考官网
index 默认tru,非查询索引字段可以指定为false
format 数据格式，可以理解为一个正则拦截可存储的数据格式
pattern 使用场景：format = DateFormat.custom, pattern = "uuuu-MM-dd HH:mm:ss:SSS"
    uuuu是重点！ ： https://www.elastic.co/guide/en/elasticsearch/reference/current/migrate-to-java-time.html#java-time-migration-incompatible-date-formats
        @Field(name = "created_date_time", type = FieldType.Date, format = DateFormat.custom, pattern = "uuuu-MM-dd HH:mm:ss")
        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
searchAnalyzer 搜索的分词，新的ik分词只有ik_smart和ik_max_word两个模式
store 是否单独存储，应该是存储在_source
analyzer 分词模式
ignoreFields 
includeInParent 
fielddata  默认为false，当对文本字段进行排序，聚合操作时会抛出异常。改成true解决
    * Text fields are not optimised for operations that require per-document field data like aggregations and sorting, so these operations are disabled by default. Please use a keyword field instead. Alternatively, set fielddata=true on [***] in order to load field data by uninverting the inverted index. Note that this can use significant memory.
```

```
作者：zhaoyunxing
链接：https://www.jianshu.com/p/7019d93219f5
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```

### @TypeAlias
可以隐藏类名称，设置生成的index，对应_source里面的_class属性
