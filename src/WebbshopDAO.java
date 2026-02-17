/*import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class WebbshopDAO implements ShoeDao{
    @Override
    public int getCustomerIdByUsername(String username) {
        String query = "select id from customer where username = ?";

        try(Connection conn = MySQLDataSourceConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){

            stmt.setString(1, username);

            try(ResultSet rs = stmt.executeQuery()){
                if (!rs.next()){
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
    public boolean tryLogin(String username, String password) {
        String query = "select password from customer where username = ?";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setString(1, username);
            try(ResultSet rs = stmt.executeQuery()){
                if (!rs.next()){
                    return false;
                }
                String correctPassword = rs.getString("password");
                return Objects.equals(correctPassword, password);
            }
        } catch(SQLException e){
            System.out.println("Error while trying password. SQLException: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean createNewUser(String name, String username, String city, String address, String password) {
        String query = "{call createuser(?, ?, ?, ?, ?)}";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        CallableStatement stmt = conn.prepareCall(query)){
            stmt.setString(1, name);
            stmt.setString(2, username);
            stmt.setString(3, city);
            stmt.setString(4, address);
            stmt.setString(5, password);
            try(ResultSet rs = stmt.executeQuery()){
                if (rs.next()) {
                    if(rs.getInt(("customer_id")) > 0){
                        return true;
                    }
                }
                return false;
            }
        } catch (SQLException e){
            System.out.println("Error while trying to create a new user: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<Category> getCategories() {
        String query = "select * from category";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)){
            try(ResultSet rs = stmt.executeQuery()){
                List<Category> categories = new ArrayList<>();
                while(rs.next()){
                    Category c = new Category(rs.getInt("id"), rs.getString("name"));
                    categories.add(c);
                }
                return categories;
            }
        } catch (SQLException e){
            System.out.println("Error while retrieving all the categories: " + e.getMessage());
        }
        return List.of();
    }

    @Override
    public List<Shoe> getAllShoes() {
        String query = "select s.id, s.price, b.name as brand_name, s.name, "
                + "s.size, s.colour, s.stock "
                + "from shoe s join brand b on b.id = s.brand_id";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery()){
            List<Shoe> shoes = new ArrayList<>();
            while (rs.next()){
                shoes.add(ResultSetToShoe(rs));
            }
            return shoes;
        } catch (SQLException e) {
            System.out.println("Error while retrieving all shoes: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<Shoe> getShoesFromCategory(String category) {
        String query = "select s.id, s.price, b.name as brand_name, s.name, "
                + "s.size, s.colour, s.stock "
                + "from shoe s join brand b on b.id = s.brand_id" + " join shoecategory sc on sc.shoe_id = s.id"
                + " join category c on c.id = sc.category_id where c.name = ?";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setString(1, category);
            try(ResultSet rs = stmt.executeQuery()){
                List<Shoe> shoes = new ArrayList<>();
                while(rs.next()){
                    shoes.add(ResultSetToShoe(rs));
                }
                return shoes;
            }
        } catch (SQLException e){
            System.out.println("Error while retrieving all shoes from db: " + e.getMessage());
        }
        return List.of();
    }

    @Override
    public void addToCart(int customerId, int shoeId) {
        String query = "{call addtocart(?, ?)}";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        CallableStatement stmt = conn.prepareCall(query)){
            stmt.setInt(1, customerId);
            stmt.setInt(2, shoeId);
            stmt.executeQuery();
        } catch (SQLException e){
            System.out.println(e.getMessage());

        }
    }

    @Override
    public int getCartItemCount(int orderId) throws SQLException {
        String query = "select count(*) as c from orderitem where order_id = ?";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setInt(1, orderId);
            try(ResultSet rs = stmt.executeQuery()) {
                if(rs.next()){
                    return rs.getInt("c");
                }
                return 0;
            }
        }
    }

    @Override
    public List<Shoe> getShoesInCart(int orderId) throws SQLException {
        String query = "SELECT s.id, s.price, b.name AS brand_name, s.name, s.size, s.stock "
                + "FROM shoe s JOIN brand b ON b.id = s.brand_id" + " join orderitem oi on oi.shoe_id = s.id" +
                " where oi.order_id = ?";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setInt(1, orderId);
            try(ResultSet rs = stmt.executeQuery()){
                List<Shoe> shoes = new ArrayList<>();
                while(rs.next()){
                    shoes.add(ResultSetToShoe(rs));
                }
                return shoes;
            }
        }
    }

    @Override
    public ShopItem getActiveCart(int customerId) throws SQLException {
        String query = "{call getactivecart(?)}";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        CallableStatement stmt = conn.prepareCall(query)){
            stmt.setInt(1, customerId);
            try(ResultSet rs = stmt.executeQuery()){
                int orderId = -1;
                List<String> description = new ArrayList<>();

                while (rs.next()) {
                    orderId = rs.getInt("order_id");
                    int shoeId = rs.getInt("shoe_id");
                    if (rs.wasNull()) continue;

                    description.add(String.format(
                            "%s %s, %s, storlek: %.1f, %.2f kr, antal: %d",
                            rs.getString("brand_name"),
                            rs.getString("shoe_name"),
                            rs.getString("colour"),
                            rs.getDouble("size"),
                            rs.getDouble("price"),
                            rs.getInt("quantity")
                    ));
                }
                return new ShopItem(orderId, description);

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return null;
    }

    @Override
    public boolean checkout(int customerId) {
        String query = "{call checkout(?)}";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareCall(query)){
            stmt.setInt(1, customerId);
            stmt.execute();
            return true;
        } catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }
    }

    private Shoe ResultSetToShoe(ResultSet rs) throws SQLException {
        return new Shoe(
                rs.getInt("id"),
                rs.getDouble("price"),
                rs.getString("brand_name"),
                rs.getString("name"),
                rs.getInt("size"),
                rs.getString("colour"),
                rs.getInt("stock")
        );
    }
}*/
