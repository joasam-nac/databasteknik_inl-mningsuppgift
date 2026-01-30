public class Customer {
    private String name;
    private String userName;
    private String password;
    private String customerId;
    private Cart activeCart;

    Customer(String name, String userName, String password) {
        this.name = name;
        this.userName = userName;
        this.password = password;
        //customerId = getNewCustomerId();

    }
}