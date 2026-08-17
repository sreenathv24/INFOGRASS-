package javacode;

abstract class Base {
	 final int a = 10;
	abstract void fun();
	abstract void funny();
}
	// Class 2
//class Derived implements Base {
	class Derived extends Base {
	    void fun()
	    {
	        System.out.println("Derived fun() called "+ a);
	    }
	    void funny() {
	    	System.out.println("Derived funny() called");
	    }
	}
	// Class 3
public class AbstractClassExample {
	public static void main(String args[])
    {

		Base b = new Derived();
        b.fun();
        b.funny();
    }
}
