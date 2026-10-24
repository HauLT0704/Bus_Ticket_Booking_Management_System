package model;

import java.util.Date;

/**
 * Model cho Vé xe (Ticket)
 * Phân công: Huỳnh Nhất Bảo (TV4)
 */
public class Ticket {
    private int id;
    private int tripId;
    private int customerId;
    private String seatNumber;
    private Date bookingTime;
    private String status;
    private double totalPrice;

    public Ticket() {
    }

    public Ticket(int id, int tripId, int customerId, String seatNumber, Date bookingTime, String status, double totalPrice) {
        this.id = id;
        this.tripId = tripId;
        this.customerId = customerId;
        this.seatNumber = seatNumber;
        this.bookingTime = bookingTime;
        this.status = status;
        this.totalPrice = totalPrice;
    }

    public Ticket(int tripId, int customerId, String seatNumber, String status, double totalPrice) {
        this.tripId = tripId;
        this.customerId = customerId;
        this.seatNumber = seatNumber;
        this.status = status;
        this.totalPrice = totalPrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public Date getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Date bookingTime) {
        this.bookingTime = bookingTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
}
