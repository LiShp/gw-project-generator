package tk.mybatis.mapper.generator.feign;


import com.alibaba.fastjson.JSONArray;
import feign.hystrix.FallbackFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.OutputStream;
import java.util.Properties;

@Component
public class FeignClientFallbackFactory implements FallbackFactory<GeneratorService> {

    private static final Logger LOGGER =
            LoggerFactory.getLogger(FeignClientFallbackFactory.class);

    @Override
    public GeneratorService create(Throwable cause) {
        return new GeneratorService() {


            @Override
            public JSONArray getTables(String driverName, String dbUrl, String dbPort, String dbName, String userName, String password) {
                FeignClientFallbackFactory.LOGGER.info("fallback;reason was:", cause);
                System.out.println("fallback; reason was:" + cause);

                return null;
            }

            @Override
            public void exportAll(Properties properties, String tableNames, OutputStream out) {
                FeignClientFallbackFactory.LOGGER.info("fallback;reason was:", cause);
                System.out.println("fallback; reason was:" + cause);

            }

            @Override
            public JSONArray getOutputStream(String driverName, String dbUrl, String dbPort, String dbName, String userName, String password, String tableNames, String projectPakage) {
                FeignClientFallbackFactory.LOGGER.info("fallback;reason was:", cause);
                System.out.println("fallback; reason was:" + cause);

                return null;
            }
        };
    }


}
