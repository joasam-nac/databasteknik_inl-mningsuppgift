import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

public class HOFWebbshopDAO implements ShoeDao {

    // ---------- Public DAO API (no SQLException leaked) ----------

    // New: no-op binder to avoid "stmt is never used" on statements with no params
    private static void noop(PreparedStatement stmt) {
        // intentionally empty
    }

    @Override
    public Optional<Integer> findCustomerIdByUsername(String username) {
        String sql = "select id from customer where username = ?";

        return safe(() -> inConnection(conn -> queryOne(conn, sql, stmt -> stmt.setString(1, username), rs -> rs.next() ? Optional.of(rs.getInt("id")) : Optional.empty())));
    }

    @Override
    public boolean tryLogin(String username, String password) {
        String sql = "select password from customer where username = ?";

        return safe(() -> inConnection(conn -> queryOne(conn, sql, stmt -> stmt.setString(1, username), rs -> {
            if (!rs.next()) return false;
            return Objects.equals(rs.getString("password"), password);
        })), false);
    }

    @Override
    public int createNewUser(String name, String username, String city, String address, String password) {
        String sql = "{call createuser(?, ?, ?, ?, ?)}";

        return safe(() -> inConnection(conn -> callOne(conn, sql, stmt -> {
            stmt.setString(1, name);
            stmt.setString(2, username);
            stmt.setString(3, city);
            stmt.setString(4, address);
            stmt.setString(5, password);
        }, rs -> {
            if (!rs.next()) {
                throw new DataAccessException("createuser returned no rows");
            }
            int id = rs.getInt("customer_id");
            if (id <= 0) {
                throw new DataAccessException("createuser failed, customer_id=" + id);
            }
            return id;
        })));
    }

    @Override
    public List<Category> getCategories() {
        String sql = "select * from category";

        return safe(() -> inConnection(conn -> queryOne(conn, sql, HOFWebbshopDAO::noop, // stmt is "used"
                rs -> readAll(rs, this::mapCategory))), List.of());
    }

    @Override
    public List<Shoe> getAllShoes() {
        String sql = "select s.id, s.price, b.name as brand_name, s.name, " + "s.size, s.colour, s.stock " + "from shoe s join brand b on b.id = s.brand_id";

        return safe(() -> inConnection(conn -> queryOne(conn, sql, HOFWebbshopDAO::noop, // stmt is "used"
                rs -> readAll(rs, this::mapShoe))), List.of());
    }

    @Override
    public List<Shoe> getShoesFromCategory(String category) {
        String sql = "select s.id, s.price, b.name as brand_name, s.name, " + "s.size, s.colour, s.stock " + "from shoe s " + "join brand b on b.id = s.brand_id " + "join shoecategory sc on sc.shoe_id = s.id " + "join category c on c.id = sc.category_id " + "where c.name = ?";

        return safe(() -> inConnection(conn -> queryOne(conn, sql, stmt -> stmt.setString(1, category), rs -> readAll(rs, this::mapShoe))), List.of());
    }

    @Override
    public void addToCart(int customerId, int shoeId) {
        String sql = "{call addtocart(?, ?)}";

        safe(() -> inConnection(conn -> {
            callVoid(conn, sql, stmt -> {
                stmt.setInt(1, customerId);
                stmt.setInt(2, shoeId);
            });
            return null;
        }));
    }

    @Override
    public int getCartItemCount(int orderId) {
        String sql = "select count(*) as c from orderitem where order_id = ?";

        return safe(() -> inConnection(conn -> queryOne(conn, sql, stmt -> stmt.setInt(1, orderId), rs -> rs.next() ? rs.getInt("c") : 0)), 0);
    }

    @Override
    public List<Shoe> getShoesInCart(int orderId) {
        String sql = "select s.id, s.price, b.name as brand_name, s.name, s.size, s.colour, s.stock " + "from shoe s " + "join brand b on b.id = s.brand_id " + "join orderitem oi on oi.shoe_id = s.id " + "where oi.order_id = ?";

        return safe(() -> inConnection(conn -> queryOne(conn, sql, stmt -> stmt.setInt(1, orderId), rs -> readAll(rs, this::mapShoe))), List.of());
    }

    @Override
    public Optional<ShopItem> getActiveCart(int customerId) {
        String sql = "{call getactivecart(?)}";

        return safe(() -> inConnection(conn -> callOne(conn, sql, stmt -> stmt.setInt(1, customerId), rs -> {
            int orderId = -1;
            List<String> description = new ArrayList<>();
            boolean anyRow = false;

            while (rs.next()) {
                anyRow = true;
                orderId = rs.getInt("order_id");

                // Fix: don't declare shoeId if you only
                // used it to check wasNull()
                rs.getInt("shoe_id");
                if (rs.wasNull()) continue;

                description.add(String.format("%s %s, %s, storlek: %.1f, %.2f kr, antal: %d", rs.getString("brand_name"), rs.getString("shoe_name"), rs.getString("colour"), rs.getDouble("size"), rs.getDouble("price"), rs.getInt("quantity")));
            }

            if (!anyRow || orderId <= 0) {
                return Optional.empty();
            }
            return Optional.of(new ShopItem(orderId, description));
        })));
    }

    // ---------- HOF helpers (implementation detail) ----------

    @Override
    public void checkout(int customerId) {
        String sql = "{call checkout(?)}";

        safe(() -> inConnection(conn -> {
            callVoid(conn, sql, stmt -> stmt.setInt(1, customerId));
            return null;
        }));
    }

    private <R> R inConnection(SqlFunction<Connection, R> work) throws SQLException {
        try (Connection conn = MySQLDataSourceConfig.getConnection()) {
            return work.apply(conn);
        }
    }

    private <R> R queryOne(Connection conn, String sql, SqlConsumer<PreparedStatement> binder, SqlFunction<ResultSet, R> reader) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            binder.accept(stmt);
            try (ResultSet rs = stmt.executeQuery()) {
                return reader.apply(rs);
            }
        }
    }

    private <R> R callOne(Connection conn, String sql, SqlConsumer<CallableStatement> binder, SqlFunction<ResultSet, R> reader) throws SQLException {
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            binder.accept(stmt);
            try (ResultSet rs = stmt.executeQuery()) {
                return reader.apply(rs);
            }
        }
    }

    // New: for stored procedures that don't return a ResultSet
    private void callVoid(Connection conn, String sql, SqlConsumer<CallableStatement> binder) throws SQLException {
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            binder.accept(stmt);
            stmt.execute();
        }
    }

    private <T> List<T> readAll(ResultSet rs, SqlFunction<ResultSet, T> mapper) throws SQLException {
        List<T> out = new ArrayList<>();
        while (rs.next()) {
            out.add(mapper.apply(rs));
        }
        return out;
    }

    private Shoe mapShoe(ResultSet rs) throws SQLException {
        return new Shoe(rs.getInt("id"), rs.getDouble("price"), rs.getString("brand_name"), rs.getString("name"), rs.getInt("size"), rs.getString("colour"), rs.getInt("stock"));
    }

    private Category mapCategory(ResultSet rs) throws SQLException {
        return new Category(rs.getInt("id"), rs.getString("name"));
    }

    private <R> R safe(SqlSupplier<R> work) {
        try {
            return work.get();
        } catch (SQLException e) {
            throw new DataAccessException("Database error", e);
        }
    }

    // ---------- Mapping (“object model”) ----------

    private <R> R safe(SqlSupplier<R> work, R fallback) {
        try {
            return work.get();
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            return fallback;
        }
    }

    @FunctionalInterface
    private interface SqlFunction<T, R> {
        R apply(T t) throws SQLException;
    }

    // ---------- Exception strategy (don’t leak SQLException) ----------

    @FunctionalInterface
    private interface SqlConsumer<T> {
        void accept(T t) throws SQLException;
    }

    @FunctionalInterface
    private interface SqlSupplier<R> {
        R get() throws SQLException;
    }

    public static class DataAccessException extends RuntimeException {
        public DataAccessException(String message) {
            super(message);
        }

        public DataAccessException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}