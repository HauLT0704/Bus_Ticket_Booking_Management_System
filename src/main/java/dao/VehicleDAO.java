package dao; // Hoặc package dao; tùy theo dự án của bạn

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Vehicle;

/**
 * @author Phan Thanh Tu (TV3)
 */
public class VehicleDAO extends DBContext {

    // 1. Lấy tất cả danh sách xe
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM Vehicles";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vehicle v = new Vehicle(
                        rs.getInt("Id"),
                        rs.getString("LicensePlate"),
                        rs.getInt("TotalSeats"),
                        rs.getString("Type"),
                        rs.getString("Status")
                );
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   // 2. Lấy xe theo ID
    public Vehicle getVehicleById(int id) {
        String sql = "SELECT * FROM Vehicles WHERE Id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Vehicle(
                    rs.getInt("Id"),
                    rs.getString("LicensePlate"),
                    rs.getInt("TotalSeats"),
                    rs.getString("Type"),
                    rs.getString("Status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Thêm xe mới
    public void insertVehicle(Vehicle v) {
        String sql = "INSERT INTO Vehicles (LicensePlate, TotalSeats, Type, Status) VALUES (?, ?, ?, ?)";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, v.getLicensePlate());
            ps.setInt(2, v.getTotalSeats());
            ps.setNString(3, v.getType());
            ps.setNString(4, v.getStatus());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Cập nhật xe
    public void updateVehicle(Vehicle v) {
        String sql = "UPDATE Vehicles SET LicensePlate = ?, TotalSeats = ?, Type = ?, Status = ? WHERE Id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, v.getLicensePlate());
            ps.setInt(2, v.getTotalSeats());
            ps.setNString(3, v.getType());
            ps.setNString(4, v.getStatus());
            ps.setInt(5, v.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. Xóa xe
    public void deleteVehicle(int id) {
        String sql = "DELETE FROM Vehicles WHERE Id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}