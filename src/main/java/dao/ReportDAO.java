/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Hứa Hạo Danh (TV5)
 */
import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.Month;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO extends DBContext {

    // Bao cao doanh thu theo thang
    public List<Map<String, Object>> getRevenueByRoute(int month, int year) {
        try {
            if (month < 1 || month > 12) {
                System.out.println("Thang phai tu 1 den 12");
                return new ArrayList<>();
            }

            LocalDate startDate = LocalDate.of(year, month, 1);
            LocalDate endDate = startDate.plusMonths(1);

            return getRevenueByDateRange(startDate, endDate);

        } catch (DateTimeException e) {
            System.out.println("Thang hoac nam khong hop le");
            return new ArrayList<>();
        }
    }

    // Bao cao doanh thu theo quy hien tai
    public List<Map<String, Object>> getRevenueByQuarter() {
        LocalDate today = LocalDate.now();

        int quarter = (today.getMonthValue() - 1) / 3 + 1;
        int year = today.getYear();

        return getRevenueByQuarter(quarter, year);
    }

    // Bao cao doanh thu theo quy duoc chon
    public List<Map<String, Object>> getRevenueByQuarter(int quarter, int year) {
        try {
            if (quarter < 1 || quarter > 4) {
                System.out.println("Quy phai tu 1 den 4");
                return new ArrayList<>();
            }

            LocalDate startDate = LocalDate.of(
                    year, (quarter - 1) * 3 + 1, 1);

            LocalDate endDate = startDate.plusMonths(3);

            return getRevenueByDateRange(startDate, endDate);

        } catch (DateTimeException e) {
            System.out.println("Quy hoac nam khong hop le");
            return new ArrayList<>();
        }
    }

    // Bao cao doanh thu theo nam hien tai
    public List<Map<String, Object>> getRevenueByYear() {
        return getRevenueByYear(LocalDate.now().getYear());
    }

    // Bao cao doanh thu theo nam duoc chon
    public List<Map<String, Object>> getRevenueByYear(int year) {
        try {
            LocalDate startDate = LocalDate.of(year, 1, 1);
            LocalDate endDate = startDate.plusYears(1);

            return getRevenueByDateRange(startDate, endDate);

        } catch (DateTimeException e) {
            System.out.println("Nam khong hop le");
            return new ArrayList<>();
        }
    }

    // Ham dung chung de truy van doanh thu
    private List<Map<String, Object>> getRevenueByDateRange(
            LocalDate startDate, LocalDate endDate) {

        List<Map<String, Object>> revenueList = new ArrayList<>();

        String sql = "SELECT "
                + "r.Id AS RouteId, "
                + "l1.Name AS FromLocation, "
                + "l2.Name AS ToLocation, "
                + "COUNT(t.Id) AS TotalTickets, "
                + "COALESCE(SUM(t.TotalPrice), 0) AS Revenue "
                + "FROM Routes r "
                + "JOIN Locations l1 ON r.FromLocationId = l1.Id "
                + "JOIN Locations l2 ON r.ToLocationId = l2.Id "
                + "LEFT JOIN Trips tr ON tr.RouteId = r.Id "
                + "LEFT JOIN Tickets t ON t.TripId = tr.Id "
                + "AND t.BookingTime >= ? "
                + "AND t.BookingTime < ? "
                + "AND t.Status = N'Đã thanh toán' "
                + "GROUP BY r.Id, l1.Name, l2.Name "
                + "ORDER BY l1.Name, l2.Name";

        try (Connection conn = this.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1,
                    Timestamp.valueOf(startDate.atStartOfDay()));

            ps.setTimestamp(2,
                    Timestamp.valueOf(endDate.atStartOfDay()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();

                    row.put("routeId", rs.getInt("RouteId"));
                    row.put("fromLocation", rs.getString("FromLocation"));
                    row.put("toLocation", rs.getString("ToLocation"));
                    row.put("totalTickets", rs.getInt("TotalTickets"));
                    row.put("revenue", rs.getBigDecimal("Revenue"));

                    revenueList.add(row);
                }
            }

        } catch (SQLException e) {
            System.out.println("Loi khi truy van doanh thu:");
            e.printStackTrace();
        }

        return revenueList;
    }
    
    
    // Lay thong tin chi tiet ve theo ma ve
    public Map<String, Object> getTicketDetails(int ticketId) {

        Map<String, Object> ticket = null;

        String sql = "SELECT "
                + "t.Id AS TicketId, "
                + "c.FullName AS CustomerName, "
                + "c.Phone AS Phone, "
                + "t.SeatNumber AS SeatNumber, "
                + "l1.Name AS FromLocation, "
                + "l2.Name AS ToLocation, "
                + "tr.DepartureTime AS DepartureTime, "
                + "v.LicensePlate AS LicensePlate, "
                + "t.BookingTime AS BookingTime, "
                + "t.Status AS Status, "
                + "t.TotalPrice AS TotalPrice "
                + "FROM Tickets t "
                + "JOIN Customers c ON t.CustomerId = c.Id "
                + "JOIN Trips tr ON t.TripId = tr.Id "
                + "JOIN Routes r ON tr.RouteId = r.Id "
                + "JOIN Locations l1 ON r.FromLocationId = l1.Id "
                + "JOIN Locations l2 ON r.ToLocationId = l2.Id "
                + "JOIN Vehicles v ON tr.VehicleId = v.Id "
                + "WHERE t.Id = ?";

        try (Connection conn = this.getConnection()) {

            if (conn == null) {
                System.out.println("Khong ket noi duoc database!");
                return null;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, ticketId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        ticket = new HashMap<>();

                        ticket.put("id", rs.getInt("TicketId"));
                        ticket.put("customerName",
                                rs.getString("CustomerName"));
                        ticket.put("phone",
                                rs.getString("Phone"));
                        ticket.put("seatNumber",
                                rs.getString("SeatNumber"));
                        ticket.put("fromLocation",
                                rs.getString("FromLocation"));
                        ticket.put("toLocation",
                                rs.getString("ToLocation"));
                        ticket.put("departureTime",
                                rs.getTimestamp("DepartureTime"));
                        ticket.put("licensePlate",
                                rs.getString("LicensePlate"));
                        ticket.put("bookingTime",
                                rs.getTimestamp("BookingTime"));
                        ticket.put("status",
                                rs.getString("Status"));
                        ticket.put("totalPrice",
                                rs.getBigDecimal("TotalPrice"));
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println("Loi khi lay thong tin ve:");
            e.printStackTrace();
        }

        return ticket;
    }

}
