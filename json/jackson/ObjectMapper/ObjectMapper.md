### objectMapper日期序列化与反序列化
```
ObjectMapper objectMapper = ObjectMapperUtils.buildInstance();
// 下面配置解决LocalDateTime序列化的问题
objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
JavaTimeModule javaTimeModule = new JavaTimeModule();

//日期序列化
javaTimeModule.addSerializer(LocalDateTime.class, new LocalDateTimeSerializer(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
javaTimeModule.addSerializer(LocalDate.class, new LocalDateSerializer(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
javaTimeModule.addSerializer(LocalTime.class, new LocalTimeSerializer(DateTimeFormatter.ofPattern("HH:mm:ss")));

//日期反序列化
javaTimeModule.addDeserializer(LocalDateTime.class, new LocalDateTimeDeserializer(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
javaTimeModule.addDeserializer(LocalDate.class, new LocalDateDeserializer(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
javaTimeModule.addDeserializer(LocalTime.class, new LocalTimeDeserializer(DateTimeFormatter.ofPattern("HH:mm:ss")));

objectMapper.registerModule(javaTimeModule);
```

#### 1、对象与json字符串、byte数组
```
@Test
public void testObj() throws JsonGenerationException, JsonMappingException, IOException {
    Object obj = new Object();

    mapper.writeValue(new File("D:/test.txt"), obj); // 写到文件中
    // mapper.writeValue(System.out, obj); //写到控制台

    String jsonStr = mapper.writeValueAsString(obj);
    System.out.println("对象转为字符串：" + jsonStr);

    byte[] byteArr = mapper.writeValueAsBytes(obj);
    System.out.println("对象转为byte数组：" + byteArr);

    Object obj = mapper.readValue(jsonStr, Object.class);
    System.out.println("json字符串转为对象：" + obj);

    Object useDe2 = mapper.readValue(byteArr, Object.class);
    System.out.println("byte数组转为对象：" + useDe2);
}
```

 
#### 2、list集合与json字符串
```
@Test
public void testList() throws JsonGenerationException, JsonMappingException, IOException {
    List<Object> list = new ArrayList<>();

    String jsonStr = mapper.writeValueAsString(list);
    System.out.println("集合转为字符串：" + jsonStr);
    
    // jsonNode转对象
    JavaType javaType = objectMapper.getTypeFactory().constructParametricType(ArrayList.class, FileDataRecords.class);
    return objectMapper.convertValue(jsonNode, javaType);
                            
    List<Object> listDes = mapper.readValue(jsonStr, List.class);
    System.out.println("字符串转集合：" + listDes);
    
    JavaType javaType = objectMapper.getTypeFactory().constructCollectionType(ArrayList.class, T.class);
    List<T> listDes = objectMapper.readValue(str, javaType);
    System.out.println("字符串转集合：" + listDes);
}
```
 

#### 3、map与json字符串

```
@Test
public void testMap() {
    Map<String, Object> testMap = new HashMap<>();
    testMap.put("name", "merry");
    testMap.put("age", 30);
    testMap.put("date", new Date());

    try {
        String jsonStr = mapper.writeValueAsString(testMap);
        System.out.println("Map转为字符串：" + jsonStr);
        try {
            Map<String, Object> testMapDes = mapper.readValue(jsonStr, Map.class);
            System.out.println("字符串转Map：" + testMapDes);
        } catch (IOException e) {
            e.printStackTrace();
        }
    } catch (JsonProcessingException e) {
        e.printStackTrace();
    }
}
```