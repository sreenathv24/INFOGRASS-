package javacode;

interface A {
default void print() {
	
}
}

class B implements A {
	public static void main(String[] args) {
		A obj = new B();
	}
}

class C implements A {
	public static void main(String[] args) {
		A obj1 = new C();
	}
}

abstract class D{
 void show() {
	 
 }
}
class E extends D{
	
}