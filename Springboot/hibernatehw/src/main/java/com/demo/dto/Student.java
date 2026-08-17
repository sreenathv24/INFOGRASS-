package com.demo.dto;

import javax.validation.constraints.NotNull;

public class Student {
	
	private int studentId;
	private String firstName;
	private String lastName;
	private String className;
	private String rollNo;
	private int age;
	

	public int getStudentId() {
		return studentId;
	}


	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}


	@NotNull(message = "Please enter first name")
	public String getFirstName() {
		return firstName;
	}


	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}


	public String getLastName() {
		return lastName;
	}


	public void setLastName(String lastName) {
		this.lastName = lastName;
	}


	public String getClassName() {
		return className;
	}


	public void setClassName(String className) {
		this.className = className;
	}


	public String getRollNo() {
		return rollNo;
	}


	public void setRollNo(String rollNo) {
		this.rollNo = rollNo;
	}


	public int getAge() {
		return age;
	}


	public void setAge(int age) {
		this.age = age;
	}


	public static void main(String[] args) {
		// TODO Auto-generated method stub
		

	}

}
