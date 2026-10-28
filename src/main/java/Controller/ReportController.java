/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Hứa Hạo Danh (TV5)
 */
@WebServlet(name = "ReportController", urlPatterns = {"/report", "/print-ticket"})
public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/print-ticket".equals(path)) {
            String ticketIdValue = request.getParameter("id");

            if (ticketIdValue == null || ticketIdValue.trim().isEmpty()) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Vui long cung cap ma ve!"
                );
                return;
            }

            int ticketId;

            try {
                ticketId = Integer.parseInt(ticketIdValue);
            } catch (NumberFormatException e) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Ma ve khong hop le!"
                );
                return;
            }

            ReportDAO dao = new ReportDAO();

            Map<String, Object> ticket = dao.getTicketDetails(ticketId);

            if (ticket == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Khong tim thay ve co ma " + ticketId
                );
                return;
            }

            request.setAttribute("ticket", ticket);

            request.getRequestDispatcher(
                    "/WEB-INF/user/print-ticket.jsp"
            ).forward(request, response);

            return;
        }

        LocalDate today = LocalDate.now();

        int month = today.getMonthValue();
        int year = today.getYear();
        int quarter = (month - 1) / 3 + 1;

        ReportDAO dao = new ReportDAO();
        List<Map<String, Object>> revenueList = new ArrayList<>();

        // Mac dinh hien thi bao cao theo thang hien tai
        revenueList = dao.getRevenueByRoute(month, year);

        request.setAttribute("revenueList", revenueList);
        request.setAttribute("reportType", "month");
        request.setAttribute("month", month);
        request.setAttribute("quarter", quarter);
        request.setAttribute("year", year);

        request.getRequestDispatcher(
                "/WEB-INF/admin/report.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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
        List<Map<String, Object>> revenueList = new ArrayList<>();

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

        request.getRequestDispatcher(
                "/WEB-INF/admin/report.jsp"
        ).forward(request, response);
    }
}
