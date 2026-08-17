package javacode;

public class MaximumWealth {
	public static void main(String args[]) {
		int[][] account= {{1,2,59},{4,5,6}};
		int[]customer= new int[account.length];
		for (int i=0;i<account.length;i++) {
			for (int j=0;j<account[i].length;j++) {
				customer[i]+=account[i][j];
			}
		}
		if (customer[0]<=customer[1]) { 
			System.out.println("Customer A : "+ customer[0]);
			System.out.println("Customer B : "+ customer[1]);
			System.out.println("Customer B has more Wealth than customer A ");
		}
		else{
			System.out.println("Customer A : "+ customer[0]);
			System.out.println("Customer B : "+ customer[1]);
			System.out.println("Customer A has more Wealth than customer B ");
		}
	}

}
