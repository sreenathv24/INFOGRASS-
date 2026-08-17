package com.example.entity;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "asset_models")
public class AssetInstance {
    @Id
    private Long modelId;
    private String modelName;

    @OneToMany(mappedBy = "assetModel")
    private List<AssetAssignment> assets;

    public AssetInstance() {}
    public String getModelName() { return modelName; }
}
