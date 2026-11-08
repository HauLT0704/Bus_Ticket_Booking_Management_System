package Controller;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Controller xử lý Báo cáo doanh thu, In vé và Danh sách khách hàng theo chuyến
 * Phân công: Hứa Hạo Danh (TV5)
 */
@WebServlet(name = "ReportController", urlPatterns = {
    "/report",
    "/print-ticket",
    "/admin/report",
    "/admin/trips/customers"
})
public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        // 1. Action: In vé xe khách (TV5 - Dành cho User & Admin)
        if ("/print-ticket".equals(path)) {
            handlePrintTicket(request, response);
            return;
        }

        // Các đường dẫn Quản trị (/admin/trips/customers, /admin/report, /report) bắt buộc phải là Admin
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Action: In danh sách khách hàng theo chuyến xe (TV5)
        if ("/admin/trips/customers".equals(path)) {
            handleTripCustomers(request, response);
            return;
        }

        // 3. Action: Báo cáo doanh thu (mặc định)
        handleReport(request, response);
    }

    /**
     * Lấy danh sách khách hàng đã đặt theo chuyến xe
     */
    private void handleTripCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tripIdParam = request.getParameter("tripId");
        if (tripIdParam == null || tripIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/trip");
            return;
        }

        try {
            int tripId = Integer.parseInt(tripIdParam.trim());
            ReportDAO dao = new ReportDAO();

            Map<String, Object> tripInfo = dao.getTripSummary(tripId);
            List<Map<String, Object>> customerList = dao.getCustomersByTrip(tripId);

            request.setAttribute("trip", tripInfo);
            request.setAttribute("customerList", customerList);
            request.setAttribute("tripId", tripId);

            request.getRequestDispatcher("/WEB-INF/admin/trip-customer-list.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/trip");
        }
    }

    /**
     * In vé đơn lẻ
     */
    private void handlePrintTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketIdValue = request.getParameter("id");
        if (ticketIdValue == null || ticketIdValue.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Vui lòng cung cấp mã vé!");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdValue);
            ReportDAO dao = new ReportDAO();
            Map<String, Object> ticket = dao.getTicketDetails(ticketId);

            if (ticket == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy vé có mã " + ticketId);
                return;
            }

            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/WEB-INF/user/print-ticket.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã vé không hợp lệ!");
        }
    }

    /**
     * Hiển thị trang báo cáo doanh thu
     */
    private void handleReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LocalDate today = LocalDate.now();
        int month = today.getMonthValue();
        int year = today.getYear();
        int quarter = (month - 1) / 3 + 1;

        ReportDAO dao = new ReportDAO();
        List<Map<String, Object>> revenueList = dao.getRevenueByRoute(month, year);

        request.setAttribute("revenueList", revenueList);
        request.setAttribute("reportType", "month");
        request.setAttribute("month", month);
        request.setAttribute("quarter", quarter);
        request.setAttribute("year", year);

        request.getRequestDispatcher("/WEB-INF/admin/report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập và phân quyền Admin
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LocalDate today = LocalDate.now();
        int currentMonth = today.getMonthValue();
        int currentYear = today.getYear();
        int currentQuarter = (currentMonth - 1) / 3 + 1;

        String reportType = request.getParameter("type");
        if (reportType == null || reportType.isEmpty()) {
            reportType = "month";
        }

        int month = currentMonth;
        int quarter = currentQuarter;
        int year = currentYear;
        String error = null;

        try {
            String monthValue = request.getParameter("month");
            String quarterValue = request.getParameter("quarter");
            String yearValue = request.getParameter("year");

            if (monthValue != null && !monthValue.trim().isEmpty()) {
                month = Integer.parseInt(monthValue.trim());
            }
            if (quarterValue != null && !quarterValue.trim().isEmpty()) {
                quarter = Integer.parseInt(quarterValue.trim());
            }
            if (yearValue != null && !yearValue.trim().isEmpty()) {
                year = Integer.parseInt(yearValue.trim());
            }

            if (month < 1 || month > 12) {
                month = currentMonth;
                error = "Tháng phải nằm trong khoảng từ 1 đến 12!";
            }
            if (quarter < 1 || quarter > 4) {
                quarter = currentQuarter;
                error = "Quý phải nằm trong khoảng từ 1 đến 4!";
            }
            if (year < 1 || year > 9999) {
                year = currentYear;
                error = "Năm không hợp lệ!";
            }
        } catch (NumberFormatException e) {
            error = "Vui lòng nhập tháng, quý và năm hợp lệ!";
            month = currentMonth;
            quarter = currentQuarter;
            year = currentYear;
        }

        ReportDAO dao = new ReportDAO();
        List<Map<String, Object>> revenueList;

        switch (reportType) {
            case "quarter":
                revenueList = dao.getRevenueByQuarter(quarter, year);
                break;
            case "year":
                revenueList = dao.getRevenueByYear(year);
                break;
            case "month":
            default:
                reportType = "month";
                revenueList = dao.getRevenueByRoute(month, year);
                break;
        }

        request.setAttribute("revenueList", revenueList);
        request.setAttribute("reportType", reportType);
        request.setAttribute("month", month);
        request.setAttribute("quarter", quarter);
        request.setAttribute("year", year);
        request.setAttribute("error", error);

        request.getRequestDispatcher("/WEB-INF/admin/report.jsp").forward(request, response);
    }
}
