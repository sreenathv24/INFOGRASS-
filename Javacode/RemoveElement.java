package javacode;

class RemoveElement {

    public int removeElement(int[] nums, int val) {
        int k = 0;
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != val) {
                nums[k] = nums[i];
                k++;
            }
        }
        return k;
    }
    public static void main(String[] args) {
        RemoveElement obj = new RemoveElement();

        int[] nums = {3, 2, 2, 3};
        int val = 3;
        int result = obj.removeElement(nums, val);

        System.out.println("New length: " + result);
        for (int i = 0; i < result; i++) {
            System.out.print(nums[i] + " ");
        }
    }
}