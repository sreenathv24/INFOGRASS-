package javacode.maincode;

class Deadlock {
    static final Object A = new Object();
    static final Object B = new Object();

    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            synchronized (A) {
                System.out.println("Thread 1 locked A");
                synchronized (B) {
                    System.out.println("Thread 1 locked B");
                }
            }
        });

        Thread t2 = new Thread(() -> {
            synchronized (B) {
                System.out.println("Thread 2 locked B");
                synchronized (A) {
                    System.out.println("Thread 2 locked A");
                }
            }
        });

        t1.start();
        t2.start();
        try {
            t1.join();
            t2.join();
        } catch (Exception e) {
            System.out.println("Interrupted");

        }
    }
}

