package AggregateFunction;

import java.util.*;
import java.util.stream.*;

public class AverageSalary {
    public static void main(String[] args) {
        List<Integer> salaries = Arrays.asList(3000, 4000, 5000, 6000);
        double avg = salaries.stream().mapToInt(s -> s).average().orElse(0);
        System.out.println("Average Salary: " + avg);
    }
}
