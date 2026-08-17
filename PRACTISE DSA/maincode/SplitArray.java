package javacode.maincode;

public class SplitArray {
    public boolean isPossibleToSplit(int[] nums) {
        final int MAX_VAL = 1001;
        int[] count = new int[MAX_VAL];

        for (int num : nums) {
            count[num]++;

            // If any number appears more than 2 times -> not possible to split
            if (count[num] > 2) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        SplitArray solution = new SplitArray();

        int[] nums1 = {1, 2, 3, 4};
        System.out.println("Test 1: {1,2,3,4}  → " + solution.isPossibleToSplit(nums1));

        int[] nums2 = {1, 1, 2, 2};
        System.out.println("Test 2: {1,1,2,2} → " + solution.isPossibleToSplit(nums2));

        int[] nums3 = {1, 1, 1, 2};
        System.out.println("Test 3: {1,1,1,2} → " + solution.isPossibleToSplit(nums3));

        int[] nums4 = {5, 5, 8, 8, 9, 9};
        System.out.println("Test 4: {5,5,8,8,9,9} → " + solution.isPossibleToSplit(nums4));
    }
}

