package javacode;

public class IntersectionOfArray {
	public static void main(String[] args) {
		int[] a= {1,2,3,8,9,8,4};
		int[] b= {6,8,9,9,10,2};
		int k=0,q=0;
		for (int i=0;i<a.length;i++) {
			for(int j=0;j<b.length;j++) {
				if (a[i]==b[j]) {
					k++;
				}
			}
		}
		int[] c= new int[k];
		for (int i=0;i<a.length;i++) {
			for(int j=0;j<b.length;j++) {
				if (a[i]==b[j]) {
					c[q]=b[j];
					q++;
				}
			}
		}
		for (int i = 0; i <= k; i++) { 
			int m = i + 1;
			while (m < k) {  
				if (c[i]==c[m]) {
					break;
				}
				m++; 
			}
			if(m==k) {
				System.out.print(c[i]+" ");
			}
		}
	}	
}
