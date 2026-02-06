import java.sql.*;

boolean tryPassword(String username, String password) throws SQLException {
    String query = "select password from customer " + "where username = ?";
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

public void addToCart(int customerId, int shoeId) {
    String sql = "{CALL AddToCart(?, ?)}";

    try (Connection conn = MySQLDataSourceConfig.getConnection();
         CallableStatement stmt = conn.prepareCall(sql)) {

        stmt.setInt(1, customerId);
        stmt.setInt(2, shoeId);
        stmt.execute();

        System.out.println("Shoe was added.");

    } catch (SQLException e) {
        if ("45000".equals(e.getSQLState())) {
            String msg = e.getMessage();
            if(msg.contains("does not exist")) {
                if(msg.contains("Customer")){
                    System.out.println("Make sure the correct customer id is proved");
                }
                else{
                    System.out.println("Make sure the correct shoe id is provided");
                }
            } else if (msg.contains("stock")) {
                System.out.println("Shoe is out of stock");
            }

        } else {
            System.out.println("Database error:" + e.getMessage());
        }

    }
}

void showCategories(){
    String query = "select * from category";
    try(Connection conn = MySQLDataSourceConfig.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery()){
        while(rs.next()){
            System.out.println(rs.getString(2));
        }
    } catch(SQLException e){
        System.out.println("FEL med att se kategories. SQLException: " + e.getMessage());
    }
}

void getAllCustomersAndTheirData(){
    String query = "select * from customer";
    int count = 0;
    double val = 0;
    try(Connection conn = MySQLDataSourceConfig.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery()){
        while(rs.next()){
            count++;
            System.out.println(rs.getString(2) + " " + rs.getString(3) + " " + rs.getString(4));
            val += getMoneySpentFromCustomer(rs.getString(1));
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    System.out.println(count + " antal kunder.");
    System.out.println(val/count + " kr medelvärde spenderat.");
}

double getMoneySpentFromCustomer(String customerId){
    String query = "select * from customerdata where customer_id = ?";
    try(Connection conn = MySQLDataSourceConfig.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query)){
        stmt.setString(1, customerId);
        ResultSet rs = stmt.executeQuery();
        while(rs.next()){
            return rs.getDouble(4);
        }
    } catch (Exception e) {
        throw new RuntimeException(e);
    }

    return 0;
}

int getIdFromUsername(String username) throws SQLException {
    String query = "select id from customer where username = ?";
    try(Connection conn = MySQLDataSourceConfig.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query)){
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()){
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    return 0;
}

void main() throws SQLException {

}
