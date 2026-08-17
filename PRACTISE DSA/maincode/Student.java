package javacode;

// 1.Create a class named student.
class Student {
    // 2.Declare the following variables:
    //im creating instance variable
    String name;              // Instance variable
    int rollNo;               // Instance variable
    static String schoolName; // Static variable

    // 3.Create a constructor that:
    Student(String n, int r) {
        name = n;
        rollNo = r;
        System.out.println("Constructor called for student");
    }

    // 4.Methods
   // Non-static method to print student details
    void displayDetails() {
        System.out.println("Name: " + name + ", Roll No: " + rollNo);
    }
    // Static method to print school name
    static void displaySchoolName() {
        System.out.println("School Name: " + schoolName);
    }

    // Method to calculate and return total marks
    int calculateResult(int mark1, int mark2, int mark3) {
        int totalmarks;          // local variable
        totalmarks = mark1 + mark2 + mark3;
        return totalmarks;
    }

    // 5.Inside the main() method:
    public static void main(String[] args) {
        // Assign a value to the static variable schoolName
        Student.schoolName = "Shrishti School";
        // im Creating a two objects of the Student class using the constructor
        Student s1 = new Student("sreenath", 95);
        Student s2 = new Student("vikram", 24);
        System.out.println();

        // Call the static method using the class name
        Student.displaySchoolName();

        // Call non-static methods using objects
        s1.displayDetails();
        int total1 = s1.calculateResult(85, 90, 78);
        System.out.println("Total Marks for " + s1.name + ": " + total1);
        System.out.println();
        s2.displayDetails();
        int total2 = s2.calculateResult(70, 82, 88);
        // Print the total marks returned by the method
        System.out.println("Total Marks for " + s2.name + ": " + total2);
    }
}

