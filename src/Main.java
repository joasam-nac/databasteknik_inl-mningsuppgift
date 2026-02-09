import java.sql.*;

void main() throws SQLException {
    WebbshopDAO ws = new WebbshopDAO();
    ws.getShoesFromCategory("Kängor");
    int i = ws.getActiveCart(1);
    System.out.println(i);
    System.out.println(ws.checkout(1));
    i = ws.getActiveCart(1);
    System.out.println(i);
}
