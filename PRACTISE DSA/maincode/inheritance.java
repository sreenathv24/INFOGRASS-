package javacode.maincode;

 class dad {
     int money = 2000;
}
class son extends dad{
}
public class inheritance {
     public static void main(String[] args) {
         son s1 = new son();
         System.out.println(s1.money);

    }
}