package ${package};

import com.gw.cloud.common.base.controller.BaseController;
import ${tableClass.fullClassName};
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Api(value="/${tableClass.lowerCaseName}", description="")
@RestController
@RequestMapping("/${tableClass.lowerCaseName}")
public class ${tableClass.shortClassName}${mapperSuffix} extends BaseController<Integer,${tableClass.shortClassName}> {

}




