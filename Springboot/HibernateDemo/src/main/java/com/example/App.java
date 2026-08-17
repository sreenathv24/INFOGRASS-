package com.example;

import com.example.entity.AssetModel;
import com.example.entity.Employee;
import com.example.entity.UserRole;
import com.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class App {
    public static void main(String[] args) {

        // 1. Simple save() - create asset and assign role
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            AssetModel asset = new AssetModel("Laptop", "Dell", "{\"RAM\":\"16GB\",\"CPU\":\"i7\"}");
            session.save(asset);
            System.out.println("[save] Asset: " + asset.getName());

            Employee emp = session.get(Employee.class, 1); // change id if needed
            if (emp != null) {
                UserRole role = new UserRole("ADMIN", emp);
                session.save(role);
                System.out.println("[save] Assigned ADMIN to: " + safeName(emp));
            } else {
                System.out.println("[save] Employee id=1 not found.");
            }

            tx.commit();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        // 2. HQL - use JOIN FETCH to load employee with roles, then add a role
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            String hql = "SELECT e FROM Employee e LEFT JOIN FETCH e.roles WHERE e.email = :email";
            Query<Employee> q = session.createQuery(hql, Employee.class);
            q.setParameter("email", "alia@example.com"); // change to an existing email
            Employee eWithRoles = q.uniqueResult();

            if (eWithRoles != null) {
                System.out.println("[HQL] Found: " + safeName(eWithRoles));
                UserRole newRole = new UserRole("MANAGER", eWithRoles);
                session.save(newRole);
                System.out.println("[HQL] Saved MANAGER for: " + safeName(eWithRoles));
            } else {
                System.out.println("[HQL] No employee with that email.");
            }

            // HQL update
            String hqlUpdate = "UPDATE UserRole ur SET ur.roleName = :r WHERE ur.employee.id = :id";
            Query<?> upd = session.createQuery(hqlUpdate);
            upd.setParameter("r", "LEAD");
            upd.setParameter("id", 1);
            int rows = upd.executeUpdate();
            System.out.println("[HQL] Updated rows: " + rows);

            tx.commit();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        // 3) Native SQL - direct inserts (table/column names)
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();

            session.createNativeQuery(
                            "INSERT INTO asset_model (name, manufacturer, specs) VALUES (:n, :m, :s)")
                    .setParameter("n", "Printer")
                    .setParameter("m", "HP")
                    .setParameter("s", "{\"Type\":\"Laser\",\"Color\":\"Black\"}")
                    .executeUpdate();
            System.out.println("[native] Inserted asset Printer");

            session.createNativeQuery(
                            "INSERT INTO user_role (employee_id, role_name) VALUES (:eid, :r)")
                    .setParameter("eid", 1) // ensure employee exists
                    .setParameter("r", "USER")
                    .executeUpdate();
            System.out.println("[native] Inserted role USER for employee id=1");

            tx.commit();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        HibernateUtil.shutdown();
    }

    private static String safeName(Employee e) {
        if (e == null) return "Unknown";
        return e.getName() == null ? "Unknown" : e.getName();
    }
}
