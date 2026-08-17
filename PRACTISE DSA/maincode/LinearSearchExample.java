package javacode.maincode;

public class LinearSearchExample {

    public static int linearSearch(int[] arr, int target) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == target) {
                return i;
            }
        }
        return -1;  // Element not found
    }

    public static void main(String[] args) {

        int[] numbers = {10, 15, 30, 45, 57};
        int target = 45;

        int result = linearSearch(numbers, target);

        if (result != -1) {
            System.out.println("Element found at index: " + result);
        } else {
            System.out.println("Element not found in the array");
        }
    }
}
