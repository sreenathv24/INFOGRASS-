package javacode;

import java.util.Arrays;

public class RemoveDuplicates {
    public static void main(String[] args) {
        int[] nums = {4, 2, 7, 2, 8, 4, 1};
        Arrays.sort(nums);
        System.out.println(Arrays.toString(nums));
        System.out.print("Unique numbers: ");
        for (int i = 0; i < nums.length; i++) {
            if (i == 0 || nums[i] != nums[i - 1]) {
                System.out.print(nums[i] + " ");
            }
        }
    }
}