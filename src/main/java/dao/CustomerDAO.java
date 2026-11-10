package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

/**
 * DAO Quản lý Khách hàng
 * Phân công: Phan Thanh Tu (TV3)
 */
public class CustomerDAO extends DBContext {

    // 1. Lấy tất cả khách hàng (liên kết với tài khoản Users nếu có)
    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT c.Id, c.FullName, c.Phone, c.Email, c.IdCard, "
                   + "       u.Id AS UserId, u.Username, u.Status AS UserStatus, u.FullName AS UserFullName "
                   + "FROM Customers c "
                   + "LEFT JOIN Users u ON (c.Phone = u.Phone AND u.Phone != '') "
                   + "ORDER BY c.Id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int uId = rs.getInt("UserId");
                Integer userId = rs.wasNull() ? null : uId;
                Customer c = new Customer(
                        rs.getInt("Id"),
                        rs.getNString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Email"),
                        rs.getString("IdCard"),
                        userId,
                        rs.getString("Username"),
                        rs.getString("UserStatus")
                );
                c.setUserFullName(rs.getNString("UserFullName"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Tìm kiếm khách hàng theo tên, số điện thoại hoặc username tài khoản (TV3)
    public List<Customer> searchCustomers(String keyword) {
        List<Customer> list = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllCustomers();
        }
        String sql = "SELECT c.Id, c.FullName, c.Phone, c.Email, c.IdCard, "
                   + "       u.Id AS UserId, u.Username, u.Status AS UserStatus, u.FullName AS UserFullName "
                   + "FROM Customers c "
                   + "LEFT JOIN Users u ON (c.Phone = u.Phone AND u.Phone != '') "
                   + "WHERE c.FullName LIKE ? OR c.Phone LIKE ? OR c.Email LIKE ? OR c.IdCard LIKE ? OR u.Username LIKE ? "
                   + "ORDER BY c.Id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword.trim() + "%";
            ps.setNString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            ps.setString(5, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int uId = rs.getInt("UserId");
                    Integer userId = rs.wasNull() ? null : uId;
                    Customer c = new Customer(
                            rs.getInt("Id"),
                            rs.getNString("FullName"),
                            rs.getString("Phone"),
                            rs.getString("Email"),
                            rs.getString("IdCard"),
                            userId,
                            rs.getString("Username"),
                            rs.getString("UserStatus")
                    );
                    c.setUserFullName(rs.getNString("UserFullName"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Lấy khách hàng theo ID (dùng cho chức năng Sửa)
    public Customer getCustomerById(int id) {
        String sql = "SELECT c.Id, c.FullName, c.Phone, c.Email, c.IdCard, "
                   + "       u.Id AS UserId, u.Username, u.Status AS UserStatus, u.FullName AS UserFullName "
                   + "FROM Customers c "
                   + "LEFT JOIN Users u ON (c.Phone = u.Phone AND u.Phone != '') "
                   + "WHERE c.Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int uId = rs.getInt("UserId");
                    Integer userId = rs.wasNull() ? null : uId;
                    Customer c = new Customer(
                            rs.getInt("Id"),
                            rs.getNString("FullName"),
                            rs.getString("Phone"),
                            rs.getString("Email"),
                            rs.getString("IdCard"),
                            userId,
                            rs.getString("Username"),
                            rs.getString("UserStatus")
                    );
                    c.setUserFullName(rs.getNString("UserFullName"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 4. Thêm khách hàng mới
    public void insertCustomer(Customer c) {
        String sql = "INSERT INTO Customers (FullName, Phone, Email, IdCard) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, c.getFullName());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getIdCard());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Cập nhật thông tin khách hàng
    public void updateCustomer(Customer c) {
        String sql = "UPDATE Customers SET FullName = ?, Phone = ?, Email = ?, IdCard = ? WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

    // 6. Xóa khách hàng (trả về true nếu xóa thành công, false nếu khách đã có vé)
    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM Customers WHERE Id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 7. Tìm khách hàng theo số điện thoại chuẩn CSDL
    public Customer findByPhone(String phone) {
        String query = "SELECT * FROM Customers WHERE Phone = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            String phoneParam = "";
            if (phone != null) {
                phoneParam = phone.trim();
            }
            ps.setString(1, phoneParam);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("Id"),
                            rs.getNString("FullName"),
                            rs.getString("Phone"),
                            rs.getString("Email"),
                            rs.getString("IdCard")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 8. Kiểm tra trùng số điện thoại khách hàng khi Thêm / Sửa
    public boolean existsByPhone(String phone, int excludeId) {
        if (phone == null) {
            return false;
        }
        String sql = "SELECT Id FROM Customers WHERE LTRIM(RTRIM(Phone)) = LTRIM(RTRIM(?)) AND Id != ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone.trim());
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
