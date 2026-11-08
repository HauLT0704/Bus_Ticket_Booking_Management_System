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
            if (t.getStatus() != null) {
                ps.setString(4, t.getStatus());
            } else {
                ps.setString(4, "Đã thanh toán");
            }
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
            if (fullName != null) {
                insertPs.setString(1, fullName.trim());
            } else {
                insertPs.setString(1, "Khách hàng");
            }
            insertPs.setString(2, phone.trim());
            if (email != null) {
                insertPs.setString(3, email.trim());
            } else {
                insertPs.setString(3, "");
            }
            if (idCard != null) {
                insertPs.setString(4, idCard.trim());
            } else {
                insertPs.setString(4, "");
            }
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
     * Lấy giá vé, tổng số ghế của xe và thông tin cơ bản của một chuyến xe
     */
    public Map<String, Object> getTripDetails(int tripId) {
        Map<String, Object> map = new HashMap<>();
        String sql = "SELECT t.Id, t.Price, t.DepartureTime, t.ArrivalTime, t.AvailableSeats, t.Status, \n"
                + "       fl.Name AS FromName, tl.Name AS ToName, \n"
                + "       v.LicensePlate, v.Type AS VehicleType, v.TotalSeats \n"
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
                int totalSeats = rs.getInt("TotalSeats");
                if (totalSeats <= 0) {
                    totalSeats = 34;
                }
                int halfSeats = (totalSeats + 1) / 2;
                int secondDeckSeats = totalSeats - halfSeats;

                map.put("id", rs.getInt("Id"));
                map.put("price", rs.getDouble("Price"));
                map.put("departureTime", rs.getTimestamp("DepartureTime"));
                map.put("arrivalTime", rs.getTimestamp("ArrivalTime"));
                map.put("availableSeats", rs.getInt("AvailableSeats"));
                map.put("status", rs.getString("Status"));
                map.put("fromLocationName", rs.getString("FromName"));
                map.put("toLocationName", rs.getString("ToName"));
                map.put("vehiclePlate", rs.getString("LicensePlate"));
                map.put("vehicleType", rs.getString("VehicleType"));
                map.put("totalSeats", totalSeats);
                map.put("halfSeats", halfSeats);
                map.put("secondDeckSeats", secondDeckSeats);
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
                + "WHERE (t.Status != N'Đã hủy' AND t.Status != N'Hoàn thành') "
        );

        List<Object> params = new ArrayList<>();
        if (from != null && !from.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(from.trim())) {
            sql.append(" AND fl.Name LIKE ? ");
            params.add("%" + from.trim() + "%");
        }
        if (to != null && !to.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(to.trim())) {
            sql.append(" AND tl.Name LIKE ? ");
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
     * Tìm các cặp chuyến xe ghép (nối 2 chặng) hoặc ghép tuyến dài đi ngang qua khi chuyến thẳng hết ghế (TV4 tích hợp)
     */
    public List<Map<String, Object>> searchTransferTrips(String from, String to, String date, int guests) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (from == null || from.trim().isEmpty() || to == null || to.trim().isEmpty()) {
            return list;
        }
        int minSeats = 1;
        if (guests > 1) {
            minSeats = guests;
        }

        // 1. Tìm các cặp nối 2 chặng (Điểm đi -> Điểm trung chuyển -> Điểm đến)
        StringBuilder sql = new StringBuilder(
                "SELECT t1.Id AS Trip1_Id, t1.DepartureTime AS Trip1_Dep, t1.ArrivalTime AS Trip1_Arr, \n"
                + "       t1.Price AS Trip1_Price, t1.AvailableSeats AS Trip1_Seats, \n"
                + "       v1.LicensePlate AS Trip1_Plate, v1.Type AS Trip1_Type, \n"
                + "       fl1.Name AS FromName, tl1.Name AS MidName, \n"
                + "       t2.Id AS Trip2_Id, t2.DepartureTime AS Trip2_Dep, t2.ArrivalTime AS Trip2_Arr, \n"
                + "       t2.Price AS Trip2_Price, t2.AvailableSeats AS Trip2_Seats, \n"
                + "       v2.LicensePlate AS Trip2_Plate, v2.Type AS Trip2_Type, \n"
                + "       tl2.Name AS ToName, \n"
                + "       (t1.Price + t2.Price) AS TotalPrice \n"
                + "FROM Trips t1 \n"
                + "JOIN Routes r1 ON t1.RouteId = r1.Id \n"
                + "JOIN Locations fl1 ON r1.FromLocationId = fl1.Id \n"
                + "JOIN Locations tl1 ON r1.ToLocationId = tl1.Id \n"
                + "JOIN Vehicles v1 ON t1.VehicleId = v1.Id \n"
                + "JOIN Routes r2 ON tl1.Id = r2.FromLocationId \n"
                + "JOIN Trips t2 ON t2.RouteId = r2.Id \n"
                + "JOIN Locations tl2 ON r2.ToLocationId = tl2.Id \n"
                + "JOIN Vehicles v2 ON t2.VehicleId = v2.Id \n"
                + "WHERE fl1.Name LIKE ? AND tl2.Name LIKE ? \n"
                + "  AND t1.AvailableSeats >= ? AND t2.AvailableSeats >= ? \n"
                + "  AND (t1.Status != N'Đã hủy' AND t1.Status != N'Hoàn thành') \n"
                + "  AND (t2.Status != N'Đã hủy' AND t2.Status != N'Hoàn thành') \n"
                + "  AND t2.DepartureTime >= DATEADD(MINUTE, 15, t1.ArrivalTime) \n"
                + "  AND t2.DepartureTime <= DATEADD(HOUR, 12, t1.ArrivalTime) \n"
        );

        List<Object> params = new ArrayList<>();
        params.add("%" + from.trim() + "%");
        params.add("%" + to.trim() + "%");
        params.add(minSeats);
        params.add(minSeats);

        if (date != null && !date.trim().isEmpty()) {
            sql.append("  AND CONVERT(VARCHAR(10), t1.DepartureTime, 120) = ? \n");
            params.add(date.trim());
        }

        sql.append(" ORDER BY t1.DepartureTime ASC");

        try {
            PreparedStatement ps = getConnection().prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("transferType", "two_legs");
                map.put("trip1Id", rs.getInt("Trip1_Id"));
                map.put("trip1Dep", rs.getTimestamp("Trip1_Dep"));
                map.put("trip1Arr", rs.getTimestamp("Trip1_Arr"));
                map.put("trip1Price", rs.getDouble("Trip1_Price"));
                map.put("trip1Seats", rs.getInt("Trip1_Seats"));
                map.put("trip1Plate", rs.getString("Trip1_Plate"));
                map.put("trip1Type", rs.getString("Trip1_Type"));
                map.put("fromName", rs.getString("FromName"));
                map.put("midName", rs.getString("MidName"));

                map.put("trip2Id", rs.getInt("Trip2_Id"));
                map.put("trip2Dep", rs.getTimestamp("Trip2_Dep"));
                map.put("trip2Arr", rs.getTimestamp("Trip2_Arr"));
                map.put("trip2Price", rs.getDouble("Trip2_Price"));
                map.put("trip2Seats", rs.getInt("Trip2_Seats"));
                map.put("trip2Plate", rs.getString("Trip2_Plate"));
                map.put("trip2Type", rs.getString("Trip2_Type"));
                map.put("toName", rs.getString("ToName"));

                map.put("totalPrice", rs.getDouble("TotalPrice"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2. Gợi ý ghép chuyến tuyến dài đi ngang qua điểm đón (VD: hết ghế Cần Thơ -> TP.HCM, gợi ý ghép chuyến Cà Mau -> TP.HCM hoặc Kiên Giang -> TP.HCM)
        StringBuilder passSql = new StringBuilder(
                "SELECT TOP 5 t.Id AS Trip1_Id, t.DepartureTime AS Trip1_Dep, t.ArrivalTime AS Trip1_Arr, \n"
                + "       t.Price AS Trip1_Price, t.AvailableSeats AS Trip1_Seats, \n"
                + "       v.LicensePlate AS Trip1_Plate, v.Type AS Trip1_Type, \n"
                + "       fl.Name AS OriginName, tl.Name AS ToName \n"
                + "FROM Trips t \n"
                + "JOIN Routes r ON t.RouteId = r.Id \n"
                + "JOIN Locations fl ON r.FromLocationId = fl.Id \n"
                + "JOIN Locations tl ON r.ToLocationId = tl.Id \n"
                + "JOIN Vehicles v ON t.VehicleId = v.Id \n"
                + "WHERE tl.Name LIKE ? AND fl.Name NOT LIKE ? \n"
                + "  AND t.AvailableSeats >= ? \n"
                + "  AND (t.Status != N'Đã hủy' AND t.Status != N'Hoàn thành') \n"
        );
        List<Object> passParams = new ArrayList<>();
        passParams.add("%" + to.trim() + "%");
        passParams.add("%" + from.trim() + "%");
        passParams.add(minSeats);

        if (date != null && !date.trim().isEmpty()) {
            passSql.append("  AND CONVERT(VARCHAR(10), t.DepartureTime, 120) = ? \n");
            passParams.add(date.trim());
        }
        passSql.append(" ORDER BY t.DepartureTime ASC");

        try {
            PreparedStatement ps2 = getConnection().prepareStatement(passSql.toString());
            for (int i = 0; i < passParams.size(); i++) {
                ps2.setObject(i + 1, passParams.get(i));
            }
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("transferType", "pass_through");
                map.put("trip1Id", rs2.getInt("Trip1_Id"));
                map.put("trip1Dep", rs2.getTimestamp("Trip1_Dep"));
                map.put("trip1Arr", rs2.getTimestamp("Trip1_Arr"));
                map.put("trip1Price", rs2.getDouble("Trip1_Price"));
                map.put("trip1Seats", rs2.getInt("Trip1_Seats"));
                map.put("trip1Plate", rs2.getString("Trip1_Plate"));
                map.put("trip1Type", rs2.getString("Trip1_Type"));
                map.put("fromName", rs2.getString("OriginName"));
                map.put("midName", from.trim());
                map.put("toName", rs2.getString("ToName"));
                map.put("totalPrice", rs2.getDouble("Trip1_Price"));
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

    /**
     * Hủy vé và hoàn lại 1 ghế trống cho chuyến xe
     */
    public boolean cancelTicket(int ticketId) {
        Ticket ticket = getById(ticketId);
        if (ticket == null || "Đã hủy".equalsIgnoreCase(ticket.getStatus())) {
            return false;
        }
        String sql = "UPDATE Tickets SET Status = N'Đã hủy' WHERE Id = ? AND Status != N'Đã hủy'";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, ticketId);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                String restoreSeatSql = "UPDATE Trips SET AvailableSeats = AvailableSeats + 1 WHERE Id = ?";
                PreparedStatement psTrip = getConnection().prepareStatement(restoreSeatSql);
                psTrip.setInt(1, ticket.getTripId());
                psTrip.executeUpdate();
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đếm tổng số vé đã hủy của khách hàng (theo CustomerId hoặc SĐT)
     */
    public int countCancelledTickets(int customerId, String phone) {
        String sql = "SELECT COUNT(*) FROM Tickets t "
                + "JOIN Customers c ON t.CustomerId = c.Id "
                + "WHERE t.Status = N'Đã hủy' AND (t.CustomerId = ? OR (c.Phone = ? AND c.Phone != ''))";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, customerId);
            if (phone != null) {
                ps.setString(2, phone.trim());
            } else {
                ps.setString(2, "");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy số điện thoại của khách hàng theo CustomerId
     */
    public String getCustomerPhoneById(int customerId) {
        String sql = "SELECT Phone FROM Customers WHERE Id = ?";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("Phone");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}
