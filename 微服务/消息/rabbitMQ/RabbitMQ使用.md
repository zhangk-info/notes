```java
class Test {
    public void send(Message message) {
        log.debug("缓存变更时通知其他节点清理本地缓存,{}", JSONUtil.toJsonStr(message));
        if (amqpTemplate instanceof RabbitTemplate) {
            RabbitTemplate rabbitTemplate = (RabbitTemplate) amqpTemplate;
            Channel channel = null;
            try {
                channel = rabbitTemplate.getConnectionFactory().createConnection().createChannel(false);
                // 开启发布确认
                channel.confirmSelect();
                channel.addConfirmListener(new ConfirmListener() {
                    @Override
                    public void handleAck(long deliveryTag, boolean multiple) throws IOException {
                        log.debug("缓存变更时通知其他节点清理本地缓存，消息确认成功");
                    }

                    @Override
                    public void handleNack(long deliveryTag, boolean multiple) throws IOException {
                        log.debug("缓存变更时通知其他节点清理本地缓存，消息确认失败，重新发送");
                        amqpTemplate.convertAndSend(MqConstants.L2_CACHE_MESSAGE, "", message);
                    }
                });
                // 发布
                channel.basicPublish(MqConstants.L2_CACHE_MESSAGE, "", null, JSONUtil.toJsonStr(message).getBytes(StandardCharsets.UTF_8));
                // 等待确认
                channel.waitForConfirmsOrDie();
            } catch (Exception e) {
                try {
                    log.error("channel 发送消息失败 尝试通过rabbitTemplate发送", e);
                    amqpTemplate.convertAndSend(MqConstants.L2_CACHE_MESSAGE, "", message);
                } catch (Exception ex) {
                    log.error("发送缓存更新消息失败: ", ex);
                    throw new RuntimeException("发送缓存更新消息失败");
                }
            } finally {
                try {
                    if (Objects.nonNull(channel) && channel.isOpen()) {
                        channel.close();
                    }
                } catch (IOException | TimeoutException e) {
                    log.error("channel关闭失败");
                }
            }
        } else {
            amqpTemplate.convertAndSend(MqConstants.L2_CACHE_MESSAGE, "", message);
        }
        log.debug("缓存变更时通知其他节点清理本地缓存,发送成功");
    }
}
```


```java
class Test {
    /**
     * 处理消息
     * ackMode = "MANUAL" 手动确认
     * @Queue 不定义名字使用生成的队列名字
     * type = ExchangeTypes.FANOUT 广播模式绑定到Exchange
     *
     * @param cacheMessage cacheMessage
     * @return void
     */
    @RabbitListener(bindings = {
            @QueueBinding(
                    value = @Queue(durable = "true"),
                    exchange = @Exchange(value = MqConstants.L2_CACHE_MESSAGE, type = ExchangeTypes.FANOUT)
            ),
    }, ackMode = "MANUAL")
    public void cacheMessageHandler(Message message, Channel channel) {
        long deliveryTag = message.getMessageProperties().getDeliveryTag();
        CacheMessage cacheMessage = JSONUtil.toBean(new String(message.getBody()), CacheMessage.class);
        L2CacheCacheManager l2CacheCacheManager = SpringUtil.getBean(L2CacheCacheManager.class);
        AmqpTemplate amqpTemplate = SpringUtil.getBean(AmqpTemplate.class);
        try {
            log.debug("收到缓存变更时通知清理本地缓存,{}", JSONUtil.toJsonStr(cacheMessage));
            // 不处理自己消息
            if (CharSequenceUtil.isBlank(cacheMessage.getCacheName())) {
                log.error("未识别的CacheMessage,{}", JSONUtil.toJsonStr(cacheMessage));
                return;
            }
            if (l2CacheCacheManager.getServerId().toString().equals(cacheMessage.getServerId().toString())) {
                log.debug("收到缓存变更时通知清理本地缓存,--------不处理自己的");
                return;
            }
            L2Cache l2Cache = l2CacheCacheManager.getCache(cacheMessage.getCacheName());
            if (Objects.nonNull(l2Cache)) {
                log.debug("清理之前在caffeine中获取到：{}，{}", l2Cache.getCaffeineCache().getIfPresent(l2Cache.getKey(cacheMessage.getKey(), cacheMessage.getTenantId())), l2Cache.toString());
            }
            l2CacheCacheManager.clearLocal(cacheMessage.getCacheName(), cacheMessage.getKey(), cacheMessage.getTenantId());
            if (Objects.nonNull(l2Cache)) {
                log.debug("清理之后在caffeine中获取到：{}，{}", l2Cache.getCaffeineCache().getIfPresent(l2Cache.getKey(cacheMessage.getKey(), cacheMessage.getTenantId())), l2Cache.toString());
            }
            channel.basicAck(deliveryTag, true);
        } catch (Exception e) {
            try {
                log.error("处理缓存消息失败，尝试拒绝签收：", e);
                channel.basicNack(deliveryTag, true, true);
            } catch (IOException ex) {
                try {
                    log.error("处理缓存消息失败，拒绝签收失败，进行消息重发：", ex);
                    amqpTemplate.convertAndSend(cacheMessage);
                } catch (Exception exx) {
                    log.error("处理缓存消息失败，进行消息重发失败");
                }
            }
        }
    }
}
```



## 断网重连后找不到queue

```java


@Configuration
@ConditionalOnClass(ListenerContainerConsumerFailedEvent.class)
@Slf4j
public class AmqpConfig {

    @Autowired
    private AmqpAdmin amqpAdmin;

    /**
     * 监听消费者失败事件
     * 如：断网
     *
     * @param containerConsumerFailedEvent 消费者失败事件
     */
    @EventListener
    public void containerConsumerFailedEvent(ListenerContainerConsumerFailedEvent containerConsumerFailedEvent) {
        SimpleMessageListenerContainer container = (SimpleMessageListenerContainer) containerConsumerFailedEvent.getSource();
        try {
            log.debug("listener queue failed !!! failed source：{}, reason：{}", containerConsumerFailedEvent.getSource(), containerConsumerFailedEvent.getReason(), containerConsumerFailedEvent.getThrowable());
            for (String queueName : container.getQueueNames()) {
                // queue在掉线后可能会被删除，在这里重建
                log.debug("--------------------------------------------------------------------------------------------------");
                log.info("-----  自动重新建立队列 {} 不存在 进行重建", queueName);
                log.debug("--------------------------------------------------------------------------------------------------");
                if (Objects.isNull(this.amqpAdmin.getQueueProperties(queueName))) {
                    this.amqpAdmin.declareQueue(new Queue(queueName, false, true, true, null));
                }
            }
            log.info("自动重新建立队列成功");
        } catch (Exception e) {
            log.debug("自动重新建立队列失败：{}", e.getMessage());
        }
    }
}

```