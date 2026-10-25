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

    // 5. Xóa tỉnh thành
    public boolean delete(int id) {
        String sql = "DELETE FROM Locations WHERE Id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}