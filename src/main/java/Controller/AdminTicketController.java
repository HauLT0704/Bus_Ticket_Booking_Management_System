package Controller;

import dao.BookingDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PaginationUtil;

/**
 * Controller Quản lý Vé dành cho Quản trị viên (Admin)
 * Cho phép xem toàn bộ vé, tìm kiếm/lọc, hủy vé và hỗ trợ đặt vé hộ khách hàng qua điện thoại
 */
@WebServlet(name = "AdminTicketController", urlPatterns = {"/admin/tickets", "/admin/ticket"})
public class AdminTicketController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

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

        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            handleCancelTicket(request, response);
            return;
        }

        listTickets(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void listTickets(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Map<String, Object>> allTickets = bookingDAO.getAllTicketsAdmin(keyword, status);

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        PaginationUtil<Map<String, Object>> pagination = PaginationUtil.paginate(allTickets, page, 10);
        request.setAttribute("pagination", pagination);
        request.setAttribute("ticketList", pagination.getPageItems());
        request.setAttribute("totalTickets", allTickets.size());

        StringBuilder baseUrl = new StringBuilder(request.getContextPath() + "/admin/tickets?");
        if (keyword != null && !keyword.trim().isEmpty()) {
            baseUrl.append("&keyword=").append(URLEncoder.encode(keyword.trim(), "UTF-8"));
            request.setAttribute("keyword", keyword.trim());
        }
        if (status != null && !status.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(status.trim())) {
            baseUrl.append("&status=").append(URLEncoder.encode(status.trim(), "UTF-8"));
            request.setAttribute("selectedStatus", status.trim());
        }
        request.setAttribute("baseUrl", baseUrl.toString());

        request.getRequestDispatcher("/WEB-INF/admin/ticket-list.jsp").forward(request, response);
    }

    private void handleCancelTicket(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        int ticketId = 0;
        if (idParam != null) {
            try {
                ticketId = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (ticketId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets?msg=invalid_id");
            return;
        }

        boolean cancelled = bookingDAO.cancelTicket(ticketId);
        if (cancelled) {
            response.sendRedirect(request.getContextPath() + "/admin/tickets?msg=cancelled&id=" + ticketId);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/tickets?msg=cancel_failed");
        }
    }
}

