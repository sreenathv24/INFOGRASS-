package javacode;

//InvalidDataException is a custom error class 
//Always custom exp class should extends to other exp child class or exception parent class
class InvalidDataException extends Exception{
	public  InvalidDataException(String message) {
		//to call the given string from error method @InvalidDataException "super" keyword is used
		super(message);
	}
}
public class CustomException {
	//method has to throws the Exception class
		public void salaryCheck(double salary)throws InvalidDataException {
			if(salary<0) {
				throw new InvalidDataException("Invalid");//predicting the error and throwing it
			}else {
				System.out.println("Salary is: "+salary);//Else block run if input is valid
			}
		}
		public static void main(String[] args)  {
			double salary=-30000.78;//(-)error value
			CustomException a1=new CustomException();
			try {
				a1.salaryCheck(salary);//the code could contain error is mentioned in try
			}
			catch(InvalidDataException e) {
				e.printStackTrace();
				System.out.println("Please enter valid number: error "+e);//handling the error
			}
		}
}
