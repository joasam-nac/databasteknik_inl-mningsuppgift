import java.util.ArrayList;
import java.util.List;

public class Cart {
    private int cartId;
    private final List<Integer> shoes;
    private boolean active;
    private boolean payed;

    Cart() {
        //this.cartId = createNewCart()
        active = true;
        payed = false;
        shoes = new ArrayList<>();
    }

    public void addShoe(int shoeId){
        //se om id finns
        shoes.add(shoeId);
    }
    public void removeShoe(int shoeId){
        //se om id finns
        shoes.remove(shoeId);
    }

    public void setInactive(){
        active = false;
    }

    public void setActive(){
        active = true;
    }

    public void setPayed(){
        payed = true;
    }
}