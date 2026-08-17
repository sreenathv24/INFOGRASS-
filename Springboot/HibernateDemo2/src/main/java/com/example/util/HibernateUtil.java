package com.example.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.service.ServiceRegistry;
import com.example.entity.Employee;
import com.example.entity.License;
import com.example.entity.PurchaseOrder;

public class HibernateUtil {

    private static SessionFactory sessionFactory;

    // Get the singleton SessionFactory
    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                Configuration config = new Configuration().configure();

                // Register annotated entity classes
                config.addAnnotatedClass(Employee.class);
                config.addAnnotatedClass(License.class);
                config.addAnnotatedClass(PurchaseOrder.class);

                ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                        .applySettings(config.getProperties())
                        .build();

                sessionFactory = config.buildSessionFactory(serviceRegistry);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return sessionFactory;
    }

    // Shutdown the SessionFactory
    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
