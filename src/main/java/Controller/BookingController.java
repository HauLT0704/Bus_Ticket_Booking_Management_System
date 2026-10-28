
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
     * Gọi TripDAO.searchTrips() (TV2 viết) -> hiển thị danh sách chuyến phù hợp
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
                if (guests < 1)
                    guests = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        // Lấy danh sách địa điểm phục vụ dropdown
        dao.LocationDAO locationDAO = new dao.LocationDAO();
        List<model.Location> locationList = locationDAO.getAll();
        request.setAttribute("locationList", locationList);

        // Chuẩn hóa tên địa điểm và xác định Location ID (hỗ trợ cả ID hoặc tên rút gọn như TP.HCM từ home.jsp)
        String searchFrom = normalizeLocation(from, locationList);
        String searchTo = normalizeLocation(to, locationList);
        int fromId = findLocationId(searchFrom, locationList);
        int toId = findLocationId(searchTo, locationList);

        List<Map<String, Object>> trips = new ArrayList<>();

        // 1. Gọi TripDAO.searchTrips() do TV2 viết theo đúng phân công chi tiết
        if (fromId > 0 && toId > 0 && date != null && !date.trim().isEmpty()) {
            try {
                dao.TripDAO tripDAO = new dao.TripDAO();
                List<model.Trip> tv2Trips = tripDAO.searchTrips(fromId, toId, date.trim(), guests);
                if (tv2Trips != null && !tv2Trips.isEmpty()) {
                    for (model.Trip t : tv2Trips) {
                        Map<String, Object> map = new java.util.HashMap<>();
                        map.put("id", t.getId());
                        map.put("price", t.getPrice());
                        map.put("departureTime", t.getDepartureTime());
                        map.put("arrivalTime", t.getArrivalTime());
                        map.put("availableSeats", t.getAvailableSeats());
                        map.put("fromLocationName", (t.getRoute() != null && t.getRoute().getFromLocation() != null)
                                ? t.getRoute().getFromLocation().getName() : searchFrom);
                        map.put("toLocationName", (t.getRoute() != null && t.getRoute().getToLocation() != null)
                                ? t.getRoute().getToLocation().getName() : searchTo);
                        map.put("vehiclePlate", (t.getVehicle() != null) ? t.getVehicle().getLicensePlate() : "");
                        map.put("vehicleType", (t.getVehicle() != null) ? t.getVehicle().getType() : "Chất lượng cao");
                        map.put("duration", (t.getRoute() != null) ? t.getRoute().getDuration() : 180);
                        map.put("distance", (t.getRoute() != null) ? t.getRoute().getDistance() : 150);
                        trips.add(map);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. Nếu hàm của TV2 không có kết quả (do status trong CSDL là 'Sắp khởi hành' hoặc tìm kiếm linh hoạt không chọn ngày)
        // thì tìm kiếm linh hoạt qua BookingDAO để đảm bảo hệ thống luôn tìm thấy chuyến xe chính xác
        if (trips.isEmpty()) {
            trips = bookingDAO.searchTrips(searchFrom, searchTo, date, guests);
        }
        request.setAttribute("trips", trips);

        // 3. Gợi ý ghép chuyến (TV4 tích hợp khi không có chuyến đi thẳng - theo phân công trang 7)
        if (trips.isEmpty() && searchFrom != null && !searchFrom.trim().isEmpty() && searchTo != null && !searchTo.trim().isEmpty()) {
            List<Map<String, Object>> transferTrips = bookingDAO.searchTransferTrips(searchFrom, searchTo, date);
            request.setAttribute("transferTrips", transferTrips);
        }

        request.setAttribute("selectedFrom", searchFrom != null ? searchFrom : from);
        request.setAttribute("selectedTo", searchTo != null ? searchTo : to);
        request.setAttribute("selectedDate", date);
        request.setAttribute("selectedGuests", guests);

        request.getRequestDispatcher("/WEB-INF/user/search.jsp").forward(request, response);
    }

    /**
     * Chuẩn hóa chuỗi địa điểm tìm kiếm
     */
    private String normalizeLocation(String loc, List<model.Location> list) {
        if (loc == null || loc.trim().isEmpty() || "Tất cả".equalsIgnoreCase(loc.trim())) {
            return null;
        }
        String trimmed = loc.trim();
        // Nếu truyền ID (như từ home.jsp truyền vào)
        try {
            int id = Integer.parseInt(trimmed);
            if (list != null) {
                for (model.Location l : list) {
                    if (l.getId() == id) {
                        return l.getName();
                    }
                }
            }
        } catch (NumberFormatException ignored) {
        }
        if ("TP.HCM".equalsIgnoreCase(trimmed) || "TPHCM".equalsIgnoreCase(trimmed) || "Sài Gòn".equalsIgnoreCase(trimmed)) {
            return "TP. Hồ Chí Minh";
        }
        return trimmed;
    }

    /**
     * Tìm Location ID từ tên địa điểm phục vụ gọi hàm TripDAO của TV2
     */
    private int findLocationId(String locName, List<model.Location> list) {
        if (locName == null || locName.trim().isEmpty() || list == null) {
            return 0;
        }
        for (model.Location l : list) {
            if (l.getName().equalsIgnoreCase(locName.trim())
                    || l.getName().contains(locName.trim())
                    || locName.trim().contains(l.getName())) {
                return l.getId();
            }
        }
        return 0;
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
        double price = (trip.containsKey("price") && trip.get("price") instanceof Number)
                ? ((Number) trip.get("price")).doubleValue() : 0.0;

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
        List<String> ticketIds = new ArrayList<>();
        for (String seat : chosenSeats) {
            Ticket t = new Ticket(tripId, customerId, seat, "Đã thanh toán", price);
            if (bookingDAO.insert(t)) {
                ticketIds.add(String.valueOf(t.getId()));
            }
        }

        // Cập nhật số ghế trống
        bookingDAO.updateAvailableSeats(tripId, chosenSeats.size());

        // Redirect sang trang kết quả đặt vé
        String ticketIdsStr = String.join(",", ticketIds);
        response.sendRedirect(
                request.getContextPath() + "/booking?action=success&tripId=" + tripId + "&customerId=" + customerId + "&tickets=" + ticketIdsStr);
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

        List<Ticket> recentTickets = new ArrayList<>();
        double totalAmount = 0.0;

        String ticketsParam = request.getParameter("tickets");
        if (ticketsParam != null && !ticketsParam.trim().isEmpty()) {
            String[] tIds = ticketsParam.split(",");
            for (String tidStr : tIds) {
                try {
                    int tid = Integer.parseInt(tidStr.trim());
                    Ticket t = bookingDAO.getById(tid);
                    if (t != null) {
                        recentTickets.add(t);
                        totalAmount += t.getTotalPrice();
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }

        if (recentTickets.isEmpty()) {
            List<Ticket> allTickets = bookingDAO.getByCustomer(customerId);
            for (Ticket t : allTickets) {
                if (t.getTripId() == tripId) {
                    recentTickets.add(t);
                    totalAmount += t.getTotalPrice();
                }
            }
        }

        request.setAttribute("trip", trip);
        request.setAttribute("tickets", recentTickets);
        request.setAttribute("totalAmount", totalAmount);

        request.getRequestDispatcher("/WEB-INF/user/booking.jsp").forward(request, response);
    }
}
