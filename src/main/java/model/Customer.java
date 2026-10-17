package model;

/**
 * @author Phan Thanh Tu (TV3)
 */
public class Customer {

    private int id;
    private String fullName;
    private String phone;
    private String email;
    private String idCard;

    public Customer() {
    }

    public Customer(int id, String fullName, String phone, String email, String idCard) {
        this.id = id;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.idCard = idCard;
    }

    public Customer(String fullName, String phone, String email, String idCard) {
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.idCard = idCard;
    }

    // 4. Getter và Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }
}
