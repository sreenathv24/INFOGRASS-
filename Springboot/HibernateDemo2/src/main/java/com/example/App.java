package com.example;

import com.example.entity.License;
import com.example.entity.PurchaseOrder;
import com.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import jakarta.persistence.Query;

public class App {
    public static void main(String[] args) {


        // 1.License Allocation using session.save()/update

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            // Fetch license and employee
            License license = session.get(License.class, 1); // License id=1
            PurchaseOrder emp = session.get(PurchaseOrder.class, 2);    // Employee id=2

            if (license != null && emp != null && license.getAvailableSeats() > 0) {
                // Allocate license seat
                license.setAvailableSeats(license.getAvailableSeats() - 1);
                session.update(license); // decrement seat

                // You can create a LicenseAssignment entity if needed
                System.out.println("License allocated to:");
            } else {
                System.out.println("No seats available or employee/license not found!");
            }

            tx.commit();
        }


        // 2.Close PO using HQL

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            // Update PO status to CLOSED
            String hql = "UPDATE PurchaseOrder po SET po.status = :status WHERE po.id = :id";
            Query query = session.createQuery(hql);
            query.setParameter("status", "CLOSED");
            query.setParameter("id", 1); // PO id=1
            int rowsUpdated = query.executeUpdate();

            System.out.println("PO closed using HQL, rows affected: " + rowsUpdated);

            tx.commit();
        }


        // 3.License Allocation & Close PO using Native Query

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            // Allocate license via native query
            String sqlLicense = "UPDATE license SET available_seats = available_seats - 1 WHERE id = :licId AND available_seats > 0";
            Query nativeLicense = session.createNativeQuery(sqlLicense);
            nativeLicense.setParameter("licId", 1);
            int seatUpdated = nativeLicense.executeUpdate();
            System.out.println("License allocated via Native Query, rows: " + seatUpdated);

            // Close PO via native query
            String sqlPO = "UPDATE purchase_order SET status = 'CLOSED' WHERE id = :poId";
            Query nativePO = session.createNativeQuery(sqlPO);
            nativePO.setParameter("poId", 2); // PO id=2
            int poUpdated = nativePO.executeUpdate();
            System.out.println("PO closed via Native Query, rows: " + poUpdated);

            tx.commit();
        }

        HibernateUtil.shutdown();
    }
}
