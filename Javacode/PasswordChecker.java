package javacode;

public class PasswordChecker {
	public static void main(String[] args) {

		String password = "qe8po";
		String num= "1234567890";
		String sym="@#*&_.+=";

		int r=1,k=1,q=1;
		int letter = password.length();
		int number = num.length();
		int symbol= sym.length();

		if(letter<6) {
			System.out.println("Password must contain atleast 6 letters");}
		else {
			r=0;
		}

		for(int i=0;i<letter;i++) {
			for(int j=0;j<number;j++) {

				if(password.charAt(i)==num.charAt(j))
					k=0;
			}
		}
		if(k==1)
			System.out.println("Password must contain atleast one number");


		for(int i=0;i<letter;i++) {
			for(int j=0;j<symbol;j++) {
				if(password.charAt(i)==sym.charAt(j))
					q=0;
			}
		}
		if(q==1)
			System.out.println("Password must contain atleast one Symbols");


		if(r==0) {
			if(k==0) {
				if(q==0) {
					System.out.println("Password Saved Successfully");
				}
			}
		}
	}
}
