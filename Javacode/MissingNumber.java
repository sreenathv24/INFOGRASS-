package javacode;

public class MissingNumber {
    public static void main(String[] args) {
        int[] nums = {3, 0, 1};
        int n = nums.length, expectedSum = n*(n+1)/2,
                actualSum = 0;
        for (int num : nums)
            actualSum += num;
        System.out.println("Missing number: " + (expectedSum - actualSum));
    }
}
