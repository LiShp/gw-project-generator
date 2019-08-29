package tk.mybatis.mapper.generator.dbconfig;

import org.springframework.stereotype.Component;

import java.io.Serializable;

@Component
public class DbConfig implements Serializable {

    private String url = "jdbc:mysql://127.0.0.1:3306/test_demo";
    private String username = "root";
    private String password = "root";

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
