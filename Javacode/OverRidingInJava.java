package javacode;

//Java program to demonstrate
//method overriding in java

//Base Class
class Parent {
	void show() { System.out.println("Obj1 Parent's Class Executing show() Method"); }
}

//Inherited class
class Child extends Parent {
	// This method overrides show() of Parent
	@Override void show()
	{
		System.out.println("Obj2 Child's Class Executing show() Method");
	}
}

//Driver class
class OverRidingInJava {
	public static void main(String[] args)
	{
		// If a Parent type reference refers
		// to a Parent object, then Parent's
		// show is called
		Parent obj1 = new Parent();
		obj1.show();

		// If a Parent type reference refers
		// to a Child object Child's show()
		// is called. This is called RUN TIME
		// POLYMORPHISM.
		Parent obj2 = new Child();
		obj2.show();
	}
}

