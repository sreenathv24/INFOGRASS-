package javacode.maincode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ArrayRemoveOddNumbers {
    public static int[] removeOddNumbers(int[] inputArray) {
        List<Integer> evenNumbersList = new ArrayList<>();
        for (int number : inputArray) {
            if (number % 2 == 0) {
                evenNumbersList.add(number);
            }
        }

        int[] outputArray = new int[evenNumbersList.size()];
        for (int i = 0; i < evenNumbersList.size(); i++) {
            outputArray[i] = evenNumbersList.get(i);
        }

        return outputArray;
    }

    public static void main(String[] args) {
        // Example 1
        int[] input1 = {1, 3, 2, 7, 4, 6, 5};
        int[] output1 = removeOddNumbers(input1);
        System.out.println("Input: " + Arrays.toString(input1));
        System.out.println("Output: " + Arrays.toString(output1));
        System.out.println();


        // Example 2
        int[] input2 = {12, 32, 2, 37, 4, 6, 50};
        int[] output2 = removeOddNumbers(input2);
        System.out.println("Input: " + Arrays.toString(input2));
        System.out.println("Output: " + Arrays.toString(output2));
        System.out.println();


        // Example 3
        int[] input3 = {2, 4, 6, 8, 10, 2, 6};
        int[] output3 = removeOddNumbers(input3);
        System.out.println("Input: " + Arrays.toString(input3));
        System.out.println("Output: " + Arrays.toString(output3));
        System.out.println();

    }
}
