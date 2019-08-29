package ${package};

import com.gw.cloud.common.base.mapper.BaseMapper;
import ${tableClass.fullClassName};
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Component;

@Mapper
@Component
public interface ${tableClass.shortClassName}${mapperSuffix} extends BaseMapper<${tableClass.shortClassName}> {

}




