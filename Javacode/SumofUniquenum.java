package javacode;

public class SumofUniquenum {
	private static int[][] xs;

	public static void main(String args[]) 
	{ 
		int a [][]= {{1,2,3,4,4}};
		xs = null;
		int n= a.length;
		for (int i = 0; i <= n; i++) { 
			int j = i + 1;
			while (j < n)  
			{ 
				if (a[j] == a[i]) { 
					break; 
				} 
				j++; 
			}   
			for(int k=0;k<n;k++){    
				xs [i][j]=a [j][i];
			}
		}
		for(int i1=0;i1<3;i1++){    
			for(int j1=0;j1<3;j1++){    
				System.out.print(xs [i1][j1]+" ");    
			}    
			System.out.println();
		}
	}
}

