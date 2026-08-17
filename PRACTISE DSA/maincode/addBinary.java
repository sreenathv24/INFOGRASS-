package javacode.maincode;
import java.util.Scanner;

public class addBinary {

    public static String addBinary(String a, String b) {
        int i = a.length() - 1;
        int j = b.length() - 1;
        int carry = 0;
        String result = "";
        while (i >= 0 || j >= 0 || carry != 0) {
            int sum = carry;
            if (i >= 0) {
                sum += a.charAt(i) - '0';
                i--;
            }
            if (j >= 0) {
                sum += b.charAt(j) - '0';
                j--;
            }
            result = sum % 2 + result;
            carry = sum / 2;
        }
        return result;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter first binary number: ");
        String a = sc.nextLine().trim();
        System.out.print("Enter second binary number: ");
        String b = sc.nextLine().trim();
        String result = addBinary(a, b);
        System.out.println("Result: " + result);
        sc.close();
    }
}
