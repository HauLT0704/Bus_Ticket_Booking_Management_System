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
import model.Route;

/**
 *
 * @author Nguyễn Tấn Phát (TV2)
 */
public class RouteDAO extends DBContext {

    //C
    public int create(Route route) {
        try {
            String sql = "INSERT INTO Routes (FromLocationId, ToLocationId, Distance, Duration) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, route.getFromLocation() != null ? route.getFromLocation().getId() : 0);
            ps.setInt(2, route.getToLocation() != null ? route.getToLocation().getId() : 0);
            ps.setDouble(3, route.getDistance());
            ps.setInt(4, route.getDuration());
            return ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(RouteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    //R
    public List<Route> getList() {
        List<Route> result = new ArrayList<>();
        try {
            String sql = "SELECT r.Id, r.Distance, r.Duration, r.CreatedAt, "
                    + "l1.Id AS FromId, l1.Name AS FromName, "
                    + "l2.Id AS ToId, l2.Name AS ToName "
                    + "FROM Routes r "
                    + "JOIN Locations l1 ON r.FromLocationId = l1.Id "
                    + "JOIN Locations l2 ON r.ToLocationId = l2.Id "
                    + "ORDER BY r.Id";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Tạo các đối tượng lồng nhau (Aggregation)
                Location fromLoc = new Location(rs.getInt("FromId"), rs.getString("FromName"));
                Location toLoc = new Location(rs.getInt("ToId"), rs.getString("ToName"));

                Route route = new Route(
                        rs.getInt("Id"),
                        rs.getDouble("Distance"),
                        rs.getInt("Duration"),
                        rs.getTimestamp("CreatedAt"),
                        fromLoc,
                        toLoc
                );

                result.add(route);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RouteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public Route getById(int id) {
        try {
            String sql = "SELECT r.*, l1.Name AS FromName, l2.Name AS ToName "
                    + "FROM Routes r "
                    + "LEFT JOIN Locations l1 ON r.FromLocationId = l1.Id "
                    + "LEFT JOIN Locations l2 ON r.ToLocationId = l2.Id "
                    + "WHERE r.Id = ?";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Location fromLoc = new Location(rs.getInt("FromLocationId"), rs.getString("FromName"));
                Location toLoc = new Location(rs.getInt("ToLocationId"), rs.getString("ToName"));

                Route route = new Route(
                        rs.getInt("Id"),
                        rs.getDouble("Distance"),
                        rs.getInt("Duration"),
                        rs.getTimestamp("CreatedAt"),
                        fromLoc,
                        toLoc
                );
                return route;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RouteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    //U
    public void update(Route route) {
        try {
            String sql = "UPDATE Routes SET FromLocationId = ?, ToLocationId = ?, Distance = ?, Duration = ? WHERE Id = ?";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, route.getFromLocation() != null ? route.getFromLocation().getId() : 0);
            ps.setInt(2, route.getToLocation() != null ? route.getToLocation().getId() : 0);
            ps.setDouble(3, route.getDistance());
            ps.setInt(4, route.getDuration());
            ps.setInt(5, route.getId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RouteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    //D
    public void delete(int id) {
        try {
            String sql = "DELETE FROM Routes WHERE Id = ?";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RouteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
}
