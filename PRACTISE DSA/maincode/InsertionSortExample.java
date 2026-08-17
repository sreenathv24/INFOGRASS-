package javacode.maincode;

public class InsertionSortExample {
    static void insertionSort(int[] arr) {
        int n = arr.length;
        for (int i = 1; i < n; i++) {
            int key = arr[i];
            int j = i - 1;
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }
    public static void main(String[] args) {
        int[] arr = {9, 5, 1, 4, 3};
        System.out.println("Before Sorting:");
        for (int num : arr)
            System.out.print(num + " ");
        insertionSort(arr);
        System.out.println("\nAfter Sorting:");
        for (int num : arr)
            System.out.print(num + " ");
    }
    }

