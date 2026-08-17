package javacode;

import java.util.Arrays;

public class Backtracking {

	public static void backTrack(int[] arr, boolean[] used, int index) {
		if (index == arr.length) {
			System.out.println(Arrays.toString(arr));
		}

		for (int i = 0; i < arr.length; i++) {
			if (!used[i]) {
				used[i] = true;
				arr[index] =i;
				backTrack(arr, used, index + 1);
				used[i] = false;
			}
		}
	}

	public static void main(String[] args) {
		int[] arr = {1, 2, 3};
		boolean[] used = new boolean[arr.length];
		backTrack(arr, used, 0);
	}
}
