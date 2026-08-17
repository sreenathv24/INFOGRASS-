package javacode;

public class IpAddress {

	public void bracketsIP(String c) {
		int size=c.length();
		int i=0;
		while(i<size) {
			if(c.charAt(i)=='.') {
				System.out.print(" ");
				System.out.print("[.]");
				System.out.print(" ");
			}else {
				System.out.print(c.charAt(i));
			}
			i++;
		}
	}
	public static void main(String[] args) {
		String ip="122.233.34.4";
		IpAddress ip1=new IpAddress();
		ip1.bracketsIP(ip);
		System.out.println("Test......commit");
	}
}

