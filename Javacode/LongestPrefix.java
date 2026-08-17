package javacode;

public class LongestPrefix {


	public void Prefix(String[] st) {
		boolean checkWord=false;
		boolean checkPrefix=false;
		char[] words= new char[3];
		int i=0,k=0,j=1;
		while((i<st.length)&&(!checkWord)) {
			checkPrefix=false;
			while((j<st.length)&&(!checkPrefix)) {
				if(st[i].substring(i).charAt(i)==st[i].substring(j).charAt(j)) {
					System.out.println("in if test "+st[j].substring(j));
					words[k]=st[i].substring(i).charAt(i);
					checkPrefix=true;
					k++;
				}
				j++;
			}
			i++;
		}
		System.out.println(words);
	}
	
	public static void main(String[] args) {
		String[] s1= {"flower","flow","flop"};
		
	LongestPrefix s = new LongestPrefix();
	s.Prefix(s1);


	}
}
