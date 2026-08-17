package javacode;

class SumOfUnique {

	public static void main(String[] args) 
	{ 
		int[] x = { 1,2,3,2 };
		int n= x.length;
		int sum = 0;
		for (int i = 0; i <= n; i++) { 
			int j = i + 1;
			while (j < n)  
			{ 
				if (x[j] == x[i]) { 
					break; 
				} 
				j++; 
			}
			if(j==n) {
				sum += x[i];
			}
		}
		System.out.print(sum);
	}
}

