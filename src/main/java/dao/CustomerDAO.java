package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

/**
 * @author Phan Thanh Tu (TV3)
 */
public class CustomerDAO extends DBContext {

    // 1. Lấy tất cả khách hàng
    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customers"; // Sửa 'customers' thành 'Customers'
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer c = new Customer(
                        rs.getInt("Id"),
                        rs.getNString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Email"),
                        rs.getString("IdCard")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy khách hàng theo ID (dùng cho chức năng Sửa)
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM Customers WHERE Id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("Id"),
                        rs.getNString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Email"),
                        rs.getString("IdCard")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Thêm khách hàng mới
    public void insertCustomer(Customer c) {
        String sql = "INSERT INTO Customers (FullName, Phone, Email, IdCard) VALUES (?, ?, ?, ?)";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setNString(1, c.getFullName());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getIdCard());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Cập nhật thông tin khách hàng
    public void updateCustomer(Customer c) {
        String sql = "UPDATE Customers SET FullName = ?, Phone = ?, Email = ?, IdCard = ? WHERE Id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setNString(1, c.getFullName());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getIdCard());
            ps.setInt(5, c.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Xóa khách hàng
    public void deleteCustomer(int id) {
        String sql = "DELETE FROM Customers WHERE Id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Customer findByPhone(String phone) {
        String query = "SELECT * FROM Customers WHERE phone = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer();
                    customer.setId(rs.getInt("id"));
                    customer.setFullName(rs.getString("full_name")); // Kiểm tra tên cột cho khớp với DB của bạn
                    customer.setPhone(rs.getString("phone"));
                    customer.setEmail(rs.getString("email"));
                    customer.setIdCard(rs.getString("id_card"));
                    return customer;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
