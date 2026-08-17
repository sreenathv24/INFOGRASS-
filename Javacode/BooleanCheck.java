package javacode;

public class BooleanCheck {
	public static void main(String[] args) {
		String s1 = "AaBb";//true
		String s2 = "soOsp";//false
		String s3 = "AbbaTT";//false

		System.out.println(checkString(s1));
		System.out.println(checkString(s2));
		System.out.println(checkString(s3));
	}

	public static boolean checkString(String s) {
		boolean hasUpperCase = false;
		boolean hasLowerCase = false;
		int Var1=0;
		char CaseConvert;

		while((Var1 <s.length())&&(!hasUpperCase)) {
			hasLowerCase = false;
			if(Character.isLowerCase(s.charAt(Var1))) {
				CaseConvert=Character.toUpperCase(s.charAt(Var1));
			}else {
				CaseConvert=Character.toLowerCase(s.charAt(Var1));
			}
			int Var2=0;
			while((Var2<s.length())&&(!hasLowerCase)) {
				if(CaseConvert==(s.charAt(Var2))){
					hasLowerCase=true;
				}
				Var2++;
			}
			Var1++;
			if(!hasLowerCase) {
				return hasLowerCase;
			}	
		}
		return hasLowerCase;
	}
}
