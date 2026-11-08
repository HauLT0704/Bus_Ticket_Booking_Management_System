
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
        "/booking/confirm",
        "/booking/cancel"
})
public class BookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/booking/seats".equals(path)) {
            handleSeatMap(request, response);
        } else if ("/booking/cancel".equals(path)) {
            handleCancelTicket(request, response);
        } else if ("/search".equals(path)) {
            handleSearchTrips(request, response);
        } else {
            // /booking (Xem thông tin vé vừa đặt hoặc hủy vé)
            String action = request.getParameter("action");
            if ("success".equals(action)) {
                handleBookingSuccess(request, response);
            } else if ("cancel".equals(action)) {
                handleCancelTicket(request, response);
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
        } else if ("/booking/cancel".equals(path)) {
            handleCancelTicket(request, response);
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

                        if (t.getRoute() != null && t.getRoute().getFromLocation() != null) {
                            map.put("fromLocationName", t.getRoute().getFromLocation().getName());
                        } else {
                            map.put("fromLocationName", searchFrom);
                        }

                        if (t.getRoute() != null && t.getRoute().getToLocation() != null) {
                            map.put("toLocationName", t.getRoute().getToLocation().getName());
                        } else {
                            map.put("toLocationName", searchTo);
                        }

                        if (t.getVehicle() != null && t.getVehicle().getLicensePlate() != null) {
                            map.put("vehiclePlate", t.getVehicle().getLicensePlate());
                        } else {
                            map.put("vehiclePlate", "");
                        }

                        if (t.getVehicle() != null && t.getVehicle().getType() != null) {
                            map.put("vehicleType", t.getVehicle().getType());
                        } else {
                            map.put("vehicleType", "Chất lượng cao");
                        }

                        if (t.getRoute() != null) {
                            map.put("duration", t.getRoute().getDuration());
                            map.put("distance", t.getRoute().getDistance());
                        } else {
                            map.put("duration", 180);
                            map.put("distance", 150);
                        }
                        trips.add(map);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. Nếu hàm của TV2 không có kết quả (hoặc tìm kiếm linh hoạt không chọn ngày)
        // thì tìm kiếm linh hoạt qua BookingDAO để đảm bảo hệ thống luôn tìm thấy chuyến xe chính xác
        if (trips.isEmpty()) {
            trips = bookingDAO.searchTrips(searchFrom, searchTo, date, guests);
        }

        // Tích hợp phân trang cho danh sách chuyến xe của User (Phối hợp TV5)
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {
            }
        }
        util.PaginationUtil<Map<String, Object>> pagination = util.PaginationUtil.paginate(trips, page, 6);
        request.setAttribute("pagination", pagination);
        request.setAttribute("trips", pagination.getPageItems());

        StringBuilder baseUrl = new StringBuilder(request.getContextPath() + "/search?guests=" + guests);
        if (searchFrom != null && !searchFrom.isEmpty()) {
            baseUrl.append("&from=").append(java.net.URLEncoder.encode(searchFrom, "UTF-8"));
        }
        if (searchTo != null && !searchTo.isEmpty()) {
            baseUrl.append("&to=").append(java.net.URLEncoder.encode(searchTo, "UTF-8"));
        }
        if (date != null && !date.trim().isEmpty()) {
            baseUrl.append("&date=").append(java.net.URLEncoder.encode(date.trim(), "UTF-8"));
        }
        request.setAttribute("baseUrl", baseUrl.toString());

        // 3. Gợi ý ghép chuyến (TV4 tích hợp khi không có chuyến đi thẳng hoặc hết ghế)
        if (trips.isEmpty() && searchFrom != null && !searchFrom.trim().isEmpty() && searchTo != null && !searchTo.trim().isEmpty()) {
            List<Map<String, Object>> transferTrips = bookingDAO.searchTransferTrips(searchFrom, searchTo, date, guests);
            request.setAttribute("transferTrips", transferTrips);
        }

        if (searchFrom != null) {
            request.setAttribute("selectedFrom", searchFrom);
        } else {
            request.setAttribute("selectedFrom", from);
        }

        if (searchTo != null) {
            request.setAttribute("selectedTo", searchTo);
        } else {
            request.setAttribute("selectedTo", to);
        }
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
        if (trip.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search?error=notfound");
            return;
        }

        String tripStatus = "";
        if (trip.get("status") != null) {
            tripStatus = trip.get("status").toString();
        }
        if ("Đã hủy".equalsIgnoreCase(tripStatus) || "Hoàn thành".equalsIgnoreCase(tripStatus)) {
            request.setAttribute("errorMessage", "Chuyến xe này đã hoàn thành hoặc bị hủy, không thể đặt vé!");
            handleSeatMap(request, response);
            return;
        }

        double price = 0.0;
        if (trip.containsKey("price") && trip.get("price") instanceof Number) {
            price = ((Number) trip.get("price")).doubleValue();
        }

        int availableSeats = 0;
        if (trip.containsKey("availableSeats") && trip.get("availableSeats") instanceof Number) {
            availableSeats = ((Number) trip.get("availableSeats")).intValue();
        }

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

        // Kiểm tra số lượng ghế đặt không được vượt quá số ghế còn trống (Business logic 30%)
        if (chosenSeats.size() > availableSeats) {
            request.setAttribute("errorMessage", "Chuyến xe chỉ còn " + availableSeats + " chỗ trống, không thể đặt " + chosenSeats.size() + " ghế!");
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
                        if (!"Đã hủy".equalsIgnoreCase(t.getStatus())) {
                            totalAmount += t.getTotalPrice();
                        }
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
                    if (!"Đã hủy".equalsIgnoreCase(t.getStatus())) {
                        totalAmount += t.getTotalPrice();
                    }
                }
            }
        }

        request.setAttribute("trip", trip);
        request.setAttribute("tickets", recentTickets);
        request.setAttribute("totalAmount", totalAmount);

        request.getRequestDispatcher("/WEB-INF/user/booking.jsp").forward(request, response);
    }

    /**
     * 5. Xử lý hủy vé và tự động khóa tài khoản nếu hủy từ 3 vé trở lên (Vi phạm đặt vé)
     */
    private void handleCancelTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketIdStr = request.getParameter("id");
        String tripIdStr = request.getParameter("tripId");
        String customerIdStr = request.getParameter("customerId");
        String ticketsParam = request.getParameter("tickets");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        int ticketId = 0;
        try {
            ticketId = Integer.parseInt(ticketIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        Ticket ticket = bookingDAO.getById(ticketId);
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        int tripId = ticket.getTripId();
        int customerId = ticket.getCustomerId();
        if (tripIdStr != null && !tripIdStr.trim().isEmpty()) {
            try {
                tripId = Integer.parseInt(tripIdStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }
        if (customerIdStr != null && !customerIdStr.trim().isEmpty()) {
            try {
                customerId = Integer.parseInt(customerIdStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        boolean cancelled = bookingDAO.cancelTicket(ticketId);

        jakarta.servlet.http.HttpSession session = request.getSession();
        int sessionCancelCount = 0;
        Object sessionCntObj = session.getAttribute("sessionCancelCount");
        if (sessionCntObj instanceof Integer) {
            sessionCancelCount = (Integer) sessionCntObj;
        }
        if (cancelled) {
            sessionCancelCount = sessionCancelCount + 1;
            session.setAttribute("sessionCancelCount", sessionCancelCount);
        }

        String customerPhone = bookingDAO.getCustomerPhoneById(customerId);
        int dbCancelCount = bookingDAO.countCancelledTickets(customerId, customerPhone);

        int totalViolationCount = dbCancelCount;
        if (sessionCancelCount > totalViolationCount) {
            totalViolationCount = sessionCancelCount;
        }

        // Quy tắc nghiệp vụ: Hủy vé từ 3 lần trở lên sẽ bị khóa tài khoản do vi phạm đặt vé
        if (totalViolationCount >= 3) {
            Object currentUserObj = session.getAttribute("currentUser");
            if (currentUserObj instanceof model.User) {
                model.User currentUser = (model.User) currentUserObj;
                dao.UserDAO userDAO = new dao.UserDAO();
                userDAO.lockUser(currentUser.getId());
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login?msg=locked_violation");
                return;
            }
        }

        StringBuilder redirectUrl = new StringBuilder(request.getContextPath()
                + "/booking?action=success&tripId=" + tripId + "&customerId=" + customerId);
        if (ticketsParam != null && !ticketsParam.trim().isEmpty()) {
            redirectUrl.append("&tickets=").append(ticketsParam.trim());
        }
        redirectUrl.append("&cancelMsg=success&cancelCount=").append(totalViolationCount);
        response.sendRedirect(redirectUrl.toString());
    }
}
