package javacode.maincode;



public class searchInsert {

    public static void main(String[] args) {

        int[] numbers = {10, 15, 30, 45, 57};
        int target = 45;

        int result = getResult(numbers, target);

        if (result != -1) {
            System.out.println("Element found at index: " + result);
        } else {
            System.out.println("Element not found in the array");
        }
    }

    private static int getResult(int[] numbers, int target) {
        return searchInsert(numbers, target);
    }

    public static int searchInsert(int[] nums, int target) {

        int low = 0;
        int high = nums.length - 1;

        while (low <= high) {
            int mid = (low + high) / 2;

            if (nums[mid] == target) {
                return mid;
            } else if (nums[mid] < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return low; // insert position
    }
}
