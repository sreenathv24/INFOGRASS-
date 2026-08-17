package com.pizza.order;

enum PizzaSize { SMALL, MEDIUM, LARGE }

public class PizzaOrder {
    public static void main(String[] args) {
        PizzaSize size = PizzaSize.MEDIUM;
        switch(size){
            case SMALL -> System.out.println("Small Pizza");
            case MEDIUM -> System.out.println("Medium Pizza");
            case LARGE -> System.out.println("Large Pizza");
        }
    }
}
