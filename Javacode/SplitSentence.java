package javacode;

public class SplitSentence {
	public static void main(String[] args) {
		String sentence = "This is a sample sentence";
		int k=sentence.length();
		int num = 11;
		if(k<num)
		{
			System.out.println("enter correct value");
		}
		else {
			String split = sentence.substring(num);
			System.out.println(split);
		}
	} 
}
