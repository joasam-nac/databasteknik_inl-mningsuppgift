import java.sql.SQLException;
import java.util.List;

public interface ShoeDao {

    int getCustomerIdByUsername(String username) throws SQLException;
    boolean tryLogin(String username, String password) throws SQLException;

    List<String> getCategories() throws SQLException;
    List<String> listAllShoes() throws SQLException;
    List<String> getShoesFromCategory(String category) throws SQLException;

    void addToCart(int customerId, int shoeId) throws SQLException;
    List<String> getActiveCart(int customerId) throws SQLException;
    boolean checkout(int customerId) throws SQLException;
}
