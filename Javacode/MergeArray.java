package javacode;

public class MergeArray {

	public void mergeBoth(int[] a,int[] b) {
		int r=(a.length)+(b.length);
		int[] c=new int[r];
		int i=0,j=0;
		for(int q=0;q<c.length;q++) {
			if(q%2==0) {
				c[q]=a[i];
				i++;
			}else {
				c[q]=b[j];
				j++;
			}
		}
		for(int k=0;k<c.length;k++) {
			System.out.print(c[k]+" ");
		}
	}

	public static void main(String[] args) {
		int[] arr1= {1,2,3,4,5,9};
		int[] arr2= {6,7,8,9,10};

		MergeArray m1 =new MergeArray();
		m1.mergeBoth(arr1, arr2);
	}
}
