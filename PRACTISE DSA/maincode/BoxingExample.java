package javacode.maincode;


public class BoxingExample {
    public static void main(String[] args) {
        int a = 10;
        Integer b = a;    // autoboxing: int → Integer

        Integer x = 50;
        int y = x;        // unboxing: Integer → int

        System.out.println(b);
        System.out.println(y);
    }
}

