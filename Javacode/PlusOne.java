package javacode;

public class PlusOne {
    public static void main(String[] args) {
            int[] digits = {1, 2, 3};
            int carry = 1;
            for (int i = digits.length - 1; i >= 0; i--)
                if (carry == 1) {
                    digits[i] = digits[i] + 1;
                if (digits[i] == 10) digits[i] = 0;
                else carry = 0;
            }
            if (carry == 1) {
                digits = new int[digits.length + 1];
                digits[0] = 1;
            }
            System.out.println(java.util.Arrays.toString(digits));
        }
    }
