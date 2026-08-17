package com.streams;

import java.util.*;
import java.util.stream.*;

public class StreamExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("Praveen", "Vijay", "Pavan", "Girish");
        names.stream()
             .filter(name -> name.startsWith("P"))
             .forEach(System.out::println);
    }
}

