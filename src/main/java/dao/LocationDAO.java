package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Location;

/**
 * @author Lâm Trung Hậu (TV1)
 */
public class LocationDAO extends DBContext {

    // 1. Lấy danh sách tất cả tỉnh / thành phố (mới nhất lên đầu)
    public List<Location> getAll() {
        List<Location> list = new ArrayList<>();
        try {
            String sql = "SELECT Id, Name, CreatedAt FROM Locations ORDER BY Id DESC";
            PreparedStatement statement = getConnection().prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                list.add(new Location(
                    rs.getInt("Id"), 
                    rs.getString("Name"), 
                    rs.getTimestamp("CreatedAt")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy 1 tỉnh theo Id
    public Location getById(int id) {
        try {
            String sql = "SELECT Id, Name, CreatedAt FROM Locations WHERE Id = ?";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Location(
                    rs.getInt("Id"), 
                    rs.getString("Name"), 
                    rs.getTimestamp("CreatedAt")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Thêm mới tỉnh thành
    public boolean insert(Location loc) {
        String sql = "INSERT INTO Locations (Name) VALUES (?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, loc.getName());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Cập nhật tên tỉnh thành
    public boolean update(Location loc) {
        String sql = "UPDATE Locations SET Name = ? WHERE Id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, loc.getName());
            ps.setInt(2, loc.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 5. Xóa tỉnh thành (xóa sạch ràng buộc chuyến và tuyến liên quan để không bị lỗi khóa ngoại)
    public boolean delete(int id) {
        try {
            // Xóa vé của các chuyến thuộc tuyến này
            String delTickets = "DELETE FROM Tickets WHERE TripId IN (SELECT Id FROM Trips WHERE RouteId IN (SELECT Id FROM Routes WHERE FromLocationId = ? OR ToLocationId = ?))";
            PreparedStatement ps1 = getConnection().prepareStatement(delTickets);
            ps1.setInt(1, id);
            ps1.setInt(2, id);
            ps1.executeUpdate();

            // Xóa chuyến thuộc các tuyến này
            String delTrips = "DELETE FROM Trips WHERE RouteId IN (SELECT Id FROM Routes WHERE FromLocationId = ? OR ToLocationId = ?)";
            PreparedStatement ps2 = getConnection().prepareStatement(delTrips);
            ps2.setInt(1, id);
            ps2.setInt(2, id);
            ps2.executeUpdate();

            // Xóa tuyến đường liên quan
            String delRoutes = "DELETE FROM Routes WHERE FromLocationId = ? OR ToLocationId = ?";
            PreparedStatement ps3 = getConnection().prepareStatement(delRoutes);
            ps3.setInt(1, id);
            ps3.setInt(2, id);
            ps3.executeUpdate();

            // Cuối cùng xóa địa điểm
            String sql = "DELETE FROM Locations WHERE Id = ?";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}