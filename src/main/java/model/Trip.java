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
public class Trip {

    private int id;
    private Timestamp departureTime;
    private Timestamp arrivalTime;
    private int availableSeats;
    private double price;
    private String status;
    private Timestamp createdAt;

    // Thuộc tính bổ trợ để hiển thị thông tin tuyến và xe lên giao diện JSP
    private Route route;
    private Vehicle vehicle;

    public Trip() {
    }

    public Trip(int id, Timestamp departureTime, Timestamp arrivalTime, int availableSeats, double price, String status, Timestamp createdAt, Route route, Vehicle vehicle) {
        this.id = id;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.availableSeats = availableSeats;
        this.price = price;
        this.status = status;
        this.createdAt = createdAt;
        this.route = route;
        this.vehicle = vehicle;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Timestamp departureTime) {
        this.departureTime = departureTime;
    }

    public Timestamp getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(Timestamp arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Route getRoute() {
        return route;
    }

    public void setRoute(Route route) {
        this.route = route;
    }

    public Vehicle getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle vehicle) {
        this.vehicle = vehicle;
    }

    // 1. Hàm lấy ID phụ trợ (để phòng khi code cũ cần gọi)
    public int getRouteId() {
        return (route != null) ? route.getId() : 0;
    }

    public int getVehicleId() {
        return (vehicle != null) ? vehicle.getId() : 0;
    }

    // 2. Hai hàm hiển thị ngắn gọn
    public String getDisplayRouteName() {
        if (route != null && route.getFromLocation() != null && route.getToLocation() != null) {
            return route.getFromLocation().getName() + " -> " + route.getToLocation().getName();
        }
        return "Tuyến #" + getRouteId();
    }

    public String getDisplayVehicleName() {
        if (vehicle != null && vehicle.getLicensePlate() != null) {
            return vehicle.getLicensePlate();
        }
        return "Xe #" + getVehicleId();
    }
}
