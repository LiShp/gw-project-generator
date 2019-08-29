package ${grpId}.${atfId};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
<#if feign??>
import org.springframework.cloud.netflix.hystrix.EnableHystrix;
import org.springframework.cloud.netflix.hystrix.dashboard.EnableHystrixDashboard;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.cloud.client.SpringCloudApplication;
</#if>
import org.springframework.context.annotation.ComponentScan;
import springfox.documentation.swagger2.annotations.EnableSwagger2;
import tk.mybatis.spring.annotation.MapperScan;

@SpringBootApplication
@EnableSwagger2
@MapperScan(basePackages = "${grpId}.${atfId}.mapper")
@ComponentScan(basePackages = {"${grpId}.${atfId}.*","com.gw.cloud.common.base.config"})
<#if feign??>
@EnableFeignClients
@EnableHystrix
@EnableHystrixDashboard
@SpringCloudApplication
</#if>
public class ${atfId?cap_first}Application {

    public static void main(String[] args) {SpringApplication.run(${atfId?cap_first}Application.class, args);}

}



