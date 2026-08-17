package com.example;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

public class App {
    public static void main(String[] args) {
        // loads hibernate.cfg.xml from classpath (src/main/resources)
        Configuration cfg = new Configuration();
        cfg.configure("hibernate.cfg.xml");

        try (SessionFactory sessionFactory = cfg.buildSessionFactory();
             Session session = sessionFactory.openSession()) {

            Transaction tx = session.beginTransaction();

            User user = new User("rohan", "rohan@example.com");
            session.persist(user);

            tx.commit();

            System.out.println("Inserted user id: " + user.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
