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
     */
    public List<String> getBookedSeats(int tripId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT SeatNumber FROM Tickets WHERE TripId = ? AND Status != N'Đã hủy'";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("SeatNumber").trim().toUpperCase());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm vé mới vào hệ thống
     */
    public boolean insert(Ticket t) {
        String sql = "INSERT INTO Tickets (TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice) VALUES (?, ?, ?, GETDATE(), ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, t.getTripId());
            ps.setInt(2, t.getCustomerId());
            ps.setString(3, t.getSeatNumber());
            ps.setString(4, t.getStatus() != null ? t.getStatus() : "Đã thanh toán");
            ps.setDouble(5, t.getTotalPrice());

            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        t.setId(rs.getInt(1));
                    }
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
     */
    public List<Ticket> getByCustomer(int customerId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT Id, TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice FROM Tickets WHERE CustomerId = ? ORDER BY BookingTime DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin 1 vé theo mã vé (Ticket Id)
     */
    public Ticket getById(int id) {
        String sql = "SELECT Id, TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice FROM Tickets WHERE Id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tìm khách hàng theo SĐT và Họ tên.
     * - Nếu đã có đúng người (trùng cả SĐT và Họ tên): Tái sử dụng ID cũ.
     * - Nếu đổi Họ tên khác (đặt hộ người khác từ tài khoản): THÊM MỚI một bản ghi khách hàng riêng biệt,
     *   tuyệt đối KHÔNG ghi đè / sửa tên của tài khoản gốc.
     */
    public int getOrCreateCustomer(String fullName, String phone, String email, String idCard) {
        String cleanName = (fullName != null && !fullName.trim().isEmpty()) ? fullName.trim() : "Khách hàng";
        String cleanPhone = (phone != null) ? phone.trim() : "";
        String cleanEmail = (email != null) ? email.trim() : "";
        String cleanIdCard = (idCard != null) ? idCard.trim() : "";

        // 1. Kiểm tra xem đã có khách hàng trùng cả Số điện thoại VÀ Họ tên chưa
        String selectSql = "SELECT Id FROM Customers WHERE Phone = ? AND FullName = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(selectSql)) {
            ps.setString(1, cleanPhone);
            ps.setString(2, cleanName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Id"); // Đã có đúng khách hàng này -> lấy Id
                }
            }

            // 2. Nếu là Họ tên mới -> Luôn luôn THÊM MỚI khách hàng (không sửa đè tài khoản cũ)
            String insertSql = "INSERT INTO Customers (FullName, Phone, Email, IdCard) VALUES (?, ?, ?, ?)";
            try (PreparedStatement insertPs = getConnection().prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                insertPs.setString(1, cleanName);
                insertPs.setString(2, cleanPhone);
                insertPs.setString(3, cleanEmail);
                insertPs.setString(4, cleanIdCard);
                insertPs.executeUpdate();
                try (ResultSet gen = insertPs.getGeneratedKeys()) {
                    if (gen.next()) return gen.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1;
    }

    /**
     * Lấy giá vé, tổng số ghế của xe và thông tin cơ bản của một chuyến xe
     */
    public Map<String, Object> getTripDetails(int tripId) {
        Map<String, Object> map = new HashMap<>();
        String sql = "SELECT t.Id, t.Price, t.DepartureTime, t.ArrivalTime, t.AvailableSeats, t.Status, "
                + "       fl.Name AS FromName, tl.Name AS ToName, "
                + "       v.LicensePlate, v.Type AS VehicleType, v.TotalSeats "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteId = r.Id "
                + "JOIN Locations fl ON r.FromLocationId = fl.Id "
                + "JOIN Locations tl ON r.ToLocationId = tl.Id "
                + "JOIN Vehicles v ON t.VehicleId = v.Id "
                + "WHERE t.Id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, tripId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int totalSeats = Math.max(rs.getInt("TotalSeats"), 34);
                    int halfSeats = (totalSeats + 1) / 2;
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
                    map.put("secondDeckSeats", totalSeats - halfSeats);
                }
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
                "SELECT t.Id, t.Price, t.DepartureTime, t.ArrivalTime, t.AvailableSeats, "
                + "       fl.Name AS FromName, tl.Name AS ToName, r.Distance, r.Duration, "
                + "       v.LicensePlate, v.Type AS VehicleType "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteId = r.Id "
                + "JOIN Locations fl ON r.FromLocationId = fl.Id "
                + "JOIN Locations tl ON r.ToLocationId = tl.Id "
                + "JOIN Vehicles v ON t.VehicleId = v.Id "
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

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm các cặp chuyến xe ghép (nối 2 chặng) hoặc ghép tuyến dài đi ngang qua khi chuyến thẳng hết ghế
     */
    public List<Map<String, Object>> searchTransferTrips(String from, String to, String date, int guests) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (from == null || from.trim().isEmpty() || to == null || to.trim().isEmpty()) {
            return list;
        }
        int minSeats = Math.max(1, guests);

        // 1. Tìm các cặp nối 2 chặng (Điểm đi -> Điểm trung chuyển -> Điểm đến)
        StringBuilder sql = new StringBuilder(
                "SELECT t1.Id AS Trip1_Id, t1.DepartureTime AS Trip1_Dep, t1.ArrivalTime AS Trip1_Arr, "
                + "       t1.Price AS Trip1_Price, t1.AvailableSeats AS Trip1_Seats, "
                + "       v1.LicensePlate AS Trip1_Plate, v1.Type AS Trip1_Type, "
                + "       fl1.Name AS FromName, tl1.Name AS MidName, "
                + "       t2.Id AS Trip2_Id, t2.DepartureTime AS Trip2_Dep, t2.ArrivalTime AS Trip2_Arr, "
                + "       t2.Price AS Trip2_Price, t2.AvailableSeats AS Trip2_Seats, "
                + "       v2.LicensePlate AS Trip2_Plate, v2.Type AS Trip2_Type, "
                + "       tl2.Name AS ToName, (t1.Price + t2.Price) AS TotalPrice "
                + "FROM Trips t1 "
                + "JOIN Routes r1 ON t1.RouteId = r1.Id "
                + "JOIN Locations fl1 ON r1.FromLocationId = fl1.Id "
                + "JOIN Locations tl1 ON r1.ToLocationId = tl1.Id "
                + "JOIN Vehicles v1 ON t1.VehicleId = v1.Id "
                + "JOIN Routes r2 ON tl1.Id = r2.FromLocationId "
                + "JOIN Trips t2 ON t2.RouteId = r2.Id "
                + "JOIN Locations tl2 ON r2.ToLocationId = tl2.Id "
                + "JOIN Vehicles v2 ON t2.VehicleId = v2.Id "
                + "WHERE fl1.Name LIKE ? AND tl2.Name LIKE ? "
                + "  AND t1.AvailableSeats >= ? AND t2.AvailableSeats >= ? "
                + "  AND (t1.Status != N'Đã hủy' AND t1.Status != N'Hoàn thành') "
                + "  AND (t2.Status != N'Đã hủy' AND t2.Status != N'Hoàn thành') "
                + "  AND t2.DepartureTime >= DATEADD(MINUTE, 15, t1.ArrivalTime) "
                + "  AND t2.DepartureTime <= DATEADD(HOUR, 12, t1.ArrivalTime) "
        );

        List<Object> params = new ArrayList<>();
        params.add("%" + from.trim() + "%");
        params.add("%" + to.trim() + "%");
        params.add(minSeats);
        params.add(minSeats);

        if (date != null && !date.trim().isEmpty()) {
            sql.append("  AND CONVERT(VARCHAR(10), t1.DepartureTime, 120) = ? ");
            params.add(date.trim());
        }
        sql.append(" ORDER BY t1.DepartureTime ASC");

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2. Gợi ý ghép chuyến tuyến dài đi ngang qua điểm đón
        StringBuilder passSql = new StringBuilder(
                "SELECT TOP 5 t.Id AS Trip1_Id, t.DepartureTime AS Trip1_Dep, t.ArrivalTime AS Trip1_Arr, "
                + "       t.Price AS Trip1_Price, t.AvailableSeats AS Trip1_Seats, "
                + "       v.LicensePlate AS Trip1_Plate, v.Type AS Trip1_Type, "
                + "       fl.Name AS OriginName, tl.Name AS ToName "
                + "FROM Trips t "
                + "JOIN Routes r ON t.RouteId = r.Id "
                + "JOIN Locations fl ON r.FromLocationId = fl.Id "
                + "JOIN Locations tl ON r.ToLocationId = tl.Id "
                + "JOIN Vehicles v ON t.VehicleId = v.Id "
                + "WHERE tl.Name LIKE ? AND fl.Name NOT LIKE ? "
                + "  AND t.AvailableSeats >= ? "
                + "  AND (t.Status != N'Đã hủy' AND t.Status != N'Hoàn thành') "
        );
        List<Object> passParams = new ArrayList<>();
        passParams.add("%" + to.trim() + "%");
        passParams.add("%" + from.trim() + "%");
        passParams.add(minSeats);

        if (date != null && !date.trim().isEmpty()) {
            passSql.append("  AND CONVERT(VARCHAR(10), t.DepartureTime, 120) = ? ");
            passParams.add(date.trim());
        }
        passSql.append(" ORDER BY t.DepartureTime ASC");

        try (PreparedStatement ps2 = getConnection().prepareStatement(passSql.toString())) {
            for (int i = 0; i < passParams.size(); i++) {
                ps2.setObject(i + 1, passParams.get(i));
            }
            try (ResultSet rs2 = ps2.executeQuery()) {
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            if (ps.executeUpdate() > 0) {
                String restoreSeatSql = "UPDATE Trips SET AvailableSeats = AvailableSeats + 1 WHERE Id = ?";
                try (PreparedStatement psTrip = getConnection().prepareStatement(restoreSeatSql)) {
                    psTrip.setInt(1, ticket.getTripId());
                    psTrip.executeUpdate();
                }
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, phone != null ? phone.trim() : "");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
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
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("Phone");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * Lấy danh sách toàn bộ vé trong hệ thống phục vụ màn hình Quản lý vé của Admin
     * Hỗ trợ tìm kiếm theo Mã vé, Tên khách hàng, SĐT, Điểm đi, Điểm đến, Số ghế
     */
    public List<Map<String, Object>> getAllTicketsAdmin(String keyword, String status) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.Id, t.TripId, t.CustomerId, t.SeatNumber, t.BookingTime, t.Status, t.TotalPrice, "
                + "       c.FullName AS CustomerName, c.Phone AS CustomerPhone, c.Email AS CustomerEmail, "
                + "       fl.Name AS FromName, tl.Name AS ToName, "
                + "       tr.DepartureTime, tr.ArrivalTime, v.LicensePlate, v.Type AS VehicleType "
                + "FROM Tickets t "
                + "JOIN Customers c ON t.CustomerId = c.Id "
                + "JOIN Trips tr ON t.TripId = tr.Id "
                + "JOIN Routes r ON tr.RouteId = r.Id "
                + "JOIN Locations fl ON r.FromLocationId = fl.Id "
                + "JOIN Locations tl ON r.ToLocationId = tl.Id "
                + "LEFT JOIN Vehicles v ON tr.VehicleId = v.Id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim() + "%";
            sql.append(" AND (c.FullName LIKE ? OR c.Phone LIKE ? OR CAST(t.Id AS VARCHAR) LIKE ? ")
               .append(" OR fl.Name LIKE ? OR tl.Name LIKE ? OR t.SeatNumber LIKE ? OR v.LicensePlate LIKE ?) ");
            for (int i = 0; i < 7; i++) {
                params.add(kw);
            }
        }

        if (status != null && !status.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(status.trim())) {
            sql.append(" AND t.Status = ? ");
            params.add(status.trim());
        }

        sql.append(" ORDER BY t.Id DESC");

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("Id"));
                    map.put("tripId", rs.getInt("TripId"));
                    map.put("customerId", rs.getInt("CustomerId"));
                    map.put("customerName", rs.getString("CustomerName"));
                    map.put("customerPhone", rs.getString("CustomerPhone"));
                    map.put("customerEmail", rs.getString("CustomerEmail"));
                    map.put("seatNumber", rs.getString("SeatNumber"));
                    map.put("bookingTime", rs.getTimestamp("BookingTime"));
                    map.put("status", rs.getString("Status"));
                    map.put("totalPrice", rs.getDouble("TotalPrice"));
                    map.put("fromName", rs.getString("FromName"));
                    map.put("toName", rs.getString("ToName"));
                    map.put("departureTime", rs.getTimestamp("DepartureTime"));
                    map.put("arrivalTime", rs.getTimestamp("ArrivalTime"));
                    map.put("licensePlate", rs.getString("LicensePlate"));
                    map.put("vehicleType", rs.getString("VehicleType"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
