import java.sql.SQLException;
import java.util.List;
import java.util.Scanner;

public class Webbshop {
    private static final Scanner sc = new Scanner(System.in);
    private static final WebbshopDAO shop = new WebbshopDAO();
    private static int customerId = -1;

    static void main() {
        System.out.println("Skobutik");
        while (true) {
            showMenu();
            int c = getInt();
            try {
                switch (c) {
                    case 1 -> login();
                    case 2 -> createCustomer();
                    case 3 -> printShoes(shop.getAllShoes());
                    case 4 -> listAllCategories();
                    case 5 -> listShoesFromCategory();
                    case 6 -> addShoeToCart();
                    case 7 -> showCart();
                    case 8 -> checkout();
                    case 9 -> {
                        System.out.println(
                                "Tack för att du har handlat hos oss!"
                        );
                        return;
                    }
                    default -> System.out.println("Välj mellan 1..9");
                }
            } catch (SQLException e) {
                System.out.println("db error: " + e.getMessage());
            }
            System.out.println();
        }
    }

    private static void printShoes(List<Shoe> shoes) {
        if (shoes.isEmpty()) {
            System.out.println("Inga skor hittades.");
            return;
        }
        for (Shoe s : shoes) {
            System.out.printf(
                    "%d. %.2f kr, %s %s, %s, storlek: %.1f, lager: %d%n",
                    s.id(), s.price(), s.brandName(), s.name(),
                    s.colour(), s.size(), s.stock()
            );
        }
    }

    private static void showCart() throws SQLException {
        if (customerId == -1) return;
        ShopItem cart = shop.getActiveCart(customerId);
        if (cart.orderId() == -1) {
            System.out.println("Ingen aktiv order.");
            return;
        }
        if (cart.description().isEmpty()) {
            System.out.println("Kassan är tom.");
            return;
        }
        System.out.println("Antal produkter: " + cart.description().size());
        for(String d : cart.description()){
            System.out.println(d);
        }
    }

    private static void checkout() throws SQLException {
        if (customerId == -1) return;
        if (shop.checkout(customerId)) {
            System.out.println("Köp slutfört!");
        } else {
            System.out.println("Kunde inte slutföra köpet.");
        }
    }

    private static void addShoeToCart() throws SQLException {
        if (customerId == -1) {
            System.out.println("Du måste logga in först.");
            return;
        }
        System.out.print("Skriv id på sko: ");
        int shoeId = getInt();
        shop.addToCart(customerId, shoeId);
        showCart();
    }

    private static void listShoesFromCategory() throws SQLException {
        System.out.print("Skriv namn på kategori: ");
        String category = sc.nextLine();
        printShoes(shop.getShoesFromCategory(category));
    }

    private static void listAllCategories() throws SQLException {
        for (Category cat : shop.getCategories()) {
            System.out.println(cat.id() + " " + cat.name());
        }
    }

    private static void createCustomer() throws SQLException {
        System.out.print("Namn: ");
        String name = sc.nextLine();
        System.out.print("Användarnamn: ");
        String user = sc.nextLine();
        System.out.print("Stad: ");
        String city = sc.nextLine();
        System.out.print("Adress: ");
        String address = sc.nextLine();
        System.out.print("Lösenord: ");
        String pass = sc.nextLine();

        if (shop.createNewUser(name, user, city, address, pass)) {
            System.out.println("Ny kund registrerad: " + name);
            customerId = shop.getCustomerIdByUsername(user);
        } else {
            System.out.println("Fel vid skapande av kontot");
        }
    }

    private static int getInt() {
        while (!sc.hasNextInt()) {
            System.out.print("Skriv ett tal: ");
            sc.next();
        }
        int res = sc.nextInt();
        sc.nextLine();
        return res;
    }

    private static void showMenu() {
        if (customerId == -1) {
            System.out.println("1. Logga in");
            System.out.println("2. Skapa användare");
        }
        System.out.println("3. Visa alla skor");
        System.out.println("4. Visa alla kategorier");
        System.out.println("5. Visa skor från en kategori");
        if (customerId > 0) {
            System.out.println("6. Lägg en sko i kassan");
            System.out.println("7. Visa kassan");
            System.out.println("8. Slutför köp");
            System.out.println("9. Handlat klart");
        }
    }

    private static void login() throws SQLException {
        System.out.print("Användarnamn: ");
        String u = sc.nextLine();
        System.out.print("Lösenord: ");
        String p = sc.nextLine();

        if (shop.tryLogin(u, p)) {
            customerId = shop.getCustomerIdByUsername(u);
            System.out.println("Inloggad!");
        } else {
            System.out.println("Fel användarnamn eller lösenord.");
        }
    }
}