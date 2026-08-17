package javacode.maincode;

public class ThreadCorruption {
    static int counter = 0;
    public static void main(String[] args) {
        WorkerThread worker1 = new WorkerThread("Worker 1");
        WorkerThread worker2 = new WorkerThread("Worker 2");
        WorkerThread worker3 = new WorkerThread("Worker 3");
        worker1.start();
        worker2.start();
        worker3.start();
    }
    static class WorkerThread extends Thread {
        public WorkerThread(String name) {
            super(name);
        }
        @Override
        public void run() {
            for (int i = 0; i < 5; i++) {
                synchronized(ThreadCorruption.class) {
                int temp = counter;
                try { Thread.sleep(10); }
                catch (InterruptedException e) {}
                temp = temp + 10;
                counter = temp;
                }
                System.out.println(this.getName() + " made counter: " + counter);
            }
        }
    }
}

