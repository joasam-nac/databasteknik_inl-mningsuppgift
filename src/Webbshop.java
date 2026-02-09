import javax.swing.*;
import java.sql.SQLException;
import java.util.Scanner;

public class Webbshop {
    private static final Scanner sc = new Scanner(System.in);
    private static WebbshopDAO shop = new WebbshopDAO();
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
                    case 3 -> listAllShoes();
                    case 4 -> listAllCategories();
                    case 5 -> listShoesFromCategory();
                    case 6 -> addShoeToCart();
                    case 7 -> checkout();
                    case 8 -> {
                        System.out.println("Tack för att du har handlat hos oss!");
                        return;
                    }
                    default -> System.out.println("Välj mellan 1..8");
                }
            } catch (SQLException e){
                System.out.println("db error: " + e.getMessage());
            }
            System.out.println();
        }
    }

    private static void checkout() {
    }

    private static void addShoeToCart() {

    }

    private static void listShoesFromCategory() {
    }

    private static void listAllCategories() {
    }

    private static void listAllShoes() {
    }

    private static void createCustomer() throws SQLException{
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

        if(shop.createUser(name, user, city, address, pass)) {
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
            System.out.println("7. Slutför köp");
            System.out.println("8. Handlat klart");
        }
    }

    private static void login() throws SQLException {
        System.out.print("Användarnamn: ");
        String u = sc.nextLine();
        System.out.println("Lösenord: ");
        String p = sc.nextLine();

        if (shop.tryLogin(u,p)){
            customerId = shop.getCustomerIdByUsername(u);
        }
    }


}
