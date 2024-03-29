

## ES 中的查询
* _source 只返回_source数组中包含的字段
```
{
  "_source":["title"],  #只返回title字段
  "query": {
    "match_all": {}
  }
}
```
* query 查询参数
* from 分页参数
* size 分页参数
* sort 排序参数
* aggs 聚合参数

### query 检索的类型 初级篇 基本查询
* match_all ： 查询所有文档
```
{
  "query": {
    "match_all": {}
  }
}
```
* match 和 term ： match是模糊查询,term是精确查询
```
match认为my和friends是两个词，可以匹配出title字段内容包含“friends”和“my”两个词的文档。
term认为my friends是一个词，只能精确匹配出title字段内容包含"my friends"的文档
{
  "query": {
    "match": {
      "title":  "my friends" 
    }
  }
}
```
* multi_match ： 多字段匹配
```
匹配名称、标题、内容("name","title","content") 任一字段包含内容"bolg"和"my"两个词的文档
{
  "query": {
    "multi_match": {
      "query" : "blog my",
      "fields":  ["name","title","content"]   #只要里面一个字段包含值 blog 既可以
    }
  }
}
```
* match_phrase ： 短语匹配查询
```
    ES引擎首先分析查询字符串，从分析后的文本中构建短语查询。
    这意味着必须匹配短语中的所有分词，并且保证各个分词的相对位置不变。
    如：我的家乡 
    1. 对查询字符串进行分词  我 的 家乡
```
```
    扫描所有倒排索引, 性能较差.
```
* prefix ：前缀检索
* wildcard ：通配符检索
* regexp ： 正则检索
* fuzzy ： 纠错检索
```
. fuzzy min_similarity
. fuzzy max_expansions
```
```
    扫描所有倒排索引, 性能较差.
```
* boost ： 评分权重 - 控制文档的优先级别
```
通过boost参数, 令满足某个条件的文档的得分更高, 从而使得其排名更靠前.
{
    "query": {
        "bool": {
            "must": [
                { "match": { "name": "编程思想"} }
            ], 
            "should": [
                { 
                   "match": { 
                        "name": {
                            "query": "艺术", 
                            "boost": 2        // 提升评分权重
                        } 
                    }
                }
            ],
            "minimum_should_match": 1   // 至少满足should中的一个条件
        }
    }
}
```
* dis_max的用法 - best fields策略
```
(1) dis_max的提出
如果我们希望检索结果中 (检索串被分词后的) 关键字匹配越多, 这样的文档就越靠前, 而不是多个子检索中匹配少量分词的文档靠前.
⇒ 此时可以使用dis_max和tie_breaker.
tie_breaker的值介于0~1之间, Elasticsearch将 bool检索的分数 * tie_breaker的结果与dis_max的最高分进行比较, 除了取dis_max的最高分以外, 还会考虑其他的检索结果的分数.
(2) 使用示例
为了增加精准度, 常用的是配合boost、minimum_should_match等参数控制检索结果.
```
* query_string
```
{
    "query": {
        "bool" : {
            "must" : [
                { "query_string" : { "query" : "?", "fields" : [ "name" ] } },
                { "query_string" : { "query" : "?", "fields" : [ "price" ] } }
            ]
        }
    }
}
```


### query 检索的类型 中级篇 复合查询
* filter ： 必须匹配 以不评分、过滤模式来进行
```
语句对评分没有贡献，只是根据过滤标准来排除或包含文档
* range ： 范围过滤 gt:> lt:< gte:>= lte:<=
```
* bool ： 过滤查询/联合查询 must, should, must_not
```
 * must: 文档必须完全匹配条件；多个全部满足； must中放两个term会得不到想要的结果
 * should: should下面会带一个以上的条件，至少满足一个条件，这个文档就符合should；多个任一满足；
 * must_not: 文档必须不匹配条件；多个全部不满足；
 {
   "query": {
     "bool":{
       "should": [
         {"term":{"price": 25}},
         {"term":{"itemID": "id1004"}}
       ],
       "must_not": [
         {"term":{"price": 30}}
       ]
     }
   }
 }
```

#### 复合查询示例
```
检索出版时间在2012-07之后, 且至少满足下述条件中一个的文档:
a. 名称(name)中包含"并发";
b. 描述(desc)中包含"java" 且 出版社(publisher)名称中不包含"电子".
按照价格倒序
GET shop/_search
{
    "query": {
        "bool": {
            "filter": {                 // 按时间过滤
                "range": {
                    "date": {"gte": "2012-07"}
                }
            },
            "should": [                 // 可匹配, 可不匹配
                {
                    "match": { "name": "并发" }
                },
                {
                    "bool": {
                        "must": {       // 必须匹配
                            "match": { "desc": "java" }
                        },
                        "must_not": {   // 不能匹配
                            "match": { "publisher": "电子" }
                        }
                    }
                }
            ],
            "minimum_should_match": 1   // 至少满足should中的一个条件
        }
    }, 
    // 自定义排序
    "sort": [
        { "price": { "order": "desc" } }
    ]
}
```

### query 检索的类型 高级篇 聚合查询
* terms 分组 其作用与关系型数据库中group by相同
```
GET /lib4/items/_search  
{
    "size": 0,
    "aggs": {
        "category_of_by": {
            "terms": {
                "field": "category"   //按类别来分组
            }
        }
    }
}
```
* sum 综合
```
GET /items/_search
{
  "size": 0, //表示查询多少条文档，聚合只需总和结果，输出文档可以设置为0条
  "aggs": {
    "price_of_sum": {//自行取名作为结果集
      "sum": {
        "field":"price"
      }
    }
  }
}
```
* min 最小值
```
GET /items/_search
{
    "size": 0,
    "aggs": {
        "price_of_min": {
            "min": {
                "field": "price"
            }
        }
    }
}
```
* avg 平均值
* cardinality 求基数
```
其实相当于该字段互不相同的值有多少类，输出的是种类数
```
