package com.example.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "license")
public class License {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;

    @Column(name = "available_seats")
    private int availableSeats;

    // Constructors
    public License() {}

    public License(String name, int availableSeats) {
        this.name = name;
        this.availableSeats = availableSeats;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
}
