/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014-2017 abel533@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package tk.mybatis.mapper.generator;

//import org.hsqldb.cmdline.SqlFile;

import com.alibaba.fastjson.JSONArray;
import org.mybatis.generator.api.GeneratedJavaFile;
import org.mybatis.generator.internal.ObjectFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import tk.mybatis.mapper.generator.feign.GeneratorService;
import tk.mybatis.mapper.generator.file.GenerateByTemplateFile;
import tk.mybatis.mapper.generator.formatter.TemplateFormatter;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URL;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * @author Jiayw
 */
@Controller
@RequestMapping("/")
public class Generator {

    @Autowired
    private GeneratorService service;

    private List<String> warnings = new ArrayList<String>();

    private String          templateContent;




    public static InputStream getResourceAsStream(String path){
        return Thread.currentThread().getContextClassLoader().getResourceAsStream(path);
    }


    @GetMapping
    public String index(){
        return "index";
    }

    @ResponseBody
    @GetMapping(value = "getTables")
    public JSONArray getTables(
                                            String driverName,
                                            String dbUrl,
                                            String dbPort,
                                            String dbName,
                                            String userName,
                                            String password){



            return service.getTables(driverName,dbUrl,dbPort,dbName,userName,password);
        }




    @GetMapping(value = "getZip")
    public void exportAll(
                            HttpServletResponse response,
                            String groupId,
                            String artifactId,
                            String description,
                            String port,
                            @RequestParam(required = false)String apollo,
                            @RequestParam(required = false)String eureka,
                            @RequestParam(required = false)Boolean feign,
                            @RequestParam(required = false)String dbUrl,
                            @RequestParam(required = false)String dbPort,
                            @RequestParam(required = false)String dbName,
                            @RequestParam(required = false)String username,
                            @RequestParam(required = false)String password,
                            @RequestParam(required = false) String driverName,
                            @RequestParam(required = false) String tableNames

    ) {
        ZipOutputStream zipStream  = null;
        OutputStream out = null;
        try {
            response.setContentType("application/octet-stream");
            String execlName = artifactId;
            response.addHeader("Content-Disposition", "attachment;filename="+new String(execlName.getBytes(),"iso-8859-1") +".zip");
            out = response.getOutputStream();
            zipStream  = new ZipOutputStream(out);//这里是把zip流输出到httpresponse流中

            Properties properties = new Properties();
            properties.setProperty("grpId", groupId);
            properties.setProperty("groupIdPacakge", groupId.replace(".","/"));
            properties.setProperty("atfId", artifactId);
            properties.setProperty("artifactName", toUpperCaseFirstOne(artifactId));
            properties.setProperty("dcption", description);
            properties.setProperty("port", port);
            if(!StringUtils.isEmpty(apollo)) {
                properties.setProperty("apollo", apollo);
            }
            if(!StringUtils.isEmpty(eureka)) {
                properties.setProperty("eureka", eureka);
            }
            if(feign) {
                properties.setProperty("feign", feign.toString());
                writeFileToZipStreamByMBG(properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/feign/fallback/","","UTF-8",zipStream);
            }
            if(!StringUtils.isEmpty(dbUrl) && !StringUtils.isEmpty(dbPort) && !StringUtils.isEmpty(dbName)){

                properties.setProperty("mysql", dbUrl+":"+dbPort+"/"+dbName);
                properties.setProperty("dbUsername", username);
                properties.setProperty("dbPassword", password);
            }

            if(!StringUtils.isEmpty(tableNames)){
                try {
                    //动态配置数据库参数
                    Properties dbproperties = new Properties();
                    dbproperties.setProperty("jdbc.driverName", driverName);
                    dbproperties.setProperty("jdbc.url", dbUrl+":"+dbPort+"/"+dbName);
                    dbproperties.setProperty("jdbc.username", username);
                    dbproperties.setProperty("jdbc.password", password);
                    dbproperties.setProperty("projectPakage", groupId+"."+artifactId);

                    JSONArray files = service.getOutputStream(driverName,dbUrl,dbPort,dbName,username,password,tableNames,groupId+"."+artifactId);
                    if(null != files){
                        for (Object obj: files) {
                            Map json = (Map) obj;
                            Iterator iterator = json.keySet().iterator();
                            while(iterator.hasNext()){
                                String filename = (String) iterator.next();
                                String content = json.get(filename).toString();
                                if(filename.contains("xml")){
                                    filename = properties.get("atfId")+"/src/main/resources/"+filename.replaceFirst("xml","");
                                }else{
                                    filename = properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/"+filename;
                                }
                                writeFileToZipStreamByMBG(filename,content,"UTF-8",zipStream);
                            }

                        }
                    }
                    exportAll(properties,zipStream);
                } catch (Exception e) {
                    e.getStackTrace();
                    System.out.println(e.getMessage());
                }
            }else{
                exportAll(properties,zipStream);
                writeFileToZipStreamByMBG(properties.get("atfId")+"/src/main/resources/mapper/","","UTF-8",zipStream);
                writeFileToZipStreamByMBG(properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/entity/","","UTF-8",zipStream);
                writeFileToZipStreamByMBG(properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/mapper/","","UTF-8",zipStream);
                writeFileToZipStreamByMBG(properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/rest/","","UTF-8",zipStream);
                writeFileToZipStreamByMBG(properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/service/","","UTF-8",zipStream);
            }


        } catch (Exception e) {
            e.getStackTrace();
        }finally {
            try {
                if(zipStream!=null){
                    zipStream.flush();
                    zipStream.close();
                }
                out.flush();
                out.close();
            } catch (IOException e) {
            }
        }
    }
    public static String toUpperCaseFirstOne(String s){
        if(Character.isUpperCase(s.charAt(0))){
            return s;}
        else{
            return (new StringBuilder()).append(Character.toUpperCase(s.charAt(0))).append(s.substring(1)).toString();}
    }

  public void exportAll(Properties properties,ZipOutputStream zipStream){
          exportAllByMBG(properties,zipStream,"generator/pomXml.ftl",properties.get("atfId").toString()+"/",properties.get("atfId").toString()+"/","pom.xml");
          exportAllByMBG(properties,zipStream, "generator/log4j2Xml.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","log4j2.xml");
          exportAllByMBG(properties,zipStream,"generator/applicationYml.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","application.yml");
          exportAllByMBG(properties,zipStream,"generator/applicationDevYml.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","application-dev.yml");
          exportAllByMBG(properties,zipStream,"generator/applicationDevYml.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","application-test.yml");
          exportAllByMBG(properties,zipStream,"generator/applicationDevYml.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","application-prod.yml");
          exportAllByMBG(properties,zipStream,"generator/applicationDevYml.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","application-uat.yml");
          exportAllByMBG(properties,zipStream,"generator/testSh.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","start_"+properties.get("atfId")+"_test.sh");
          exportAllByMBG(properties,zipStream,"generator/prodSh.ftl",properties.get("atfId")+"/src/main/resources/",properties.get("atfId")+"/src/main/resources/","start_"+properties.get("atfId")+"_prod.sh");
          exportAllByMBG(properties,zipStream,"generator/application.ftl",properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/",properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/",properties.get("artifactName")+"Application.java");
          exportAllByMBG(properties,zipStream,"generator/swaggerConfig.ftl",properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/config",properties.get("atfId")+"/src/main/java/"+properties.get("groupIdPacakge")+"/"+properties.get("atfId")+"/config","SwaggerConfig.java");
  }


    /**
     * 读取文件
     *
     * @param inputStream
     * @return
     * @throws IOException
     */
    protected String read(InputStream inputStream) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
        StringBuffer stringBuffer = new StringBuffer();
        String line = reader.readLine();
        while (line != null) {
            stringBuffer.append(line).append("\n");
            line = reader.readLine();
        }
        return stringBuffer.toString();
    }


    public void exportAllByMBG(Properties properties, ZipOutputStream zipStream,String templatePath,String targetProject,String targetPackage,String fileName) {

        try{
            URL resourceUrl = null;
            try {
                resourceUrl = ObjectFactory.getResource(templatePath);
            } catch (Exception e) {
                warnings.add("本地加载\"templatePath\" 模板路径失败，尝试 URL 方式获取!");
            }
            if (resourceUrl == null) {
                resourceUrl = new URL(templatePath);
            }
            InputStream inputStream = resourceUrl.openConnection().getInputStream();
            templateContent = read(inputStream);
            inputStream.close();

            GeneratedJavaFile gjf = new GenerateByTemplateFile(null, (TemplateFormatter) Class.forName("tk.mybatis.mapper.generator.formatter.FreemarkerTemplateFormatter").newInstance(), properties, targetProject, targetPackage, fileName, templateContent);
            this.writeGeneratedJavaFileByMBG(gjf,zipStream);

        }catch (IOException e) {
            e.printStackTrace();
            warnings.add("读取模板文件出错: " + e.getMessage());

        }catch (Exception e) {
            e.getStackTrace();
            System.out.println(e.getMessage());
        }
    }



    private void writeGeneratedJavaFileByMBG(GeneratedJavaFile gjf, ZipOutputStream zipStream) throws InterruptedException, IOException {
        String source = gjf.getFormattedContent();
        String fileName = gjf.getTargetProject()+"/"+gjf.getFileName();
        this.writeFileToZipStreamByMBG(fileName,source,gjf.getFileEncoding(), zipStream);

    }

    private void writeFileToZipStreamByMBG(String fileName,String content, String fileEncoding, ZipOutputStream zipStream) throws IOException{
        OutputStreamWriter osw;
        if (fileEncoding == null) {
            osw = new OutputStreamWriter(zipStream);
        } else {
            osw = new OutputStreamWriter(zipStream, fileEncoding);
        }


        ZipEntry zipEntry = new ZipEntry(fileName);
        zipStream.putNextEntry(zipEntry);

        BufferedWriter bw = new BufferedWriter(osw);
        bw.write(content);
        bw.flush();
    }

}
