import java.sql.*;

boolean tryPassword(String username, String password) throws SQLException {
    boolean isCorrect = false;
    String query = "select " + "* from customer " + "where username = ?";
    try(Connection conn = MySQLDataSourceConfig.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)
    ){
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        while(rs.next()){
            if(Objects.equals(rs.getString(6), password)){
                isCorrect = true;
            }
        }
        rs.close();
    } catch(SQLException e){
        System.out.println("FEL med test av löseonord. SQLException: " + e.getMessage());
    }
    return isCorrect;
}

boolean addToCart(int customerId, int orderId, int shoeId) throws SQLException {
    boolean success = false;
    String query = "{call AddToCart(?,?,?)}";
    try(Connection conn = MySQLDataSourceConfig.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query)){
        stmt.setInt(1, customerId);
        stmt.setInt(2, orderId);
        stmt.setInt(3, shoeId);
        stmt.executeUpdate();
        success = true;
    } catch(SQLException e){
        System.out.println("FEL med att lägga till kassan. SQLException: " + e.getMessage());
    }
    return success;
}

void showCategories(){
    String query = "select * from category";
    try(Connection conn = MySQLDataSourceConfig.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery();){
        while(rs.next()){
            System.out.println(rs.getString(2));
        }
    } catch(SQLException e){
        System.out.println("FEL med att se kategories. SQLException: " + e.getMessage());
    }
}

void showShoesInCategory(String categoryId){
    String query = "select * from shoecategory where category_id = ?";
    try(Connection conn = MySQLDataSourceConfig.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery()){
        while(rs.next()){

        }

    }catch (SQLException e) {
        throw new RuntimeException(e);
    }
}

void main() throws SQLException {
    //System.out.println(tryPassword("joasam", "12345"));
    //System.out.println(tryPassword("gw", "bulle1"));
    //System.out.println(addToCart(1, 2, 17));
    //System.out.println(addToCart(4, 5, 15));
    //System.out.println(addToCart(5, 6, 15));
    showCategories();
}
