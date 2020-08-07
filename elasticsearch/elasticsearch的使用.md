## 配置
```
/**
 * @description： Elasticsearch 配置文件
 * <p>
 * SpringBoot 集成 ES 的步骤：
 * 1、导入依赖
 * https://www.elastic.co/guide/en/elasticsearch/client/java-rest/current/java-rest-high-getting-started-maven.html
 * 2、编写 ES 配置，给容器中注入一个 RestHighLevelClient，用来操作 9200 端口
 * https://www.elastic.co/guide/en/elasticsearch/client/java-rest/current/java-rest-high-getting-started-initialization.html
 * 3、参照官方API
 */
@Configuration
public class ElasticsearchConfig {
    @Value("${elasticsearch.ip}")
    private String elasticsearchIp;

    @Bean
    public RestHighLevelClient esRestHighLevelClient() {
        RestClient restClient = RestClient.builder(
                // 这里可以配置多个 es服务，我当前服务不是集群，所以目前只配置一个
                new HttpHost(elasticsearchIp, 9200, "http")).build();

        RestHighLevelClient client = new RestHighLevelClient(restClient);

        return client;
    }

}
```
## 使用
```
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.elasticsearch.action.get.GetRequest;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ElasticSearchService {

    @Resource
    private RestHighLevelClient client;

    /**
     * 测试存储数据到es
     * 更新也是可以的
     */
    public void indexData(DcProjectBaseDTO projectBase) throws IOException {
        // 准备数据
        String type = projectBase.getAttachName().substring(projectBase.getAttachName().lastIndexOf(".") + 1, projectBase.getAttachName().length());
        IndexRequest indexRequest = new IndexRequest("dcc", type);//索引名
        indexRequest.id(projectBase.getId().toString());//数据id

        String jsonString = JSON.toJSONString(projectBase);
        indexRequest.source(jsonString, XContentType.JSON); //要保存的内容

        // 执行操作
        IndexResponse index = client.index(indexRequest);

        // 提取有用的数据相应
        System.out.println(index);
    }

    /**
     * 检索数据
     *
     * @throws IOException
     */
    public DcProjectBaseDTO getOne(DcProjectBase projectBase) throws IOException {
        try {
            String type = projectBase.getAttachName().substring(projectBase.getAttachName().lastIndexOf(".") + 1, projectBase.getAttachName().length());
            // 1、创建检索请求
            GetRequest getSourceRequest = new GetRequest("dcc", type, projectBase.getId().toString());

            // 2、执行检索
            GetResponse searchResponse = client.get(getSourceRequest);

            if (searchResponse != null && searchResponse.getSource() != null) {
                String str = JSON.toJSONString(searchResponse.getSource());
                DcProjectBaseDTO dcProjectBaseDTO = JSON.parseObject(str, DcProjectBaseDTO.class);
                return dcProjectBaseDTO;
            }
            return null;
        } catch (Exception e) {
            return null;
        }

    }

    /**
     * 检索数据
     *
     * @throws IOException
     */
    public IPage<DcProjectBaseDTO> searchData(Integer page, Integer pageSize, String queryStr, Long projectId) throws IOException {
        IPage pages = new Page(page, pageSize);
        // 1、创建检索请求
        SearchRequest searchRequest = new SearchRequest();
        // 指定索引
        searchRequest.indices("dcc");
        // 指定DSL，检索条件
        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
        // 1.1）、构造检索条件
        //        sourceBuilder.query(QueryBuilders.termQuery("user", "kimchy"));
        //        sourceBuilder.from(0);
        //        sourceBuilder.size(5);
        //        sourceBuilder.timeout(new TimeValue(60, TimeUnit.SECONDS));
        //设置默认查询条件
        searchSourceBuilder.from((page - 1) * pageSize);
        searchSourceBuilder.size(pageSize);

        //Bool Query
        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        boolQueryBuilder.must(QueryBuilders.matchQuery("projectId", projectId));
        boolQueryBuilder.filter(QueryBuilders.matchQuery("text", queryStr));
        //这里还要处理只能查我能看到的部门的数据
        List<String> departIds = new ArrayList<>();

        //这里还要处理只能查我能看到的部门的数据 should 表示or
        departIds.forEach(t -> {
            boolQueryBuilder.should(QueryBuilders.multiMatchQuery("departId", t));
        });

        searchSourceBuilder.query(boolQueryBuilder);


        System.out.println("检索条件：" + searchSourceBuilder.toString());
        searchRequest.source(searchSourceBuilder);

        // 2、执行检索
        SearchResponse searchResponse = client.search(searchRequest);

        // 3、分析结果 searchResponse
        System.out.println(searchResponse.toString());

        //3.1）、获取所有查到的数据
        SearchHits hits = searchResponse.getHits(); // 获取到最外围的 hits
        SearchHit[] searchHits = hits.getHits(); // 内围的 hits 数组
        List<DcProjectBaseDTO> list = new ArrayList<>();
        for (SearchHit hit : searchHits) {
            /**
             * "_index":"bank",
             *        "_type":"account",
             *        "_id":"970",
             *        "_score":5.4032025,
             *        "_source":{
             */
            //            hit.getIndex();hit.getType()''
            String str = hit.getSourceAsString();
            //将存储的json数据转换成前端使用的数据
            DcProjectBaseDTO dcProjectBaseDTO = JSON.parseObject(str, DcProjectBaseDTO.class);

            System.out.println(dcProjectBaseDTO.toString());
            list.add(dcProjectBaseDTO);

        }
        pages.setTotal(hits.getTotalHits());
        pages.setRecords(list);
        return pages;
    }
}

```