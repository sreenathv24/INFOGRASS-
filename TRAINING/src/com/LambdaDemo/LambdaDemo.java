package com.LambdaDemo;

interface Logger {
    void log(String message);
}

public class LambdaDemo {
    public static void main(String[] args) {
        Logger logger = msg -> System.out.println("LOG: " + msg);
        logger.log("Server started!");
    }
}
