package javacode;

class AddBinary {
    public static void main(String[] args){
//        String binary1 = "11";
//        String binary2 = "1";
        String binary1 = "1010";
        String binary2 = "1011";
        int num1 = Integer.parseInt(binary1, 2);
        int num2 = Integer.parseInt(binary2, 2);
        int sum = num1 + num2;
        String result = Integer.toBinaryString(sum);

        System.out.println("Binary 1: " + binary1);
        System.out.println("Binary 2: " + binary2);
        System.out.println("Sum: " + result);
    }
}

