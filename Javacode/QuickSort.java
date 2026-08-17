package javacode;

public class QuickSort {

	public static void main(String[] args) {
		int[] arr = {5, 3, 2, 1, 4};
		quickSort(arr, 0, arr.length - 1);
		for (int i = 0; i < arr.length; i++) {
			System.out.print(arr[i]+" ");
		}
	}

	public static void quickSort(int[] arr, int low, int high) {
		if (low < high) {
			int pivot = arr[high];
			int i = low - 1;
			for (int j = low; j < high; j++) {
				if (arr[j] <= pivot) {
					i++;
					int temp = arr[i];
					arr[i] = arr[j];
					arr[j] = temp;
				}
			}
			int temp = arr[i + 1];
			arr[i + 1] = arr[high];
			arr[high] = temp;
			quickSort(arr, low, i);
			quickSort(arr, i + 2, high);
		}
	}
}

