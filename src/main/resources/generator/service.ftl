package ${package};

import com.gw.cloud.common.base.service.BaseService;
import ${tableClass.fullClassName};
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ${tableClass.shortClassName}${mapperSuffix} extends BaseService<Integer,${tableClass.shortClassName}> {

}




