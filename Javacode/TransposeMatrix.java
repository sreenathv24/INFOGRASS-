package javacode;

public class TransposeMatrix {
	public static void main(String args[]){  

		int a [][]={{1,3,4},
				{8,9,10},
				{11,12,13}
		};    

		int t [][]=new int[3][3];  

		for(int i=0;i<3;i++){    
			for(int j=0;j<3;j++){    
				t [j][i]=a [i][j];  
			}    

		}     
		for(int i=0;i<3;i++){    
			for(int j=0;j<3;j++){    
				System.out.print(t [i][j]+" ");    
			}    
			System.out.println();   
		}    
	}
}
