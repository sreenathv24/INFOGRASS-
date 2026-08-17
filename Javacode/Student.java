package javacode;

public class Student {
	String _value;
	static String name;
	
	public static void main(String[] args) {
		Student s1 = new Student();
		s1._value="vikram_Instance";
		s1.name = "vikram";
		s1.name = "karthick";
		System.out.println("Instance level: "+s1.name);
		System.out.println("Class level: "+Student.name);
		System.out.println("Instance variable: "+s1._value);
//		un-commenting will have compile time error since instance variable cannot access  thru class
//		System.out.println("Instance variable: "+Student.value);
	}
}
