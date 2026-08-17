package javacode.maincode;

import java.util.ArrayList;
import java.util.List;

public class IntersectionofMultipleArrays {

    public List<Integer> intersection(int[][] nums) {

        List<Integer> result = new ArrayList<>();

        // Take first array elements one by one
        for (int i = 0; i < nums[0].length; i++) {
            int current = nums[0][i];
            boolean presentInAll = true;

            // Check if this number exists in all other arrays
            for (int j = 1; j < nums.length; j++) {
                boolean found = false;

                // search current number in nums[j]
                for (int k = 0; k < nums[j].length; k++) {
                    if (nums[j][k] == current) {
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    presentInAll = false;
                    break;
                }
            }

            // Add if present in all arrays
            if (presentInAll) {
                result.add(current);
            }
        }
        return result;
    }

    public static void main(String[] args) {

        IntersectionofMultipleArrays solution = new IntersectionofMultipleArrays();

        int[][] nums1 = {{3, 1, 2, 4, 5}, {1, 2, 3, 4}, {3, 4, 5, 6}};
        System.out.println("Output: " + solution.intersection(nums1));

        int[][] nums2 = {{1, 2, 3}, {4,5,6}};
        System.out.println("Output: " + solution.intersection(nums2));
    }
}
