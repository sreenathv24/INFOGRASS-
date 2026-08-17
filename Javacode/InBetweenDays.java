package javacode;

public class InBetweenDays {
	public static void main(String[] args) {

		int d1 =5, m1=1,y1=2023;
		int d2 =31,m2=12,y2=2023;


		int m[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
		int mly[] = { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
		int n1=0, p1=0, p2=0, q=0;

		if (y1==y2) {
			if (y1 % 4 == 0) {
				for(int i=m1;i<=m2-1;i++) {
					n1+=mly[i-1];
				}
				p1=n1-d1;
				p2=p1+d2;
				System.out.println("Date 1: "+d1+"-"+m1+"-"+y1);
				System.out.println("Date 2: "+d2+"-"+m2+"-"+y2);
				System.out.println("Total no of Days inbetween given date is : "+p2+" Days");
				q=1;
			}
		}	
		if(q==0) {
			for(int i=m1;i<=m2-1;i++) {
				n1+=m[i-1];
			}
			p1=n1-d1;
			p2=p1+d2;
			System.out.println("Date 1: "+d1+"-"+m1+"-"+y1);
			System.out.println("Date 2: "+d2+"-"+m2+"-"+y2);						
			System.out.println("Total no of Days inbetween given date is : "+p2+" Days");
		}
		else {	
			System.out.println("No.of days can be calculated only within the same year");
		}
	}
}

