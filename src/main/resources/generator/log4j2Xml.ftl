<?xml version="1.0" encoding="UTF-8"?>
<!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
<!--Configuration后面的status,这个用于设置log4j2自身内部的信息输出,可以不设置,当设置成trace时,你会看到log4j2内部各种详细输出 -->
<!--monitorInterval：Log4j能够自动检测修改配置 文件和重新配置本身,设置间隔秒数 -->
<configuration status="WARN" monitorInterval="1800">
    <Properties>

        <!-- 日志默认存放的位置,这里设置为项目根路径下,也可指定绝对路径 -->
        <property name="basePath">${r'${sys:user.dir}'}/target/gwm-log</property>
        <!--设置日志格式标示-->
        <property name="log_type" value="GWML001"/>

        <!-- 日志文件默认输出格式-->
        <property name="log_pattern">${r'${log_type}'}|%d{yyyy-MM-dd'T'HH:mm:ss.SSS Z}|%level|%logger %L|%msg%n</property>
        <property name="gwml001_log_patten">${r'${log_type}'}|%d{yyyy-MM-dd'T'HH:mm:ss.SSS Z}|%level|${r'${log_type}'}JSON|%msg%n
        </property>

        <!-- 日志默认切割的最小单位 -->
        <property name="every_file_size">100MB</property>
        <!-- 日志默认输出级别 -->
        <property name="output_log_level">DEBUG</property>

        <!-- 日志默认存放路径(所有级别日志) -->
        <property name="rolling_fileName">${r'${basePath}'}/gwm-log.log</property>
        <property name="rolling_filePattern">${r'${basePath}'}/gwm-log-%d{yyyy-MM-dd}.%i.log</property>
        <property name="rolling_max">60</property>

        <!-- Info日志默认存放路径(Info级别日志) -->
        <property name="info_fileName">${r'${basePath}'}/gwm-log-info.log</property>
        <property name="info_filePattern">${r'${basePath}'}/gwm-log-info-%d{yyyy-MM-dd}.%i.log</property>
        <property name="info_max">60</property>

        <!-- Warn日志默认存放路径(Warn级别日志) -->
        <property name="warn_fileName">${r'${basePath}'}/gwm-log-warn.log</property>
        <property name="warn_filePattern">${r'${basePath}'}/gwm-log-warn-%d{yyyy-MM-dd}.%i.log</property>
        <property name="warn_max">60</property>

        <!-- Error日志默认存放路径(Error级别日志) -->
        <property name="error_fileName">${r'${basePath}'}/gwm-log-error.log</property>
        <property name="error_filePattern">${r'${basePath}'}/gwm-log-error-%d{yyyy-MM-dd}.%i.log</property>
        <property name="error_max">60</property>

        <!-- 控制台显示的日志最低级别 -->
        <property name="console_print_level">INFO</property>

    </Properties>

    <!--定义appender -->
    <appenders>
        <!-- 用来定义输出到控制台的配置 -->
        <Console name="Console" target="SYSTEM_OUT">
            <!-- 设置控制台只输出level及以上级别的信息(onMatch),其他的直接拒绝(onMismatch) -->
            <ThresholdFilter level="${r'${console_print_level}'}" onMatch="ACCEPT" onMismatch="DENY"/>
            <!-- 设置输出格式,不设置默认为:%m%n -->
            <PatternLayout pattern="${r'${log_pattern}'}"/>
        </Console>

        <!-- 打印root中指定的level级别以上的日志到文件 -->
        <RollingFile name="RollingFile" fileName="${r'${rolling_fileName}'}"
                     filePattern="${r'${rolling_filePattern}'}">
            <PatternLayout pattern="${r'${log_pattern}'}"/>
            <SizeBasedTriggeringPolicy size="${r'${every_file_size}'}"/>
            <!-- 设置同类型日志,同一文件夹下可以存放的数量,如果不设置此属性则默认存放7个文件 -->
            <DefaultRolloverStrategy max="${r'${rolling_max}'}"/>
            <!-- 匹配INFO以及以上级别 -->
            <Filters>
                <ThresholdFilter level="INFO" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
        </RollingFile>

        <!-- 打印INFO级别的日志到文件 -->
        <RollingFile name="InfoFile" fileName="${r'${info_fileName}'}"
                     filePattern="${r'${info_filePattern}'}">
            <PatternLayout pattern="${r'${log_pattern}'}"/>
            <SizeBasedTriggeringPolicy size="${r'${every_file_size}'}"/>
            <DefaultRolloverStrategy max="${r'${info_max}'}"/>
            <!-- 匹配INFO级别 -->
            <Filters>
                <ThresholdFilter level="WARN" onMatch="DENY" onMismatch="NEUTRAL"/>
                <ThresholdFilter level="INFO" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
        </RollingFile>

        <!-- 打印WARN级别的日志到文件 -->
        <RollingFile name="WarnFile" fileName="${r'${warn_fileName}'}"
                     filePattern="${r'${warn_filePattern}'}">
            <PatternLayout pattern="${r'${log_pattern}'}"/>
            <SizeBasedTriggeringPolicy size="${r'${every_file_size}'}"/>
            <DefaultRolloverStrategy max="${r'${warn_max}'}"/>
            <!-- 匹配WARN级别 -->
            <Filters>
                <ThresholdFilter level="ERROR" onMatch="DENY" onMismatch="NEUTRAL"/>
                <ThresholdFilter level="WARN" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
        </RollingFile>

        <!-- 打印ERROR级别的日志到文件 -->
        <RollingFile name="ErrorFile" fileName="${r'${error_fileName}'}"
                     filePattern="${r'${error_filePattern}'}">
            <PatternLayout pattern="${r'${log_pattern}'}"/>
            <SizeBasedTriggeringPolicy size="${r'${every_file_size}'}"/>
            <DefaultRolloverStrategy max="${r'${error_max}'}"/>
            <!-- 匹配ERROR级别 -->
            <Filters>
                <ThresholdFilter level="FATAL" onMatch="DENY" onMismatch="NEUTRAL"/>
                <ThresholdFilter level="ERROR" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
        </RollingFile>

        <!-- GWML001用来定义输出到控制台的配置 -->
        <Console name="${r'${log_type}'}_Console" target="SYSTEM_OUT">
            <!-- 设置控制台只输出level及以上级别的信息(onMatch),其他的直接拒绝(onMismatch) -->
            <ThresholdFilter level="${r'${console_print_level}'}" onMatch="ACCEPT" onMismatch="DENY"/>
            <!-- 设置输出格式,不设置默认为:%m%n -->
            <PatternLayout pattern="${r'${gwml001_log_patten}'}"/>
        </Console>

        <!-- GWML001打印INFO级别的日志到文件 -->
        <RollingFile name="${r'${log_type}'}_InfoFile" fileName="${r'${basePath}'}/${r'${log_type}'}-gwm-log-info.log"
                     filePattern="${r'${basePath}'}/${r'${log_type}'}-gwm-log-info-%d{yyyy-MM-dd}.%i.log">
            <PatternLayout pattern="${r'${gwml001_log_patten}'}"/>
            <SizeBasedTriggeringPolicy size="${r'${every_file_size}'}"/>
            <DefaultRolloverStrategy max="${r'${info_max}'}"/>
            <!-- 匹配INFO级别 -->
            <Filters>
                <ThresholdFilter level="WARN" onMatch="DENY" onMismatch="NEUTRAL"/>
                <ThresholdFilter level="INFO" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
        </RollingFile>

        <!-- GWML001打印WARN级别的日志到文件 -->
        <RollingFile name="${r'${log_type}'}_WarnFile" fileName="${r'${basePath}'}/${r'${log_type}'}-gwm-log-warn.log"
                     filePattern="${r'${basePath}'}/${r'${log_type}'}-gwm-log-warn-%d{yyyy-MM-dd}.%i.log">
            <PatternLayout pattern="${r'${gwml001_log_patten}'}"/>
            <SizeBasedTriggeringPolicy size="${r'${every_file_size}'}"/>
            <DefaultRolloverStrategy max="${r'${warn_max}'}"/>
            <!-- 匹配WARN级别 -->
            <Filters>
                <ThresholdFilter level="ERROR" onMatch="DENY" onMismatch="NEUTRAL"/>
                <ThresholdFilter level="WARN" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
        </RollingFile>

        <!-- GWML001打印ERROR级别的日志到文件 -->
        <RollingFile name="${r'${log_type}'}_ErrorFile" fileName="${r'${basePath}'}/${r'${log_type}'}-gwm-log-error.log"
                     filePattern="${r'${basePath}'}/${r'${log_type}'}-gwm-log-error-%d{yyyy-MM-dd}.%i.log">
            <PatternLayout pattern="${r'${gwml001_log_patten}'}"/>
            <SizeBasedTriggeringPolicy size="${r'${every_file_size}'}"/>
            <DefaultRolloverStrategy max="${r'${error_max}'}"/>
            <!-- 匹配ERROR级别 -->
            <Filters>
                <ThresholdFilter level="FATAL" onMatch="DENY" onMismatch="NEUTRAL"/>
                <ThresholdFilter level="ERROR" onMatch="ACCEPT" onMismatch="DENY"/>
            </Filters>
        </RollingFile>


    </appenders>


    <!--然后定义logger,只有定义了logger并引入的appender,appender才会生效 -->
    <loggers>
        <!--打印sql信息-->
        <logger name="com.broad.assessment.business.dao" level="DEBUG"></logger>
        <logger name="org.mybatis" level="DEBUG"></logger>
        <!-- 设置GWML001打印 -->
        <logger name="${r'${log_type}'}" additivity="false">
            <appender-ref ref="${r'${log_type}'}_InfoFile"/>
            <appender-ref ref="${r'${log_type}'}_WarnFile"/>
            <appender-ref ref="${r'${log_type}'}_ErrorFile"/>

            <!-- 生产环境去掉console -->
            <appender-ref ref="${r'${log_type}'}_Console"/>
        </logger>
        <!--建立一个默认的root的logger -->
        <root level="${r'${output_log_level}'}">
            <appender-ref ref="InfoFile"/>
            <appender-ref ref="WarnFile"/>
            <appender-ref ref="ErrorFile"/>

            <!-- 生产环境去掉console -->
            <appender-ref ref="Console"/>
        </root>
    </loggers>
</configuration>