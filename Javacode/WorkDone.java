//1723. Find Minimum Time to Finish All Jobs

package javacode;

import java.util.Arrays;

public class WorkDone {
	public static void main(String[] args) {
		int[] w= {1,1,1,1,6};
		int[] w1=new int[w.length-1];
		int[] w2=new int[w1.length-1];
		int length=w.length;
		int k=0,q=0,m=0,a1=0,a2=0;
			for(int i=0;i<w.length;i++) {
				k+=w[i];
				}
				System.out.println("Sum of array = "+k);
				int l = k/2;
				int b = k%2;
				System.out.println("q = "+l);
				System.out.println("r = "+b);	
				if(b==0) {
					for(int i=0;i<w.length;i++) {
						for(int j=0;j<w.length;j++) {
							if(i!=j){
							m=w[i]+w[j];
							if(m==l){
								q++;
								if(q==1){
									System.out.println("work 1 = ["+w[i]+", "+w[j]+"]");
									a1=i;
									a2=j;      
									}	
								}
							}
							
						}
					}
					for(int ij=0; ij<length; ij++) {
			            if(ij<a1+1) {
			                w1[ij] = w[ij];
			            }
			            else{
			                w1[ij-1] = w[ij];
			            }
			        }
					int length1=w1.length;
					for(int ij=0; ij<length1; ij++) {
			            if(ij<a2-1){
			                w2[ij] = w1[ij];
			            }
			            	if(ij>=a2){
			                w2[ij-1] = w1[ij];
			            	}
			        }
					System.out.println("work 2 : "+Arrays.toString(w2));
					}					
		}				
	}
	
