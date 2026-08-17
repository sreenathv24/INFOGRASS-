package com.example.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "asset_assignment")
public class AssetAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id")
    private Employee employee;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "asset_instance_id")
    private AssetInstance assetInstance;

    private LocalDateTime assignedAt;
    private int usageHours;

    public AssetAssignment() {}
    public AssetAssignment(Employee employee, AssetInstance assetInstance, LocalDateTime assignedAt, int usageHours) {
        this.employee = employee; this.assetInstance = assetInstance; this.assignedAt = assignedAt; this.usageHours = usageHours;
    }

    // getters/setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Employee getEmployee() { return employee; }
    public void setEmployee(Employee employee) { this.employee = employee; }

    public AssetInstance getAssetInstance() { return assetInstance; }
    public void setAssetInstance(AssetInstance assetInstance) { this.assetInstance = assetInstance; }

    public LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(LocalDateTime assignedAt) { this.assignedAt = assignedAt; }

    public int getUsageHours() { return usageHours; }
    public void setUsageHours(int usageHours) { this.usageHours = usageHours; }
}
