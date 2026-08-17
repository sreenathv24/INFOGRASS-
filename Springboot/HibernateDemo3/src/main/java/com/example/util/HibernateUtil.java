package com.example.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import com.example.entity.Department;
import com.example.entity.AssetInstance;
import com.example.entity.AssetAssignment;
import com.example.entity.Employee;

public class HibernateUtil {

    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                Configuration cfg = new Configuration().configure(); // reads hibernate.cfg.xml

                // register entities (optional if already in cfg)
                cfg.addAnnotatedClass(Department.class);
                cfg.addAnnotatedClass(AssetInstance.class);
                cfg.addAnnotatedClass(AssetAssignment.class);
                cfg.addAnnotatedClass(Employee.class);

                ServiceRegistry sr = new StandardServiceRegistryBuilder()
                        .applySettings(cfg.getProperties())
                        .build();

                sessionFactory = cfg.buildSessionFactory(sr);
            } catch (Exception ex) {
                ex.printStackTrace();
                throw new RuntimeException("Failed to build SessionFactory", ex);
            }
        }
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
