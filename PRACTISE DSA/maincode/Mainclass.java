package javacode.maincode;

abstract class Animal{
    String name;
    Animal(String name){
        this.name = name;
    }
    abstract void makeSound();
}
class Lion extends Animal {
    Lion(String name){
        super(name);
    }
    void makeSound(){
        System.out.println("Roar");
    }
}
class Cat extends Animal{
    Cat(String name){
        super(name);
    }
    void makeSound(){
        System.out.println("Meow Meow..");
    }
}
public class Mainclass {
    public static void main(String[] args){
        Lion l1 = new Lion("Bobby");
        System.out.println(l1.name);
        l1.makeSound();

        Cat c1 = new Cat("Tommy");
        System.out.println(c1.name);
        c1.makeSound();
    }
}
 