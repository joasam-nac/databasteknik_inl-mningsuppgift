import java.util.List;
import java.util.Optional;
import java.util.Scanner;
import java.util.function.IntConsumer;

public class Webbshop {
    private static final Scanner sc = new Scanner(System.in);
    private static final ShoeDao shop = new HOFWebbshopDAO();
    private static int customerId = -1;

    // Higher-order: menu dispatch table
    private static final IntConsumer[] ACTIONS = new IntConsumer[10];

    static {
        ACTIONS[1] = c -> login();
        ACTIONS[2] = c -> createCustomer();
        ACTIONS[3] = c -> printShoes(shop.getAllShoes());
        ACTIONS[4] = c -> listAllCategories();
        ACTIONS[5] = c -> listShoesFromCategory();
        ACTIONS[6] = c -> requireLogin(Webbshop::addShoeToCart);
        ACTIONS[7] = c -> requireLogin(Webbshop::showCart);
        ACTIONS[8] = c -> requireLogin(Webbshop::checkout);
        ACTIONS[9] = c -> exit();
    }

    static void main() {
        System.out.println("Skobutik");
        while (true) {
            showMenu();
            int choice = getInt();
            dispatch(choice);
            System.out.println();
        }
    }

    // ---------- HOF helpers for UI flow ----------

    @FunctionalInterface
    private interface Action {
        void run();
    }

    private static void dispatch(int choice) {
        IntConsumer action = (choice >= 1 && choice < ACTIONS.length)
                ? ACTIONS[choice]
                : null;

        if (action == null) {
            System.out.println("Välj mellan 1..9");
            return;
        }

        try {
            action.accept(choice);
        } catch (RuntimeException e) {
            // With the updated DAO (no SQLException in interface), DB issues likely
            // come as a runtime DataAccessException. Keep UI robust anyway.
            System.out.println("Fel: " + e.getMessage());
        }
    }

    private static void requireLogin(Action action) {
        if (customerId == -1) {
            System.out.println("Du måste logga in först.");
            return;
        }
        action.run();
    }

    private static void exit() {
        System.out.println("Tack för att du har handlat hos oss!");
        System.exit(0);
    }

    // ---------- UI actions ----------

    private static void printShoes(List<Shoe> shoes) {
        if (shoes.isEmpty()) {
            System.out.println("Inga skor hittades.");
            return;
        }
        shoes.forEach(
                s ->
                        System.out.printf(
                                "%d. %.2f kr, %s %s, %s, storlek: %.1f, lager: %d%n",
                                s.id(),
                                s.price(),
                                s.brandName(),
                                s.name(),
                                s.colour(),
                                s.size(),
                                s.stock()
                        )
        );
    }

    private static void showCart() {
        Optional<ShopItem> maybeCart = shop.getActiveCart(customerId);

        if (maybeCart.isEmpty()) {
            System.out.println("Ingen aktiv order.");
            return;
        }

        ShopItem cart = maybeCart.get();
        if (cart.description().isEmpty()) {
            System.out.println("Kassan är tom.");
            return;
        }

        System.out.println("Antal produkter: " + cart.description().size());
        cart.description().forEach(System.out::println);
    }

    private static void checkout() {
        shop.checkout(customerId);
        System.out.println("Köp slutfört!");
    }

    private static void addShoeToCart() {
        System.out.print("Skriv id på sko: ");
        int shoeId = getInt();
        shop.addToCart(customerId, shoeId);
        showCart();
    }

    private static void listShoesFromCategory() {
        String category = ask("Skriv namn på kategori: ");
        printShoes(shop.getShoesFromCategory(category));
    }

    private static void listAllCategories() {
        shop.getCategories().forEach(cat -> System.out.println(cat.id() + " " + cat.name()));
    }

    private static void createCustomer() {
        String name = ask("Namn: ");
        String user = ask("Användarnamn: ");
        String city = ask("Stad: ");
        String address = ask("Adress: ");
        String pass = ask("Lösenord: ");

        int newCustomerId = shop.createNewUser(name, user, city, address, pass);
        System.out.println("Ny kund registrerad: " + name);
        customerId = newCustomerId;
    }

    private static void login() {
        String u = ask("Användarnamn: ");
        String p = ask("Lösenord: ");

        if (!shop.tryLogin(u, p)) {
            System.out.println("Fel användarnamn eller lösenord.");
            return;
        }

        customerId = shop.findCustomerIdByUsername(u).orElse(-1);
        if (customerId == -1) {
            System.out.println("Inloggad, men kunde inte hitta kund-id.");
            return;
        }

        System.out.println("Inloggad!");
    }

    // ---------- Input helpers ----------

    private static String ask(String prompt) {
        System.out.print(prompt);
        return sc.nextLine();
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
}