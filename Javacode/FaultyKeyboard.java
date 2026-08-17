package javacode;

class FaultyKeyboard {
    public static void main(String[] args) {
        String input = "poiinter";
        String result = finalString(input);
        System.out.println("Input: " + input);
        System.out.println("Output: " + result);
    }

    public static String finalString(String s) {
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            if (c == 'i') {
                sb.reverse();
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }
}