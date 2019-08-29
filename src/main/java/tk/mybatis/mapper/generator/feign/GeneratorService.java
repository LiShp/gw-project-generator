package tk.mybatis.mapper.generator.feign;

import com.alibaba.fastjson.JSONArray;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.OutputStream;
import java.util.Properties;

@FeignClient(name = "gw-code-generator",fallbackFactory = FeignClientFallbackFactory.class)
public interface GeneratorService {

    @RequestMapping(value = "/business/autocode/getTables", method = RequestMethod.GET)
    JSONArray getTables(
            @RequestParam("driverName") String driverName,
            @RequestParam("dbUrl") String dbUrl,
            @RequestParam("dbPort") String dbPort,
            @RequestParam("dbName") String dbName,
            @RequestParam("userName") String userName,
            @RequestParam("password") String password);

    @RequestMapping(value = "/business/autocode/exportAll", method = RequestMethod.GET)
    void exportAll( @RequestParam("properties")Properties properties,  @RequestParam("tableNames")String tableNames,  @RequestParam("out")OutputStream out);

    @RequestMapping(value = "/business/autocode/getOutputStream", method = RequestMethod.GET)
    JSONArray getOutputStream(
            @RequestParam("driverName")String driverName,
            @RequestParam("dbUrl")String dbUrl,
            @RequestParam("dbPort")String dbPort,
            @RequestParam("dbName")String dbName,
            @RequestParam("userName")String userName,
            @RequestParam("password")String password,
            @RequestParam("tableNames")String tableNames,
            @RequestParam("projectPakage")String projectPakage

    );
}
