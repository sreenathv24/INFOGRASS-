package com.example.entity;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "employee")
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String email;

    @OneToMany(mappedBy = "employee", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<AssetAssignment> assignments;

    public Employee() {}
    public Employee(String name, String email) { this.name = name; this.email = email; }

    // getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Set<AssetAssignment> getAssignments() { return assignments; }
    public void setAssignments(Set<AssetAssignment> assignments) { this.assignments = assignments; }
}
