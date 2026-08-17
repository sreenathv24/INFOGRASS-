package javacode.maincode;

class A{
    int one =1;
}
class B extends A{
    int two = 2;
}
class C extends B{
    int three =3;
}
public class Multilevelinheritance {
    public static void main(String[] args){
        C ob1 = new C();
        System.out.println(ob1.three);
        System.out.println(ob1.two);
        System.out.println(ob1.one);
    }
}
