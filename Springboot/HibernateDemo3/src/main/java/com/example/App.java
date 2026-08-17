package com.example;

import com.example.entity.*;
import com.example.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class App {
    public static void main(String[] args) {
        seedSampleData();

        // A) WITHOUT SQL
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = s.beginTransaction();

            System.out.println("\nNO-SQL: Asset utilization by department");
            List<Department> depts = s.createQuery("FROM Department", Department.class).list();
            for (Department d : depts) {
                System.out.println("Dept: " + safe(d.getName()));
                Set<AssetInstance> assets = d.getAssets();
                if (assets == null || assets.isEmpty()) {
                    System.out.println("  (no assets)");
                    continue;
                }
                for (AssetInstance a : assets) {
                    System.out.println("  Asset: " + safe(a.getName()) + " used=" + a.getUsed() + "/" + a.getCapacity());
                    Map<String, Integer> byEmp = new HashMap<>();
                    Set<AssetAssignment> assigns = a.getAssignments();
                    if (assigns != null) {
                        for (AssetAssignment asg : assigns) {
                            Employee e = asg.getEmployee();
                            String name = e == null ? "Unknown" : safe(e.getName());
                            byEmp.put(name, byEmp.getOrDefault(name, 0) + 1);
                        }
                    }
                    if (byEmp.isEmpty()) {
                        System.out.println("    (no employee usage)");
                    } else {
                        byEmp.forEach((name, cnt) -> System.out.println("    " + name + " -> " + cnt));
                    }
                }
            }

            System.out.println("\nNO-SQL: Spare capacity (>=80%)");
            List<AssetInstance> all = s.createQuery("FROM AssetInstance", AssetInstance.class).list();
            for (AssetInstance a : all) {
                if (a.getCapacity() > 0) {
                    double pct = a.getUsed() * 100.0 / a.getCapacity();
                    if (pct >= 80.0) {
                        System.out.printf("  %s (dept=%s) %.1f%% (%d/%d)%n",
                                safe(a.getName()),
                                a.getDepartment() == null ? "Unknown" : safe(a.getDepartment().getName()),
                                pct, a.getUsed(), a.getCapacity());
                    }
                }
            }

            tx.commit();
        }

        // B) HQL
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = s.beginTransaction();

            System.out.println("\nHQL: utilization per dept & employee");
            String hql = "SELECT ai.department.name, ai.name, emp.name, COUNT(asg.id) " +
                    "FROM AssetAssignment asg " +
                    "JOIN asg.assetInstance ai " +
                    "JOIN asg.employee emp " +
                    "GROUP BY ai.department.name, ai.name, emp.name " +
                    "ORDER BY ai.department.name";
            Query<Object[]> q = s.createQuery(hql, Object[].class);
            for (Object[] r : q.list()) {
                System.out.println("Dept=" + nvl(r[0]) + ", Asset=" + nvl(r[1]) + ", Emp=" + nvl(r[2]) + ", cnt=" + r[3]);
            }

            System.out.println("\nHQL: spare capacity bins (>=80%)");
            String hql2 = "SELECT ai.name, ai.department.name, ai.used, ai.capacity, (ai.used*100.0/ai.capacity) " +
                    "FROM AssetInstance ai " +
                    "WHERE ai.capacity > 0 AND (ai.used*100.0/ai.capacity) >= 80.0";
            Query<Object[]> q2 = s.createQuery(hql2, Object[].class);
            for (Object[] r : q2.list()) {
                System.out.printf("Asset=%s, Dept=%s, used=%d/%d (%.1f%%)%n",
                        nvl(r[0]), nvl(r[1]),
                        ((Number) r[2]).intValue(),
                        ((Number) r[3]).intValue(),
                        ((Number) r[4]).doubleValue());
            }

            tx.commit();
        }

        // C) Native SQL
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = s.beginTransaction();

            System.out.println("\nNATIVE: utilization per dept & employee");
            String sql = "SELECT d.name, ai.name, e.name, COUNT(aas.id) " +
                    "FROM asset_assignment aas " +
                    "JOIN asset_instance ai ON aas.asset_instance_id = ai.id " +
                    "JOIN employee e ON aas.employee_id = e.id " +
                    "JOIN department d ON ai.department_id = d.id " +
                    "GROUP BY d.name, ai.name, e.name " +
                    "ORDER BY d.name";
            List<Object[]> nr = s.createNativeQuery(sql).list();
            for (Object[] r : nr) {
                System.out.println("Dept=" + nvl(r[0]) + ", Asset=" + nvl(r[1]) + ", Emp=" + nvl(r[2]) + ", cnt=" + ((Number) r[3]).intValue());
            }

            System.out.println("\nNATIVE: spare capacity bins (>=80%)");
            String sql2 = "SELECT ai.name, d.name, ai.used, ai.capacity, (ai.used*100.0/ai.capacity) " +
                    "FROM asset_instance ai " +
                    "LEFT JOIN department d ON ai.department_id = d.id " +
                    "WHERE ai.capacity > 0 AND (ai.used*100.0/ai.capacity) >= 80.0";
            List<Object[]> nr2 = s.createNativeQuery(sql2).list();
            for (Object[] r : nr2) {
                System.out.printf("Asset=%s, Dept=%s, used=%d/%d (%.1f%%)%n",
                        nvl(r[0]), nvl(r[1]),
                        ((Number) r[2]).intValue(),
                        ((Number) r[3]).intValue(),
                        ((Number) r[4]).doubleValue());
            }

            tx.commit();
        }

        HibernateUtil.shutdown();
    }

    private static void seedSampleData() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = s.beginTransaction();

            Long c = s.createQuery("SELECT count(d) FROM Department d", Long.class).uniqueResult();
            if (c != null && c > 0) {
                tx.commit();
                return;
            }

            Department eng = new Department("Engineering");
            Department sup = new Department("Support");
            s.save(eng);
            s.save(sup);

            AssetInstance binA = new AssetInstance("Bin-A1", 100, 85, eng);
            AssetInstance lap1 = new AssetInstance("Laptop-001", 1, 1, eng);
            AssetInstance binB = new AssetInstance("Bin-B1", 50, 10, sup);
            s.save(binA);
            s.save(lap1);
            s.save(binB);

            Employee a = new Employee("Alice", "alice@example.com");
            Employee b = new Employee("Bob", "bob@example.com");
            s.save(a);
            s.save(b);

            AssetAssignment aa1 = new AssetAssignment(a, lap1, LocalDateTime.now().minusDays(5), 10);
            AssetAssignment aa2 = new AssetAssignment(b, binA, LocalDateTime.now().minusDays(1), 2);
            s.save(aa1);
            s.save(aa2);

            tx.commit();
            System.out.println("Seeded sample data.");
        }
    }

    // helpers
    private static String safe(String s) {
        return s == null ? "Unknown" : s;
    }

    private static String nvl(Object o) {
        return o == null ? "Unknown" : o.toString();
    }
}
