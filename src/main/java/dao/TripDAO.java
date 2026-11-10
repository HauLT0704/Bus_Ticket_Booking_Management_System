package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Location;
import model.Route;
import model.Trip;
import model.Vehicle;

/**
 * Phân công: Nguyễn Tấn Phát (TV2)
 */
public class TripDAO extends DBContext {

    // C - Tạo chuyến xe mới
    public int create(Trip trip) {
        try {
            String sql = "INSERT INTO Trips (RouteId, VehicleId, DepartureTime, ArrivalTime, AvailableSeats, Price, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            int routeId = 0;
            if (trip.getRoute() != null) {
                routeId = trip.getRoute().getId();
            }
            int vehicleId = 0;
            if (trip.getVehicle() != null) {
                vehicleId = trip.getVehicle().getId();
            }
            ps.setInt(1, routeId);
            ps.setInt(2, vehicleId);
            ps.setTimestamp(3, trip.getDepartureTime());
            ps.setTimestamp(4, trip.getArrivalTime());
            ps.setInt(5, trip.getAvailableSeats());
            ps.setDouble(6, trip.getPrice());
            ps.setString(7, trip.getStatus());
            return ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // R - Lấy danh sách tất cả chuyến xe
    public List<Trip> getList() {
        List<Trip> result = new ArrayList<>();
        try {
            String sql = "SELECT t.*, v.LicensePlate, "
                    + "r.Distance, r.Duration, "
                    + "l1.Id AS FromId, l1.Name AS FromName, "
                    + "l2.Id AS ToId, l2.Name AS ToName "
                    + "FROM Trips t "
                    + "JOIN Vehicles v ON t.VehicleId = v.Id "
                    + "JOIN Routes r ON t.RouteId = r.Id "
                    + "JOIN Locations l1 ON r.FromLocationId = l1.Id "
                    + "JOIN Locations l2 ON r.ToLocationId = l2.Id "
                    + "ORDER BY t.Id DESC";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("VehicleId"));
                vehicle.setLicensePlate(rs.getString("LicensePlate"));

                model.Location fromLoc = new model.Location(rs.getInt("FromId"), rs.getString("FromName"));
                model.Location toLoc = new model.Location(rs.getInt("ToId"), rs.getString("ToName"));

                Route route = new Route(
                        rs.getInt("RouteId"),
                        rs.getDouble("Distance"),
                        rs.getInt("Duration"),
                        null,
                        fromLoc,
                        toLoc
                );

                Trip trip = new Trip(
                        rs.getInt("Id"),
                        rs.getTimestamp("DepartureTime"),
                        rs.getTimestamp("ArrivalTime"),
                        rs.getInt("AvailableSeats"),
                        rs.getDouble("Price"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        route,
                        vehicle
                );

                result.add(trip);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    public Trip getById(int id) {
        try {
            String sql = "SELECT t.*, v.LicensePlate FROM Trips t "
                    + "LEFT JOIN Vehicles v ON t.VehicleId = v.Id "
                    + "WHERE t.Id = ?";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("VehicleId"));
                vehicle.setLicensePlate(rs.getString("LicensePlate"));

                Route route = new Route();
                route.setId(rs.getInt("RouteId"));

                Trip trip = new Trip(
                        rs.getInt("Id"),
                        rs.getTimestamp("DepartureTime"),
                        rs.getTimestamp("ArrivalTime"),
                        rs.getInt("AvailableSeats"),
                        rs.getDouble("Price"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        route,
                        vehicle
                );
                return trip;
            }
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Hàm searchTrips theo mô hình đối tượng lồng nhau (cho thành viên thứ 4 gọi)
    public List<Trip> searchTrips(int fromLocationId, int toLocationId, String date, int guests) {
        List<Trip> result = new ArrayList<>();
        try {
            String sql = "SELECT t.*, v.LicensePlate, "
                    + "r.Distance, r.Duration, "
                    + "l1.Id AS FromId, l1.Name AS FromName, "
                    + "l2.Id AS ToId, l2.Name AS ToName "
                    + "FROM Trips t "
                    + "JOIN Vehicles v ON t.VehicleId = v.Id "
                    + "JOIN Routes r ON t.RouteId = r.Id "
                    + "JOIN Locations l1 ON r.FromLocationId = l1.Id "
                    + "JOIN Locations l2 ON r.ToLocationId = l2.Id "
                    + "WHERE r.FromLocationId = ? AND r.ToLocationId = ? "
                    + "AND CAST(t.DepartureTime AS DATE) = ? "
                    + "AND t.AvailableSeats >= ? "
                    + "AND (t.Status != N'Đã hủy' AND t.Status != N'Hoàn thành')";

            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, fromLocationId);
            ps.setInt(2, toLocationId);
            ps.setString(3, date);
            ps.setInt(4, guests);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("VehicleId"));
                vehicle.setLicensePlate(rs.getString("LicensePlate"));

                Location fromLoc = new Location(rs.getInt("FromId"), rs.getString("FromName"));
                Location toLoc = new Location(rs.getInt("ToId"), rs.getString("ToName"));

                Route route = new Route(
                        rs.getInt("RouteId"),
                        rs.getDouble("Distance"),
                        rs.getInt("Duration"),
                        null,
                        fromLoc,
                        toLoc
                );

                Trip trip = new Trip(
                        rs.getInt("Id"),
                        rs.getTimestamp("DepartureTime"),
                        rs.getTimestamp("ArrivalTime"),
                        rs.getInt("AvailableSeats"),
                        rs.getDouble("Price"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        route,
                        vehicle
                );

                result.add(trip);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    // U - Cập nhật chuyến xe
    public void update(Trip trip) {
        try {
            String sql = "UPDATE Trips SET RouteId = ?, VehicleId = ?, DepartureTime = ?, ArrivalTime = ?, AvailableSeats = ?, Price = ?, Status = ? WHERE Id = ?";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            int routeId = 0;
            if (trip.getRoute() != null) {
                routeId = trip.getRoute().getId();
            }
            int vehicleId = 0;
            if (trip.getVehicle() != null) {
                vehicleId = trip.getVehicle().getId();
            }
            ps.setInt(1, routeId);
            ps.setInt(2, vehicleId);
            ps.setTimestamp(3, trip.getDepartureTime());
            ps.setTimestamp(4, trip.getArrivalTime());
            ps.setInt(5, trip.getAvailableSeats());
            ps.setDouble(6, trip.getPrice());
            ps.setString(7, trip.getStatus());
            ps.setInt(8, trip.getId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // D - Xóa chuyến xe
    public boolean delete(int id) {
        try {
            String sql = "DELETE FROM Trips WHERE Id = ?";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Hàm phụ trợ
    public List<Route> getAllRoutes() {
        List<Route> list = new ArrayList<>();
        try {
            String sql = "SELECT r.Id, r.Distance, l1.Id AS FromId, l1.Name AS FromName, l2.Id AS ToId, l2.Name AS ToName "
                    + "FROM Routes r "
                    + "JOIN Locations l1 ON r.FromLocationId = l1.Id "
                    + "JOIN Locations l2 ON r.ToLocationId = l2.Id "
                    + "ORDER BY r.Id";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Location fromLoc = new Location(rs.getInt("FromId"), rs.getString("FromName"));
                Location toLoc = new Location(rs.getInt("ToId"), rs.getString("ToName"));

                Route route = new Route();
                route.setId(rs.getInt("Id"));
                route.setDistance(rs.getDouble("Distance"));
                route.setFromLocation(fromLoc);
                route.setToLocation(toLoc);
                list.add(route);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        try {
            String sql = "SELECT Id, LicensePlate, TotalSeats, Type, Status FROM Vehicles ORDER BY Id";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("Id"));
                vehicle.setLicensePlate(rs.getString("LicensePlate"));
                vehicle.setTotalSeats(rs.getInt("TotalSeats"));
                vehicle.setType(rs.getString("Type"));
                vehicle.setStatus(rs.getString("Status"));
                list.add(vehicle);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy tổng số ghế tối đa của chiếc xe được chọn
    public int getVehicleMaxSeats(int vehicleId) {
        try {
            String sql = "SELECT TotalSeats FROM Vehicles WHERE Id = ?";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, vehicleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("TotalSeats");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TripDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 59;
    }

    /**
     * Kiểm tra xe khách có bị trùng khoảng thời gian chạy với chuyến khác không
     * Khoảng thời gian: (Khởi hành -> Tới nơi)
     */
    public boolean isVehicleScheduleConflict(int vehicleId, Timestamp depTime, Timestamp arrTime, int excludeTripId) {
        if (vehicleId <= 0 || depTime == null || arrTime == null) return false;
        String sql = "SELECT COUNT(*) FROM Trips WHERE VehicleId = ? AND Status != N'Đã hủy' "
                   + "AND Id != ? AND DepartureTime < ? AND ArrivalTime > ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            ps.setInt(2, excludeTripId);
            ps.setTimestamp(3, arrTime);
            ps.setTimestamp(4, depTime);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
