package javacode;

class User {
	String userno;
	String username;
	String password;
}
public class CreatingObj {
	public static void main(String[] args) {
		User p1 = new User();
		p1.userno="1";
		p1.username="Venkat";
		p1.password="123qwerty";
		System.out.println("User "+p1.userno);
		System.out.println("username : "+p1.username);
		System.out.println("password : "+p1.password);
		System.out.println(" ");
		
		User p2 = new User();
		p2.userno="2";
		p2.username="Karthick";
		p2.password="12345qwerty";
		System.out.println("User "+p2.userno);
		System.out.println("username : "+p2.username);
		System.out.println("password : "+p2.password);
		System.out.println(" ");
		
		User p3 = new User();
		p3.userno="3";
		p3.username="varun";
		p3.password="1255qwerty";
		System.out.println("User "+p3.userno);
		System.out.println("username : "+p3.username);
		System.out.println("password : "+p3.password);
		System.out.println(" ");
		
	}
}
