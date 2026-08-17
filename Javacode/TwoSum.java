package javacode;

public class TwoSum {
    public static int[] twoSum(int[] nums, int target) {
        for (int i = 0; i < nums.length; i++) {
            for (int j = i + 1; j < nums.length; j++) {
                if (nums[i] + nums[j] == target) {
                    return new int[] { i, j };
                }
            }
        }
        return new int[] {};
    }
    public static void main(String[] args) {
//        int[] nums = {2, 7, 11, 15};
//        int target = 9;

//        int[] nums = {3,2,4};
//        int target = 6;

        int[] nums ={3,6};
        int target = 8;

        int[] result = twoSum(nums, target);

        if (result.length == 2) {
            System.out.println("Target: " + target);
            System.out.println("Output: [" + result[0] + ", " + result[1] + "]");
            System.out.println("Values: " + nums[result[0]] + " + " + nums[result[1]] + " = " + target);
        } else {
            System.out.println("No solution found.");
        }
    }
}