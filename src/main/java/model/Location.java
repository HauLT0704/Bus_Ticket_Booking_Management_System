/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Lâm Trung Hậu (TV1)
 */
public class Location {
    private int id;
    private String name;
    private String province;
    private Date createdAt;

    public Location() {
    }

    public Location(int id, String name, String province, Date createdAt) {
        this.id = id;
        this.name = name;
        this.province = province;
        this.createdAt = createdAt;
    }

    public Location(String name, String province) {
        this.name = name;
        this.province = province;
    }

    public Location(int id, String name, String province) {
        this.id = id;
        this.name = name;
        this.province = province;
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

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    
}

