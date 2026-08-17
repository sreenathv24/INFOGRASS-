package javacode;
//2798 leetcode
class Solution {
    public static void main(String[] args) {
//        int[] hours = {0, 1, 2, 3, 4};
//        int target = 2;

        int[] hours = {5,1,4,2,2};
        int target =6;
        int result = numberOfEmployeesWhoMetTarget(hours, target);
        System.out.println("Employees who met the target: " + result);
    }
    public static int numberOfEmployeesWhoMetTarget(int[] hours, int target) {
        int count = 0;
        for (int i = 0; i < hours.length; i++) {
            if (hours[i] >= target) {
                count++;
            }
        }
        return count;
    }
}