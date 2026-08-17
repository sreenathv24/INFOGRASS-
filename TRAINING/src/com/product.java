package ForEach;

import java.util.*;

public class ProductList {
    public static void main(String[] args) {
        List<String> products = Arrays.asList("Laptop", "Mobile", "Tablet");
        products.forEach(p -> System.out.println("Product: " + p));
    }
}

