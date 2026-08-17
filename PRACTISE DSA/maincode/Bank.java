package javacode.maincode;

abstract class Bank {
    abstract double getInterestRate();

    void display() {
        System.out.println("Bank Interest Info");
    }
}

class SBI extends Bank {
    double getInterestRate() {
        return 6.5;
    }
}

class HDFC extends Bank {
    double getInterestRate() {
        return 7.0;
    }

    public static void main(String[] args) {
        Bank b1 = new SBI();
        Bank b2 = new HDFC();

        System.out.println(b1.getInterestRate());
        System.out.println(b2.getInterestRate());
    }
}
