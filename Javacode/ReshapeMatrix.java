package javacode;

public class ReshapeMatrix {

	public void reshape(int[][] matrix, int r, int c) {
		int [][] currMat = new int [r][c];
		int ri=0, ci=0;
		for(int i=0; i<=r-1; i++){
			for(int j=0; j<=c-1; j++){
				currMat[ri][ci] = matrix[i][j];
				ci++;
				if(c <= ci ){
					ci=0;
					ri++;
				}
			}
		}
		for(int i=0;i<r;i++) {
			for(int j=0;j<c;j++) {
				System.out.print(currMat[i][j]+" ");
			}
			System.out.println();   
		}
	}

	public static void main(String[] args) {
		ReshapeMatrix r1=new ReshapeMatrix();
		int mat[][]= {{1,3,4},
				{8,9,10},
				{89,15,11}
		};  
		int r=3,c=2;
		
		r1.reshape(mat,r,c);
	}
}
