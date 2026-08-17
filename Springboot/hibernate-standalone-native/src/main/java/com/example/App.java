package com.example;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.util.List;

public class App {
    public static void main(String[] args) {
        // Load Hibernate config
        Configuration cfg = new Configuration().configure("hibernate.cfg.xml");
        SessionFactory sessionFactory = cfg.buildSessionFactory();

        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();

            // INSERT

            String insertSql = "INSERT INTO customers (name, email) VALUES (:name, :email)";
            session.createNativeQuery(insertSql)
                    .setParameter("name", "Javan")
                    .setParameter("email", "javan.doe@example.com")
                    .executeUpdate();
            System.out.println("Customer inserted!");


            // UPDATE

            String updateSql = "UPDATE customers SET email = :newEmail WHERE name = :name";
            int rowsUpdated = session.createNativeQuery(updateSql)
                    .setParameter("newEmail", "javan.updated@example.com")
                    .setParameter("name", "Javan")
                    .executeUpdate();
            System.out.println(" " + rowsUpdated + " row(s) updated!");


            // SELECT

            String selectSql = "SELECT id, name, email FROM customers";
            List<Object[]> results = session.createNativeQuery(selectSql).getResultList();
            System.out.println("Customers list:");
            for (Object[] row : results) {
                Long id = ((Number) row[0]).longValue();
                String name = (String) row[1];
                String email = (String) row[2];
                System.out.println(" - ID: " + id + ", Name: " + name + ", Email: " + email);
            }


            // DELETE

            String deleteSql = "DELETE FROM customers WHERE name = :name";
            int rowsDeleted = session.createNativeQuery(deleteSql)
                    .setParameter("name", "Jameeru")
                    .executeUpdate();
            System.out.println(" " + rowsDeleted + " row(s) deleted!");

            tx.commit();
        }

        sessionFactory.close();
    }
}
