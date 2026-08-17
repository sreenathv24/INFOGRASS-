package javacode.maincode;
class Engine {
    void start() {
        System.out.println("Engine Started");
    }
}

public class CompositionDemo {
    private Engine engine = new Engine();  // Composition relationship

    void drive() {
        engine.start();
        System.out.println("Car is moving...");
    }
    public static void main(String[] args) {
        CompositionDemo car = new CompositionDemo();
        car.drive();
    }
}
