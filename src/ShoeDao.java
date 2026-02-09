import java.sql.SQLException;
import java.util.List;

public interface ShoeDao {

    int getCustomerIdByUsername(String username) throws SQLException;
    boolean tryLogin(String username, String password) throws SQLException;
    boolean createUser(String name, String username, String city, String address, String password) throws SQLException;

    List<Category> getCategories() throws SQLException;
    void listAllShoes() throws SQLException;
    void getShoesFromCategory(String category) throws SQLException;
    String getBrandFromId(int brandId) throws SQLException;

    void addToCart(int customerId, int shoeId) throws SQLException;
    int getActiveCart(int customerId) throws SQLException;
    boolean checkout(int customerId) throws SQLException;
}
