import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class Webbshop implements ShoeDao{
    @Override
    public int getCustomerIdByUsername(String username) throws SQLException {
        String query = "select id from customer where username = ?";

        try(Connection conn = MySQLDataSourceConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){

            stmt.setString(1, username);

            try(ResultSet rs = stmt.executeQuery()){
                if (!rs.next()){
                    System.out.println("Username " + username + " does not exist");
                    return -1;
                }
                return rs.getInt("id");
            }
        } catch (SQLException e){
            System.out.println("Error in retrieving customer_id via username: " + e.getMessage());
            return -1;
        }
    }

    @Override
    public boolean tryLogin(String username, String password) throws SQLException {
        return false;
    }

    @Override
    public List<String> getCategories() throws SQLException {
        return List.of();
    }

    @Override
    public List<String> listAllShoes() throws SQLException {
        return List.of();
    }

    @Override
    public List<String> getShoesFromCategory(String category) throws SQLException {
        return List.of();
    }

    @Override
    public void addToCart(int customerId, int shoeId) throws SQLException {

    }

    @Override
    public List<String> getActiveCart(int customerId) throws SQLException {
        return List.of();
    }

    @Override
    public boolean checkout(int customerId) throws SQLException {
        return false;
    }
}
