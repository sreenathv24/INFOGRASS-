package javacode.maincode;

import java.util.*;

public class MinimumIndexSumOfTwoLists {
    public String[] findRestaurant(String[] list1, String[] list2) {
        int minSum = -1;
        List<String> result = new ArrayList<>();
        for (int i = 0; i < list1.length; i++) {
            for (int j = 0; j < list2.length; j++) {
                if (list1[i].equals(list2[j])) {
                    int sum = i + j;
                    if (minSum == -1) {
                        minSum = sum;
                        result.add(list1[i]);
                    }
                    else if (sum < minSum) {
                        minSum = sum;
                        result.clear();
                        result.add(list1[i]);
                    }
                    else if (sum == minSum) {
                        result.add(list1[i]);
                    }
                }
            }
        }
        return result.toArray(new String[0]);
    }
    public static void main(String[] args) {
        MinimumIndexSumOfTwoLists obj = new MinimumIndexSumOfTwoLists();
        String[] list1 = {"Shogun", "Tapioca", "Burger King", "KFC"};
        String[] list2 = {"Piatti","The Grill at Torrey Pines","Hungry Hunter Steakhouse","Shogun"};

//        String[] list1 = {"happy","sad","good"};
//        String[] list2 = {"sad","happy","good"};

        String[] res = obj.findRestaurant(list1, list2);
        for(int i = 0; i < res.length; i++) {
            System.out.println(res[i]);
        }
    }
}
