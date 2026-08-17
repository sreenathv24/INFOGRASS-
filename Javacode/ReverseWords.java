package javacode;

public class ReverseWords {
    public static void main(String[] args) {
        String input = "Java is to learn";
        String[] words = input.split(" ");
        System.out.println("Original: " + input);
        System.out.print("Reversed: ");
        for (int i = words.length - 1; i >= 0; i--) {
            System.out.print(words[i]);
            if (i > 0) {
                System.out.print(" ");
            }
        }
    }
}
