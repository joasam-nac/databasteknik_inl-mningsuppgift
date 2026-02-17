import java.util.List;
import java.util.Optional;

public interface ShoeDao {
    Optional<Integer> findCustomerIdByUsername(String username);
    boolean tryLogin(String username, String password);
    int createNewUser(
            String name,
            String username,
            String city,
            String address,
            String password
    ); // return new customerId (or throw if failed)

    List<Category> getCategories();
    List<Shoe> getAllShoes();
    List<Shoe> getShoesFromCategory(String category);

    void addToCart(int customerId, int shoeId);
    int getCartItemCount(int orderId);
    List<Shoe> getShoesInCart(int orderId);

    Optional<ShopItem> getActiveCart(int customerId);
    void checkout(int customerId);
}