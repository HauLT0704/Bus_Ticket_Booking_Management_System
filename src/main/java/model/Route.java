/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Nguyễn Tấn Phát (TV2)
 */
public class Route {

    private int id;
    private double distance;
    private int duration;
    private Timestamp createdAt;

    // Thuộc tính bổ trợ để hiển thị tên tỉnh/bến xe lên giao diện JSP
    private Location fromLocation;
    private Location toLocation;

    public Route() {
    }

    public Route(int id, double distance, int duration, Timestamp createdAt, Location fromLocation, Location toLocation) {
        this.id = id;
        this.distance = distance;
        this.duration = duration;
        this.createdAt = createdAt;
        this.fromLocation = fromLocation;
        this.toLocation = toLocation;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Location getFromLocation() {
        return fromLocation;
    }

    public void setFromLocation(Location fromLocation) {
        this.fromLocation = fromLocation;
    }

    public Location getToLocation() {
        return toLocation;
    }

    public void setToLocation(Location toLocation) {
        this.toLocation = toLocation;
    }

   

}
