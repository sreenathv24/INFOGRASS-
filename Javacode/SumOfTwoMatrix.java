package javacode;

public class SumOfTwoMatrix {
	public static void main(String args[]) 
	{ 
		int[][] a ={
				{10,20},
				{30,40}
		};
		int[][] b= {
				{5,15},
				{25,35}
		};
		int[][] c= new int[2][2];
		for(int i=0; i<2; i++) {
			for(int j=0; j<2; j++) {
				c[i][j] = a[i][j]+b[i][j];
			}
		}
		for(int i=0; i<1; i++) {
			for(int j=0; j<2; j++) {	
				System.out.print(" "+c[i][j]);
			}
		}
		System.out.println(" ");
		for(int i=1; i<2; i++) {
			for(int j=0; j<2; j++) {	
				System.out.print(" "+c[i][j]);
			}
		}
	}
}
