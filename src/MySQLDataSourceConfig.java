import com.mysql.cj.jdbc.MysqlDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class MySQLDataSourceConfig {
    private static MysqlDataSource ds;

    public static void init() throws SQLException {
        ds = new MysqlDataSource();
        ds.setURL("jdbc:mysql://localhost:3306/webbshop_db");
        ds.setUser("dev");
        ds.setPassword("DifficultPassword");
        ds.setUseSSL(false);
        ds.setServerTimezone("UTC");
    }

    public static Connection getConnection() throws SQLException {
        if (ds == null) {
            init();
        }
        return ds.getConnection();
    }
}
