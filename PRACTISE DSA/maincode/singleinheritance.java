package javacode.maincode;

class Animals{
    void eat(){
        System.out.println("This animal can eat");
    }
}
class Dogs extends Animals{
    void bark() {
        System.out.println("Barks");
    }
}
public class singleinheritance {
    public static void main(String[] args){
     Dogs d1 = new Dogs();
        d1.bark();
        d1.eat();
    }
}
