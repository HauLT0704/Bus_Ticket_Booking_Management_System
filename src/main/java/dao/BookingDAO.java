package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Ticket;

/**
 * DAO xử lý đặt vé xe
 * Phân công: Huỳnh Nhất Bảo (TV4)
 */
public class BookingDAO extends DBContext {

    /**
     * Lấy danh sách số ghế đã được đặt theo chuyến xe
     * @param tripId mã chuyến xe
     * @return danh sách chuỗi số ghế đã đặt
     */
    public List<String> getBookedSeats(int tripId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT SeatNumber FROM Tickets WHERE TripId = ? AND Status != N'Đã hủy'";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("SeatNumber").trim().toUpperCase());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm vé mới vào hệ thống
     * @param t đối tượng Ticket cần lưu
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean insert(Ticket t) {
        String sql = "INSERT INTO Tickets (TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice) \n"
                + "VALUES (?, ?, ?, GETDATE(), ?, ?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, t.getTripId());
            ps.setInt(2, t.getCustomerId());
            ps.setString(3, t.getSeatNumber());
            ps.setString(4, t.getStatus() != null ? t.getStatus() : "Đã thanh toán");
            ps.setDouble(5, t.getTotalPrice());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    t.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách vé đã đặt theo mã khách hàng
     * @param customerId mã khách hàng
     * @return danh sách vé của khách hàng
     */
    public List<Ticket> getByCustomer(int customerId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT Id, TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice \n"
                + "FROM Tickets WHERE CustomerId = ? ORDER BY BookingTime DESC";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Ticket(
                        rs.getInt("Id"),
                        rs.getInt("TripId"),
                        rs.getInt("CustomerId"),
                        rs.getString("SeatNumber"),
                        rs.getTimestamp("BookingTime"),
                        rs.getString("Status"),
                        rs.getDouble("TotalPrice")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin 1 vé theo mã vé (Ticket Id)
     * @param id mã vé
     * @return đối tượng Ticket
     */
    public Ticket getById(int id) {
        String sql = "SELECT Id, TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice \n"
                + "FROM Tickets WHERE Id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Ticket(
                        rs.getInt("Id"),
                        rs.getInt("TripId"),
                        rs.getInt("CustomerId"),
                        rs.getString("SeatNumber"),
                        rs.getTimestamp("BookingTime"),
                        rs.getString("Status"),
                        rs.getDouble("TotalPrice")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========================================================
    // CÁC HÀM TIỆN ÍCH HỖ TRỢ XỬ LÝ ĐẶT VÉ VÀ TÌM KIẾM CỦA TV4
    // (Được đặt trong BookingDAO để không can thiệp code người khác)
    // ========================================================

    /**
     * Tìm khách hàng theo SĐT, nếu chưa có thì tự động tạo mới để liên kết khóa ngoại với Tickets
     */
    public int getOrCreateCustomer(String fullName, String phone, String email, String idCard) {
        String selectSql = "SELECT Id FROM Customers WHERE Phone = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(selectSql);
            ps.setString(1, phone.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("Id");
            }

            String insertSql = "INSERT INTO Customers (FullName, Phone, Email, IdCard) VALUES (?, ?, ?, ?)";
            PreparedStatement insertPs = getConnection().prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            insertPs.setString(1, fullName != null ? fullName.trim() : "Khách hàng");
            insertPs.setString(2, phone.trim());
            insertPs.setString(3, email != null ? email.trim() : "");
            insertPs.setString(4, idCard != null ? idCard.trim() : "");
            insertPs.executeUpdate();
            ResultSet gen = insertPs.getGeneratedKeys();
            if (gen.next()) {
                return gen.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1; // Default fallback
    }

    /**
     * Lấy giá vé và thông tin cơ bản của một chuyến xe
     */
    public Map<String, Object> getTripDetails(int tripId) {
        Map<String, Object> map = new HashMap<>();
        String sql = "SELECT t.Id, t.Price, t.DepartureTime, t.ArrivalTime, t.AvailableSeats, \n"
                + "       fl.Name AS FromName, tl.Name AS ToName, \n"
                + "       v.LicensePlate, v.Type AS VehicleType \n"
                + "FROM Trips t \n"
                + "JOIN Routes r ON t.RouteId = r.Id \n"
                + "JOIN Locations fl ON r.FromLocationId = fl.Id \n"
                + "JOIN Locations tl ON r.ToLocationId = tl.Id \n"
                + "JOIN Vehicles v ON t.VehicleId = v.Id \n"
                + "WHERE t.Id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, tripId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                map.put("id", rs.getInt("Id"));
                map.put("price", rs.getDouble("Price"));
                map.put("departureTime", rs.getTimestamp("DepartureTime"));
                map.put("arrivalTime", rs.getTimestamp("ArrivalTime"));
                map.put("availableSeats", rs.getInt("AvailableSeats"));
                map.put("fromLocationName", rs.getString("FromName"));
                map.put("toLocationName", rs.getString("ToName"));
                map.put("vehiclePlate", rs.getString("LicensePlate"));
                map.put("vehicleType", rs.getString("VehicleType"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * Tìm danh sách các chuyến xe phục vụ màn hình search.jsp của TV4
     */
    public List<Map<String, Object>> searchTrips(String from, String to, String date, int guests) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.Id, t.Price, t.DepartureTime, t.ArrivalTime, t.AvailableSeats, \n"
                + "       fl.Name AS FromName, tl.Name AS ToName, r.Distance, r.Duration, \n"
                + "       v.LicensePlate, v.Type AS VehicleType \n"
                + "FROM Trips t \n"
                + "JOIN Routes r ON t.RouteId = r.Id \n"
                + "JOIN Locations fl ON r.FromLocationId = fl.Id \n"
                + "JOIN Locations tl ON r.ToLocationId = tl.Id \n"
                + "JOIN Vehicles v ON t.VehicleId = v.Id \n"
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (from != null && !from.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(from.trim())) {
            sql.append(" AND (fl.Name LIKE ? OR fl.Province LIKE ?) ");
            params.add("%" + from.trim() + "%");
            params.add("%" + from.trim() + "%");
        }
        if (to != null && !to.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(to.trim())) {
            sql.append(" AND (tl.Name LIKE ? OR tl.Province LIKE ?) ");
            params.add("%" + to.trim() + "%");
            params.add("%" + to.trim() + "%");
        }
        if (date != null && !date.trim().isEmpty()) {
            sql.append(" AND CONVERT(VARCHAR(10), t.DepartureTime, 120) = ? ");
            params.add(date.trim());
        }
        if (guests > 0) {
            sql.append(" AND t.AvailableSeats >= ? ");
            params.add(guests);
        }
        sql.append(" ORDER BY t.DepartureTime ASC");

        try {
            PreparedStatement ps = getConnection().prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("Id"));
                map.put("price", rs.getDouble("Price"));
                map.put("departureTime", rs.getTimestamp("DepartureTime"));
                map.put("arrivalTime", rs.getTimestamp("ArrivalTime"));
                map.put("availableSeats", rs.getInt("AvailableSeats"));
                map.put("fromLocationName", rs.getString("FromName"));
                map.put("toLocationName", rs.getString("ToName"));
                map.put("distance", rs.getDouble("Distance"));
                map.put("duration", rs.getInt("Duration"));
                map.put("vehiclePlate", rs.getString("LicensePlate"));
                map.put("vehicleType", rs.getString("VehicleType"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cập nhật số ghế trống sau khi đặt vé
     */
    public boolean updateAvailableSeats(int tripId, int seatCount) {
        String sql = "UPDATE Trips SET AvailableSeats = AvailableSeats - ? WHERE Id = ? AND AvailableSeats >= ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, seatCount);
            ps.setInt(2, tripId);
            ps.setInt(3, seatCount);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
