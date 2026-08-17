package javacode;

class MergeSortedArrays {
    public static void main(String[] args) {

        int[] a = {1, 2, 4};
        int[] b = {1, 3, 4};

        int[] result = new int[a.length + b.length];

        int i = 0, j = 0, k = 0;
        while (i < a.length && j < b.length) {
            if (a[i] <= b[j]) {
                result[k] = a[i];
                i++;
            } else {
                result[k] = b[j];
                j++;
            }
            k++;
        }
        while (i < a.length) {
            result[k] = a[i];
            i++;
            k++;
        }
        while (j < b.length) {
            result[k] = b[j];
            j++;
            k++;
        }
        System.out.print("Merged Array: ");
        for (int num : result) {
            System.out.print(num + " ");
        }
    }
}