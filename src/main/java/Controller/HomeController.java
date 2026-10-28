
package Controller;

import dao.LocationDAO;
import db.DBContext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "HomeController",
        urlPatterns = {"/home", "/admin/dashboard"})
public class HomeController extends HttpServlet {

    private final LocationDAO locationDAO = new LocationDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("currentUser") instanceof User)) {

            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        String path = request.getServletPath();

        if ("/admin/dashboard".equals(path)) {

            if (!currentUser.isAdmin()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            DBContext db = new DBContext();

            try {
                Connection conn = db.getConnection();

                String sqlTrips = "SELECT COUNT(*) FROM Trips";
                PreparedStatement psTrips = conn.prepareStatement(sqlTrips);
                ResultSet rsTrips = psTrips.executeQuery();

                int totalTrips = 0;

                if (rsTrips.next()) {
                    totalTrips = rsTrips.getInt(1);
                }

                rsTrips.close();
                psTrips.close();

                String sqlTickets = "SELECT COUNT(*) FROM Tickets";
                PreparedStatement psTickets = conn.prepareStatement(sqlTickets);
                ResultSet rsTickets = psTickets.executeQuery();

                int totalTickets = 0;

                if (rsTickets.next()) {
                    totalTickets = rsTickets.getInt(1);
                }

                rsTickets.close();
                psTickets.close();

                String sqlRevenue =
                        "SELECT SUM(TotalPrice) FROM Tickets "
                        + "WHERE Status = N'Đã thanh toán' "
                        + "AND CAST(BookingTime AS DATE) = CAST(GETDATE() AS DATE)";

                PreparedStatement psRevenue = conn.prepareStatement(sqlRevenue);
                ResultSet rsRevenue = psRevenue.executeQuery();

                BigDecimal todayRevenue = BigDecimal.ZERO;

                if (rsRevenue.next()) {
                    BigDecimal revenue = rsRevenue.getBigDecimal(1);

                    if (revenue != null) {
                        todayRevenue = revenue;
                    }
                }

                rsRevenue.close();
                psRevenue.close();

                request.setAttribute("totalTrips", totalTrips);
                request.setAttribute("totalTickets", totalTickets);
                request.setAttribute("todayRevenue", todayRevenue);

                request.getRequestDispatcher(
                        "/WEB-INF/admin/dashboard.jsp"
                ).forward(request, response);

            } catch (SQLException e) {
                log("Dashboard database error", e);

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Cannot load dashboard statistics"
                );
            }

            return;
        }

        if (currentUser.isAdmin()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/dashboard"
            );
            return;
        }

        request.setAttribute("locations", locationDAO.getAll());
        request.setAttribute("today", LocalDate.now().toString());

        request.getRequestDispatcher(
                "/WEB-INF/user/home.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}
