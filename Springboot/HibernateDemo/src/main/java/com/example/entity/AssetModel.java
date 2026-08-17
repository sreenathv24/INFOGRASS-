package com.example.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "asset_model")
public class AssetModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String manufacturer;

    @Column(columnDefinition = "TEXT")
    private String specs; // storing JSON as string

    // Constructors
    public AssetModel() {}

    public AssetModel(String name, String manufacturer, String specs) {
        this.name = name;
        this.manufacturer = manufacturer;
        this.specs = specs;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public String getSpecs() { return specs; }
    public void setSpecs(String specs) { this.specs = specs; }
}
