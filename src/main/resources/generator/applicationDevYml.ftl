spring:
  application:
    name: ${atfId}
<#if mysql??>
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://${mysql}?characterEncoding=utf8
    username: ${dbUsername}
    password: ${dbPassword}
    # 初始化大小，最小，最大
    initialSize: 1
    minIdle: 3
    maxActive: 200
    # 配置获取连接等待超时的时间
    maxWait: 60000
    # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
    timeBetweenEvictionRunsMillis: 60000
    # 配置一个连接在池中最小生存的时间，单位是毫秒
    minEvictableIdleTimeMillis: 30000
    validationQuery: select 'x'
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    # 打开PSCache，并且指定每个连接上PSCache的大小
    poolPreparedStatements: true
    maxPoolPreparedStatementPerConnectionSize: 20
    # 配置监控统计拦截的filters，去掉后监控界面sql无法统计，'wall'用于防火墙
    filters: stat,wall,slf4j
    # 通过connectProperties属性来打开mergeSql功能；慢SQL记录
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000
</#if>
  mvc:
    throw-exception-if-no-handler-found: true
  servlet:
    multipart:
      max-request-size: "3MB"
      max-file-size: "2MB"

server:
  port: ${port}

#日志插件默认配置
gwmlog:
  #平台名称，必须全小写，不可以有特殊字符，请使用部门名称简写（如：ywztb）
  platformname: "ywztb"
<#list grpId?split(".") as s>
  <#if !s_has_next>
  #项目名称，必须全小写，不可以有特殊字符（如：mes）
  projectname: ${s}
  </#if>
</#list>
  default:
    #默认索引名称，必须全小写，不可以有特殊字符
    indexname: "default"
    #默认日志类型，必须全小写，不可以有特殊字符（如：info、debug、warn、exception、error）
    logtype: "exception"

<#if eureka??>
eureka:
  instance:
    prefer-ip-address: true
  client:
    #DNS域名,获取其他信息将以该域名为根域名
    eureka-server-d-n-s-name: xxx.com/${atfId}
    #开启DNS方式获取serviceUrl,默认为false
    use-dns-for-fetching-service-urls: true
    serviceUrl:
      defaultZone: ${eureka}
</#if>
<#if feign??>
feign:
  hystrix:
    enabled: true

hystrix:
  default:
    coreSize: 50 #并发执行的最大线程数 50
    maxQueueSize: 200 #BlockingQueue的最大队列数 200
    queueSizeRejectionThreshold: 200 #即使maxQueueSize没有达到，达到queueSizeRejectionThreshold该值后，请求也会被拒绝
  command:
    default:
      execution:
        timeout:
          enabled: true #执行是否启用超时
        isolation:
          thread:
            #hystrix超时时间的计算： (1 + MaxAutoRetries + MaxAutoRetriesNextServer) * ReadTimeout
            timeoutInMilliseconds: 3000  #命令执行超时时间 3秒
          semaphore:
            maxConcurrentRequests:  50 #最大并发请求数 50
      fallback:
        isolation:
          semaphore:
            maxConcurrentRequests: 50 #如果并发数达到该设置值，请求会被拒绝和抛出异常并且fallback不会被调用。50
    #配置具体方法超时时间  类名#方法名(入参类型)
#    UserService#usersById(Integer):
#      execution:
#        isolation:
#          thread:
#            timeoutInMilliseconds: 5000



ribbon:
  #ribbon 读取超时时长，默认5000  ribbonTimeout = (ReadTimeout + ConnectTimeout) * (maxAutoRetries + 1) * (maxAutoRetriesNextServer + 1);
  ReadTimeout: 5000
  retryableStatusCodes: 404,405,500

  #是否所有操作都重试,设置为false时，只会对get请求进行重试。设置为true,对所有的请求进行重试。
  #如果设置为true,put或post等写操作，必须做做幂等性验证
  OkToRetryOnAllOperations: false

  #负载均衡规则,过滤掉那些因为一直连接失败的
  #被标记为circuit tripped的后端server，
  #并过滤掉那些高并发的的后端
  #server（active connections 超过配置的阈值）
  NFLoadBalancerRuleClassName: com.netflix.loadbalancer.AvailabilityFilteringRule #AvailabilityFilteringRule
  eureka:
    enabled: true

#配置具体服务实例
#provider:
#  ribbon:
#    ReadTimeout: 3500
#    ConnectTimeout: 500 #ribbon 链接超时时长,默认2000
#    #重试的次数：MaxAutoRetries + MaxAutoRetriesNextServer + (MaxAutoRetries * MaxAutoRetriesNextServer) 即重试1次，
#    MaxAutoRetries: 0 #当前服务重试次数，默认0
#    MaxAutoRetriesNextServer: 1 #切换服务实例的重试次数(配置为服务实例集群数量-1)，默认1
</#if>

#apollo:
#  meta:   #此处配置apollo地址
#  bootstrap:
#    enabled: true
#    eagerLoad:
#      enabled: true

<#if mysql??>
mybatis:
  mapper-locations: classpath:/mapper/*Mapper.xml
  configuration:
    #开启驼峰命名转换
    map-underscore-to-camel-case: true
    #打印sql信息
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
</#if>

#暴露全部的监控信息
management:
 endpoints:
    web:
      exposure:
        include: "*"
 endpoint:
    health:
      show-details: ALWAYS
