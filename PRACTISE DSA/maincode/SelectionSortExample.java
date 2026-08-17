package javacode.maincode;

public class SelectionSortExample {
        public static void main(String[] args) {
            int[] arr = {64, 25, 12, 22, 11};
            for (int i = 0; i < arr.length - 1; i++) {
                int minIndex = i;
                for (int j = i + 1; j < arr.length; j++) {
                    if (arr[j] < arr[minIndex]) {
                        minIndex = j;
                    }
                }
                int temp = arr[minIndex];
                arr[minIndex] = arr[i];
                arr[i] = temp;
            }
            for (int n : arr) {
                System.out.print(n + " ");
            }
        }
    }

