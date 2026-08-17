package com.example.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.service.ServiceRegistry;

public class HibernateUtil {

    private static SessionFactory sessionFactory;

    // Build SessionFactory once
    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                // Load configuration from hibernate.cfg.xml
                Configuration configuration = new Configuration().configure();

                // If you have annotated classes, register them here
                configuration.addAnnotatedClass(com.example.entity.AssetModel.class);
                configuration.addAnnotatedClass(com.example.entity.Employee.class);
                configuration.addAnnotatedClass(com.example.entity.UserRole.class);

                ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                        .applySettings(configuration.getProperties())
                        .build();

                sessionFactory = configuration.buildSessionFactory(serviceRegistry);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return sessionFactory;
    }

    // Shutdown SessionFactory
    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
