package javacode.maincode;

import java.util.ArrayList;
import java.util.List;


public class KeyboardRowSolution {
    public String[] findWords(String[] words) {
        String row1 = "qwertyuiop";
        String row2 = "asdfghjkl";
        String row3 = "zxcvbnm";
        List<String> result = new ArrayList<>();
        for (int i = 0; i < words.length; i++) {
            String word = words[i].toLowerCase();
            char first = word.charAt(0);
            int row = 0;
            if (row1.indexOf(first) != -1) row = 1;
            else if (row2.indexOf(first) != -1) row = 2;
            else row = 3;
            boolean ok = true;
            for (int j = 1; j < word.length(); j++) {
                char ch = word.charAt(j);
                if (row == 1 && row1.indexOf(ch) == -1) {
                    ok = false;
                    break;
                }
                if (row == 2 && row2.indexOf(ch) == -1) {
                    ok = false;
                    break;
                }
                if (row == 3 && row3.indexOf(ch) == -1) {
                    ok = false;
                    break;
                }
            }
            if (ok) result.add(words[i]);
        }
            return result.toArray(new String[0]);
        }

        public static void main (String[]args){
            KeyboardRowSolution s = new KeyboardRowSolution();
            String[] words1 = {"Hello", "Alaska", "Dad", "Peace"};
            String[] ans1 = s.findWords(words1);

            for (String w : ans1)
                System.out.print(w + " ");
            System.out.println();

            String[] words2 = {"qwe", "sad", "zxc", "type"};
            String[] ans2 = s.findWords(words2);

            for (String w : ans2)
                System.out.print(w + " ");

        }
    }

