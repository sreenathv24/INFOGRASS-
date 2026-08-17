package javacode;

import java.util.ArrayList;

public class PrintFirstElement {

	public static void main(String[] args) {
		ArrayList<String> student = new ArrayList<>();
		student.add("Karthick");
		student.add("Naveen");
		student.add("Vikram");

		String firstElement = student.get(0);
		if (firstElement != null) {
			System.out.println(firstElement);
		} else {
			System.out.println("ArrayList is empty");
		}
	}
}
