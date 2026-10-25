package model;

import java.util.Date;

/**
 * @author Lâm Trung Hậu (TV1)
 */
public class Location {
    private int id;
    private String name; // Tên Tỉnh / Thành phố
    private Date createdAt;

    public Location() {
    }

    public Location(String name) {
        this.name = name;
    }

    public Location(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public Location(int id, String name, Date createdAt) {
        this.id = id;
        this.name = name;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}