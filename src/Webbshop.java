import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

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
        String query = "select password from customer where username = ?";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setString(1, username);
            try(ResultSet rs = stmt.executeQuery()){
                if (!rs.next()){
                    System.out.println("Unknown username");
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
    public List<Category> getCategories() throws SQLException {
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
    public String getBrandFromId(int brandId) throws SQLException {
        String query = "select name from brand where id = ?";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setInt(1, brandId);
            try(ResultSet rs = stmt.executeQuery()){
                if(rs.next()){
                    return rs.getString("name");
                }
            }
        } catch (SQLException e) {
            System.out.println("Eroor while retrieving brand name from id: " + e.getMessage());
        }
        return null;
    }

    @Override
    public void listAllShoes() throws SQLException {
        String query = "select * from shoe";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)){
            try(ResultSet rs = stmt.executeQuery()){
                while(rs.next()){
                    System.out.printf(
                            "%d. %.2f kr, %s %s, storlek: %d, lager: %d%n",
                            rs.getInt("id"),
                            rs.getDouble("price"),
                            getBrandFromId(rs.getInt("brand_id")),
                            rs.getString("name"),
                            rs.getInt("size"),
                            rs.getInt("stock")
                    );
                }
            }
        } catch (SQLException e){
            System.out.println("Error while retrieving all shoes from db: " + e.getMessage());
        }
    }



    @Override
    public void getShoesFromCategory(String category) throws SQLException {
        String query = "select * from shoe s " +
                "join shoecategory sc on sc.shoe_id = s.id " +
                "join category c on c.id = sc.category_id " +
                "where c.name = ?";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)){
            stmt.setString(1, category);
            try(ResultSet rs = stmt.executeQuery()){
                while(rs.next()){
                    System.out.printf(
                            "%d. %.2f kr, %s %s, storlek: %d, lager: %d%n",
                            rs.getInt("id"),
                            rs.getDouble("price"),
                            getBrandFromId(rs.getInt("brand_id")),
                            rs.getString("name"),
                            rs.getInt("size"),
                            rs.getInt("stock")
                    );
                }
            }
        } catch (SQLException e){
            System.out.println("Error while retrieving all shoes from db: " + e.getMessage());
        }
    }

    @Override
    public void addToCart(int customerId, int shoeId) throws SQLException {
        String query = "{call addtocart(?, ?)}";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareCall(query)){
            stmt.setInt(1, customerId);
            stmt.setInt(2, shoeId);
            stmt.executeQuery();
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    @Override
    public int getActiveCart(int customerId) throws SQLException {
        String query = "{call getactivecart(?)}";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareCall(query)){
            stmt.setInt(1, customerId);
            try(ResultSet rs = stmt.executeQuery()){
                if(rs.next()){
                    return rs.getInt("order_id");
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return -1;
    }

    @Override
    public boolean checkout(int customerId) throws SQLException {
        String query = "{call checkout(?)}";
        try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareCall(query)){
            stmt.setInt(1, customerId);
            try(ResultSet rs = stmt.executeQuery()){
                return true;
            }
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
        return false;
    }
}
