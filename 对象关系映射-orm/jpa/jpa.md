### jpa注解
@Entity                                  --声明为一个实体类bean      
@Table (name= "promotion_info" )         --为实体bean映射指定表(表名="promotion_info)      
@Id                                      --声明了该实体bean的主键   
@GeneratedValue                          --可以定义主键的生成策略.      
@Transient                               --将忽略这些字段和属性,不持久化到数据库      
@Column (name= "promotion_remark" )      --声明列(字段名= "promotion_total" ) 属性还包括(length= 200 等)      
@Temporal (TemporalType.TIMESTAMP)       --声明时间格式      
@Enumerated                              --声明枚举      
@Version                                 --声明添加对乐观锁定的支持      
@OneToOne                                --可以建立实体bean之间的一对一的关联      
@OneToMany（mappedBy = "oneId"）          --可以建立实体bean之间的一对多的关联      
@ManyToOne                               --可以建立实体bean之间的多对一的关联      
@ManyToMany                              --可以建立实体bean之间的多对多的关联      
@Formula                                 --一个SQL表达式，这种属性是只读的,不在数据库生成属性(可以使用sum、average、max等)     
@OrderBy                                 --取出的集合排序
@JoinColumn                              --设置对应数据表的列名和引用的数据表的列名      
@Basic(fetch = FetchType.LAZY)
#### 一些坑
* @Formula 的坑
```
1. 不能和@Transient一起使用，在使用@Formula的字段作为查询条件时会报错说找不到
2. @Query nativeQuery = true 不能使用 使用nativeQuery=true的查询返回对象进行转换时会有一个columnName=null的null指针异常
```

### 子查询

```

public static Specification<OneModel> getBySpecs(){

    return (root, criteriaQuery, criteriaBuilder) -> {
    
        // 存放多个条件
        List<Predicate> predicateList = new ArrayList<>();// 存放多个条件
           
        // 子查询
        Subquery<MoreModel> subQuery = query.subquery(MoreModel.class);
        Root<MoreModel> subRoot = subQuery.from(MoreModel.class);
        // 子查询条件
        List<Predicate> subPredicateList = new ArrayList<>();// 存放多个条件
        subPredicateList.add(cb.equal(subRoot.get("userId"), userId));
        // 子查询设置查询字段和查询提交
        subQuery.select(subRoot.get("oneId")).where(subPredicateList.toArray(new Predicate[subPredicateList.size()]));
        // 主表和子查询的关联 root.id in {subQuery}
        predicateList.add(cb.in(root.get("id")).value(subQuery));
        
            // 效果等于 
            select 
                * 
            from 
                oneModel one 
            where 
                one.id in (
                    select oneId from moreModel more 
                        where more.userId = ?
                )
           
        // 排序条件
        List<Order> orderList = new ArrayList<>();
        //按“创建时间”进行降序排列
        orderList.add(criteriaBuilder.desc(root.get("createDateTime").as(LocalDateTime.class)));
        
        // 构建返回的封装对象
        Predicate[] predicates = new Predicate[predicateList.size()];
        return criteriaQuery.where(predicateList.toArray(predicates)).orderBy(orderList).getRestriction();     
    }

}


```


### 子查询 + max
```


@Entity
@Data
@Table(name = "one_model")
public class OneModel extends BaseJpaEntity{

    @OneToMany(mappedBy = "oneModel")
    private List<moreModel> moreModels;
}


@Entity
@Data
@Table(name = "more_model")
public class MoreModel extends BaseJpaEntity{

   @ManyToOne
   @JoinColumn(name = "oneId", referencedColumnName = "id", foreignKey = @ForeignKey(name = "FK_ONE_ID"))
   private OneModel oneModel;
   
   @Column(name = "created_date_time", nullable = false, updatable = false)
   @CreatedDate
   private LocalDateTime createDateTime;
   
   @Formula(value = "( select max(t.created_date_time) from more_model t where t.one_id = one_id and t.category = category )")
   @Basic(fetch = FetchType.LAZY)
   @JsonIgnore
   private LocalDateTime maxCreateDateTime;
}


public static Specification<OneModel> getBySpecs(){

    return (root, criteriaQuery, criteriaBuilder) -> {
    
        // 存放多个条件
        List<Predicate> predicateList = new ArrayList<>();// 存放多个条件
           
           
            // 左连接 当前 连接 oneModel
            Join<OneModel, MoreModel> moreModelJoin = root.join("moreModels", JoinType.LEFT);
            
            // 子查询
            Subquery<MoreModel> subQuery = criteriaQuery.subquery(MoreModel.class);
            Root<MoreModel> subRoot = subQuery.from(MoreModel.class);
            subQuery.select(subRoot.get("id"));
            
            List<Predicate> subPredicateList = new ArrayList<>();// 存放多个条件
            subPredicateList.add(criteriaBuilder.equal(moreModelJoin.get("lastFourNumber"), WrapperUtils.lastFour(idCardNumber)));
            subPredicateList.add(criteriaBuilder.equal(subRoot.get("category"), MoreModel.DocumentationCategory.ID_CARD));
            subPredicateList.add(criteriaBuilder.equal(subRoot.get("oneModel"), root.get("id")));
            subPredicateList.add(criteriaBuilder.equal(subRoot.get("createDateTime"), subRoot.get("maxCreateDateTime")));
            
            Predicate[] subPredicates = new Predicate[subPredicateList.size()];
            subQuery.where(subPredicateList.toArray(subPredicates));
            
            predicateList.add(criteriaBuilder.equal(moreModelJoin.get("id"), subQuery));
            
           
            // 效果等于 
            select 
                * 
            from 
                oneModel one 
                left jion moreModel more on one.id = more.oneId
            where more.id = (
                    select id from moreModel more_2 
                        where more_2.category = ? 
                        and more_2.oneId = one.id 
                        and more_2.createDateTime =  select max(t.created_date_time) from more_model t where t.one_id = more_2.one_id and t.category = more_2.category )
                
                )
           
        // 排序条件
        List<Order> orderList = new ArrayList<>();
        //按“创建时间”进行降序排列
        orderList.add(criteriaBuilder.desc(root.get("createDateTime").as(LocalDateTime.class)));
        
        // 构建返回的封装对象
        Predicate[] predicates = new Predicate[predicateList.size()];
        return criteriaQuery.where(predicateList.toArray(predicates)).orderBy(orderList).getRestriction();     
    }

}

                


```