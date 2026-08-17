package javacode.maincode;

class SimpleThreads {
    static void threadMessage(String msg) {
        System.out.println(Thread.currentThread().getName() + ": " + msg);
    }

    static class MessageLoop implements Runnable {
        public void run() {
            String messages[] = {"One", "Two", "Three"};
            try {
                for(String msg : messages) {
                    Thread.sleep(2000);
                    threadMessage(msg);
                }
            } catch (InterruptedException e) {
                threadMessage("Interrupted");
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Thread t = new Thread(new MessageLoop());
        t.start();
    }
}

