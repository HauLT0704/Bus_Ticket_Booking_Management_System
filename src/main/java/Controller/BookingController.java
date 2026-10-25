package Controller;

import dao.BookingDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Ticket;

/**
 * Controller xử lý Tìm chuyến xe, Sơ đồ ghế và Đặt vé
 * Phân công: Huỳnh Nhất Bảo (TV4)
 */
@WebServlet(name = "BookingController", urlPatterns = {
    "/search",
    "/booking",
    "/booking/seats",
    "/booking/confirm"
})
public class BookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/booking/seats".equals(path)) {
            handleSeatMap(request, response);
        } else if ("/search".equals(path)) {
            handleSearchTrips(request, response);
        } else {
            // /booking (Xem thông tin vé vừa đặt hoặc lịch sử)
            String action = request.getParameter("action");
            if ("success".equals(action)) {
                handleBookingSuccess(request, response);
            } else {
                handleSearchTrips(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/booking/confirm".equals(path)) {
            handleBookingConfirm(request, response);
        } else {
            doGet(request, response);
        }
    }

    /**
     * 1. Xử lý tìm kiếm chuyến xe (search.jsp - TV4)
     */
    private void handleSearchTrips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String date = request.getParameter("date");
        String guestsStr = request.getParameter("guests");

        int guests = 1;
        if (guestsStr != null && !guestsStr.trim().isEmpty()) {
            try {
                guests = Integer.parseInt(guestsStr.trim());
                if (guests < 1) guests = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        // Tìm danh sách chuyến xe phù hợp
        List<Map<String, Object>> trips = bookingDAO.searchTrips(from, to, date, guests);
        request.setAttribute("trips", trips);

        request.setAttribute("selectedFrom", from);
        request.setAttribute("selectedTo", to);
        request.setAttribute("selectedDate", date);
        request.setAttribute("selectedGuests", guests);

        request.getRequestDispatcher("/WEB-INF/user/search.jsp").forward(request, response);
    }

    /**
     * 2. Xử lý hiển thị sơ đồ ghế (seat-map.jsp - TV4)
     */
    private void handleSeatMap(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tripIdStr = request.getParameter("tripId");
        if (tripIdStr == null || tripIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        int tripId;
        try {
            tripId = Integer.parseInt(tripIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        // Lấy thông tin chuyến xe
        Map<String, Object> trip = bookingDAO.getTripDetails(tripId);
        if (trip.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search?error=notfound");
            return;
        }

        // Lấy danh sách các ghế đã đặt
        List<String> bookedSeats = bookingDAO.getBookedSeats(tripId);

        request.setAttribute("trip", trip);
        request.setAttribute("tripId", tripId);
        request.setAttribute("bookedSeats", bookedSeats);

        request.getRequestDispatcher("/WEB-INF/user/seat-map.jsp").forward(request, response);
    }

    /**
     * 3. Xử lý đặt vé (POST /booking/confirm - TV4)
     */
    private void handleBookingConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String tripIdStr = request.getParameter("tripId");
        String seatsParam = request.getParameter("selectedSeats");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String idCard = request.getParameter("idCard");

        if (tripIdStr == null || seatsParam == null || fullName == null || phone == null
                || fullName.trim().isEmpty() || phone.trim().isEmpty() || seatsParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin và chọn ít nhất 1 ghế!");
            handleSeatMap(request, response);
            return;
        }

        int tripId = Integer.parseInt(tripIdStr.trim());
        Map<String, Object> trip = bookingDAO.getTripDetails(tripId);
        double price = trip.containsKey("price") ? (double) trip.get("price") : 0.0;

        // Tách chuỗi ghế
        String[] seatArr = seatsParam.split(",");
        List<String> chosenSeats = new ArrayList<>();
        for (String s : seatArr) {
            String seat = s.trim().toUpperCase();
            if (!seat.isEmpty()) {
                chosenSeats.add(seat);
            }
        }

        if (chosenSeats.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ít nhất 1 ghế!");
            handleSeatMap(request, response);
            return;
        }

        // Kiểm tra ghế đã bị đặt chưa
        List<String> currentBooked = bookingDAO.getBookedSeats(tripId);
        for (String seat : chosenSeats) {
            if (currentBooked.contains(seat)) {
                request.setAttribute("errorMessage", "Ghế " + seat + " vừa có người đặt. Vui lòng chọn ghế khác!");
                handleSeatMap(request, response);
                return;
            }
        }

        // Lấy hoặc tạo khách hàng trong bảng Customers
        int customerId = bookingDAO.getOrCreateCustomer(fullName, phone, email, idCard);

        // Lưu vé vào bảng Tickets
        for (String seat : chosenSeats) {
            Ticket t = new Ticket(tripId, customerId, seat, "Đã thanh toán", price);
            bookingDAO.insert(t);
        }

        // Cập nhật số ghế trống
        bookingDAO.updateAvailableSeats(tripId, chosenSeats.size());

        // Redirect sang trang kết quả đặt vé
        response.sendRedirect(request.getContextPath() + "/booking?action=success&tripId=" + tripId + "&customerId=" + customerId);
    }

    /**
     * 4. Hiển thị trang kết quả sau khi đặt vé thành công (booking.jsp - TV4)
     */
    private void handleBookingSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tripIdStr = request.getParameter("tripId");
        String customerIdStr = request.getParameter("customerId");

        if (tripIdStr == null || customerIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        int tripId = Integer.parseInt(tripIdStr);
        int customerId = Integer.parseInt(customerIdStr);

        Map<String, Object> trip = bookingDAO.getTripDetails(tripId);
        List<Ticket> allTickets = bookingDAO.getByCustomer(customerId);

        List<Ticket> recentTickets = new ArrayList<>();
        double totalAmount = 0.0;
        for (Ticket t : allTickets) {
            if (t.getTripId() == tripId) {
                recentTickets.add(t);
                totalAmount += t.getTotalPrice();
            }
        }

        request.setAttribute("trip", trip);
        request.setAttribute("tickets", recentTickets);
        request.setAttribute("totalAmount", totalAmount);

        request.getRequestDispatcher("/WEB-INF/user/booking.jsp").forward(request, response);
    }
}
