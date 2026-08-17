package javacode;

public class TryCatchExample {
	public static void main(String[] args) {
        try {
            // Code that may throw an exception
            int result = divide(5, 2);
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            // Catching specific exception
        	e.printStackTrace();
            System.out.println("Error: Division by zero");
        } 
    }

    public static int divide(int a, int b) {

        return a / b;
    }
}
