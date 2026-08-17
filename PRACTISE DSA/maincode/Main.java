package javacode.maincode;

class Dept {
    Student student = new Student();   // composition
    @Override
    protected void finalize() {
        System.out.println("Dept destroyed");
    }
}
class Student {
    @Override
    protected void finalize() {
        System.out.println("Student destroyed");
    }
}
public class Main {
    public static void main(String[] args) throws InterruptedException {
        Dept d = new Dept();
        d = null;
        //Thread.sleep(1000);
        System.gc();
        System.out.println();
    }
}
