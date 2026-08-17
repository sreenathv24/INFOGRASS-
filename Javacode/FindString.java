package javacode;

public class FindString {
	String a1="abcdefghijklmnopqrstuvwxyz"; 
	String a2="ABCDEFGHIJKLMNOPQRSTUVWXYZ";	
	
	String givenString1="AazBcbCZ";
	
	int gs1=givenString1.length();

	public void classificationOfLetters() {
		int lowercase=0,uppercase=0;
		for(int i=0;i<26;i++) {
			for(int j=0;j<(gs1);j++) {
				if((a1.charAt(i))==(givenString1.charAt(j))) {
					lowercase++;
				}
				if((a2.charAt(i))==(givenString1.charAt(j))) {
					uppercase++;
				}	
			}
		}
		System.out.println("Number of Lowercase letters in the given string: "+lowercase);
		System.out.println("Number of Uppercase letters in the given string: "+uppercase);
	}

	public void bothLetter() {
		char TempChar = 0;
		int upper=0;
		int lower=0;
		int lowercheck=0;
		int uppercheck=0;

		for(int i=0;i<gs1;i++) {
			if(Character.isLowerCase(givenString1.charAt(i))) { 
				lower++;
				TempChar=Character.toUpperCase(givenString1.charAt(i));
				for(int j=0;j<gs1;j++) {
					if((TempChar==givenString1.charAt(j))) {  
						lowercheck++;
					}
				}
			}
			if(Character.isUpperCase(givenString1.charAt(i))) {
				upper++;
				TempChar=Character.toLowerCase(givenString1.charAt(i));
				for(int j=0;j<gs1;j++) {
					if((TempChar==givenString1.charAt(j))) { 
						uppercheck++;
					}
				}
			}
		}		
		if((upper==uppercheck) && (lower==lowercheck)){
			System.out.println("Given String is True");
		}
		else {
			System.out.println("Given String is False");
		}
	}
	public static void main(String[] args) {
		FindString s1=new FindString();
		s1.classificationOfLetters();
		s1.bothLetter();
	}
}
