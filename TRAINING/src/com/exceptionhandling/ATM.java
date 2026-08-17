package com.exceptionhandling;

public class ATM {
    public static void main(String[] args) {
        int balance = 1000;
        int withdraw = 1500;

        try {
            if (withdraw > balance) {
                throw new ArithmeticException("Insufficient Balance");
            } else {
                balance -= withdraw;
                System.out.println("Withdraw Successful. Remaining balance: " + balance);
            }
        } catch (ArithmeticException e) {
            System.out.println("Exception: " + e.getMessage());
        }
    }
}

