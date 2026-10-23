/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Location;

/**
 *
 * @author Lâm Trung Hậu (TV1)
 */
public class LocationDAO extends DBContext {

    public List<Location> getAll() {
        List<Location> list = new ArrayList<>();
        try {
            String sql = "SELECT Id, Name, Province, CreatedAt FROM Locations ORDER BY Id DESC";
            PreparedStatement statement = getConnection().prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                list.add(new Location(rs.getInt("Id"), rs.getString("Name"), rs.getString("Province"), rs.getTimestamp("CreatedAt")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Location getById(int id) {
        try {
            String sql = "Select Id, Name, Province, CreatedAt From Locations Where Id = ? ";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Location(rs.getInt("Id"), rs.getString("Name"), rs.getString("Province"), rs.getTimestamp("CreatedAt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Location loc) {
        String sql = "Insert Into Locations (Name, Province) Values(?,?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, loc.getName());
            ps.setString(2, loc.getProvince());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Location loc) {
        String sql = "UPDATE Locations SET Name = ?, Province = ? WHERE Id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, loc.getName());
            ps.setString(2, loc.getProvince());
            ps.setInt(3, loc.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "Delete From Locations Where Id = ?";
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
