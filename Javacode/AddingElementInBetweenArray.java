package javacode;

import java.util.Arrays;

public class AddingElementInBetweenArray {
	public static void main(String[] args) {
		int[] a = {1,2,3,4,5,6} ;
		int n = a.length;
		int p = 2;
		int x = 9;
		int[] b = new int[n+1];
		for(int i=0; i<n+1; i++) {
			if(i<p) {
				b[i] = a[i];
			}else if(i == p) {
				b[i] = x;
			}else{
				b[i] = a[i-1];
			}
		}
		System.out.print("Final Array : " + Arrays.toString(b));
	}	
}
