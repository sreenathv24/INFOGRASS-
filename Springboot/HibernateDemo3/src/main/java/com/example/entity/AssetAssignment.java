package com.example.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "assets")
public class AssetAssignment {
    @Id
    private Long assetId;

    @ManyToOne
    @JoinColumn(name = "model_id")
    private AssetInstance assetModel;

    @ManyToOne
    @JoinColumn(name = "employee_id")
    private Employee assignedTo;

    private String currentStatus;
    private LocalDateTime updatedAt;

    public AssetAssignment() {}
    public Long getAssetId() { return assetId; }
    public AssetInstance getAssetModel() { return assetModel; }
    public Employee getAssignedTo() { return assignedTo; }
    public String getCurrentStatus() { return currentStatus; }
    public void setCurrentStatus(String currentStatus) { this.currentStatus = currentStatus; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
