package model;

/**
 * @author Phan Thanh Tu (TV3)
 */
public class Vehicle {

    private int id;
    private String licensePlate;
    private int totalSeats;
    private String type;
    private String status;

    public Vehicle() {
    }

    public Vehicle(int id, String licensePlate, int totalSeats, String type, String status) {
        this.id = id;
        this.licensePlate = licensePlate;
        this.totalSeats = totalSeats;
        this.type = type;
        this.status = status;
    }

    public Vehicle(String licensePlate, int totalSeats, String type, String status) {
        this.licensePlate = licensePlate;
        this.totalSeats = totalSeats;
        this.type = type;
        this.status = status;
    }

    // 4. Getter và Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
