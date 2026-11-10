package Controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.LocationDAO;
import dao.TripDAO;
import dao.UserDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Location;
import model.Ticket;
import model.Trip;
import model.User;
import util.PaginationUtil;

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
        int guests = Math.max(1, parseInt(request.getParameter("guests"), 1));

        LocationDAO locationDAO = new LocationDAO();
        List<Location> locationList = locationDAO.getAll();
        request.setAttribute("locationList", locationList);

        String searchFrom = normalizeLocation(from, locationList);
        String searchTo = normalizeLocation(to, locationList);
        int fromId = findLocationId(searchFrom, locationList);
        int toId = findLocationId(searchTo, locationList);

        List<Map<String, Object>> trips = new ArrayList<>();

        // 1. Gọi TripDAO.searchTrips() của TV2
        if (fromId > 0 && toId > 0 && date != null && !date.trim().isEmpty()) {
            try {
                TripDAO tripDAO = new TripDAO();
                List<Trip> tv2Trips = tripDAO.searchTrips(fromId, toId, date.trim(), guests);
                if (tv2Trips != null) {
                    for (Trip t : tv2Trips) {
                        trips.add(toTripMap(t, searchFrom, searchTo));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. Tìm kiếm linh hoạt qua BookingDAO nếu TV2 không có kết quả
        if (trips.isEmpty()) {
            trips = bookingDAO.searchTrips(searchFrom, searchTo, date, guests);
        }

        // Đánh dấu trạng thái có được phép đặt vé hay không và ẨN các chuyến đã khởi hành
        long now = System.currentTimeMillis();
        List<Map<String, Object>> activeTrips = new ArrayList<>();
        for (Map<String, Object> t : trips) {
            Object depObj = t.get("departureTime");
            if (depObj instanceof Date && ((Date) depObj).getTime() <= now) {
                continue; // Ẩn những chuyến đã khởi hành theo yêu cầu
            }
            markBookableStatus(t, "departureTime", "isBookable", "unbookableReason", now);
            activeTrips.add(t);
        }
        trips = activeTrips;

        // Phân trang danh sách chuyến xe (TV5)
        int page = parseInt(request.getParameter("page"), 1);
        PaginationUtil<Map<String, Object>> pagination = PaginationUtil.paginate(trips, page, 6);
        request.setAttribute("pagination", pagination);
        request.setAttribute("trips", pagination.getPageItems());

        StringBuilder baseUrl = new StringBuilder(request.getContextPath() + "/search?guests=" + guests);
        if (searchFrom != null && !searchFrom.isEmpty()) {
            baseUrl.append("&from=").append(URLEncoder.encode(searchFrom, "UTF-8"));
        }
        if (searchTo != null && !searchTo.isEmpty()) {
            baseUrl.append("&to=").append(URLEncoder.encode(searchTo, "UTF-8"));
        }
        if (date != null && !date.trim().isEmpty()) {
            baseUrl.append("&date=").append(URLEncoder.encode(date.trim(), "UTF-8"));
        }
        request.setAttribute("baseUrl", baseUrl.toString());

        // 3. Gợi ý ghép chuyến (TV4 tích hợp khi không có chuyến đi thẳng hoặc hết ghế)
        if (trips.isEmpty() && searchFrom != null && !searchFrom.trim().isEmpty() && searchTo != null && !searchTo.trim().isEmpty()) {
            List<Map<String, Object>> transferTrips = bookingDAO.searchTransferTrips(searchFrom, searchTo, date, guests);
            List<Map<String, Object>> activeTransfers = new ArrayList<>();
            if (transferTrips != null) {
                for (Map<String, Object> tr : transferTrips) {
                    Object dep1 = tr.get("trip1Dep");
                    if (dep1 instanceof Date && ((Date) dep1).getTime() <= now) {
                        continue; // Ẩn chuyến ghép đã khởi hành
                    }
                    markBookableStatus(tr, "trip1Dep", "trip1Bookable", "trip1Reason", now);
                    markBookableStatus(tr, "trip2Dep", "trip2Bookable", "trip2Reason", now);
                    tr.put("isBookable", tr.get("trip1Bookable"));
                    tr.put("unbookableReason", tr.get("trip1Reason"));
                    activeTransfers.add(tr);
                }
            }
            request.setAttribute("transferTrips", activeTransfers);
        }

        request.setAttribute("selectedFrom", searchFrom != null ? searchFrom : from);
        request.setAttribute("selectedTo", searchTo != null ? searchTo : to);
        request.setAttribute("selectedDate", date);
        request.setAttribute("selectedGuests", guests);

        request.getRequestDispatcher("/WEB-INF/user/search.jsp").forward(request, response);
    }

    /**
     * 2. Xử lý hiển thị sơ đồ ghế (seat-map.jsp - TV4)
     */
    private void handleSeatMap(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int tripId = parseInt(request.getParameter("tripId"), 0);
        if (tripId <= 0) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        User currentUser = getAuthenticatedUser(request, response, "/booking/seats?tripId=" + tripId);
        if (currentUser == null) return;

        Map<String, Object> trip = bookingDAO.getTripDetails(tripId);
        String validationError = validateTripForBooking(trip);
        if (validationError != null) {
            response.sendRedirect(request.getContextPath() + "/search?error=" + validationError);
            return;
        }

        request.setAttribute("trip", trip);
        request.setAttribute("tripId", tripId);
        request.setAttribute("bookedSeats", bookingDAO.getBookedSeats(tripId));

        request.getRequestDispatcher("/WEB-INF/user/seat-map.jsp").forward(request, response);
    }

    /**
     * 3. Xử lý đặt vé (POST /booking/confirm - TV4)
     */
    private void handleBookingConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User currentUser = getAuthenticatedUser(request, response, null);
        if (currentUser == null) return;

        int tripId = parseInt(request.getParameter("tripId"), 0);
        String seatsParam = request.getParameter("selectedSeats");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String idCard = request.getParameter("idCard");

        if (fullName == null || fullName.trim().isEmpty()) fullName = currentUser.getFullName();
        if (phone == null || phone.trim().isEmpty()) phone = currentUser.getPhone();
        if (email == null || email.trim().isEmpty()) email = currentUser.getEmail();

        if (tripId <= 0 || seatsParam == null || fullName == null || phone == null
                || fullName.trim().isEmpty() || phone.trim().isEmpty() || seatsParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin và chọn ít nhất 1 ghế!");
            handleSeatMap(request, response);
            return;
        }

        Map<String, Object> trip = bookingDAO.getTripDetails(tripId);
        String validationError = validateTripForBooking(trip);
        if (validationError != null) {
            response.sendRedirect(request.getContextPath() + "/search?error=" + validationError);
            return;
        }

        double price = (trip.get("price") instanceof Number) ? ((Number) trip.get("price")).doubleValue() : 0.0;
        int availableSeats = (trip.get("availableSeats") instanceof Number) ? ((Number) trip.get("availableSeats")).intValue() : 0;

        List<String> chosenSeats = new ArrayList<>();
        for (String s : seatsParam.split(",")) {
            String seat = s.trim().toUpperCase();
            if (!seat.isEmpty()) chosenSeats.add(seat);
        }

        if (chosenSeats.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ít nhất 1 ghế!");
            handleSeatMap(request, response);
            return;
        }

        if (chosenSeats.size() > 5) {
            request.setAttribute("errorMessage", "Mỗi lần đặt chỉ được chọn tối đa 5 vé! Vui lòng chỉ chọn tối đa 5 ghế.");
            handleSeatMap(request, response);
            return;
        }

        if (chosenSeats.size() > availableSeats) {
            request.setAttribute("errorMessage", "Chuyến xe chỉ còn " + availableSeats + " chỗ trống, không thể đặt " + chosenSeats.size() + " ghế!");
            handleSeatMap(request, response);
            return;
        }

        List<String> currentBooked = bookingDAO.getBookedSeats(tripId);
        for (String seat : chosenSeats) {
            if (currentBooked.contains(seat)) {
                request.setAttribute("errorMessage", "Ghế " + seat + " vừa có người đặt. Vui lòng chọn ghế khác!");
                handleSeatMap(request, response);
                return;
            }
        }

        int customerId = bookingDAO.getOrCreateCustomer(fullName, phone, email, idCard);

        List<String> ticketIds = new ArrayList<>();
        for (String seat : chosenSeats) {
            Ticket t = new Ticket(tripId, customerId, seat, "Đã thanh toán", price);
            if (bookingDAO.insert(t)) {
                ticketIds.add(String.valueOf(t.getId()));
            }
        }

        bookingDAO.updateAvailableSeats(tripId, chosenSeats.size());
        request.getSession().setAttribute("lastBookedCustomerId", customerId);

        String ticketIdsStr = String.join(",", ticketIds);
        response.sendRedirect(request.getContextPath() + "/booking?action=success&tripId=" + tripId 
                + "&customerId=" + customerId + "&tickets=" + ticketIdsStr);
    }

    /**
     * 4. Hiển thị trang kết quả sau khi đặt vé thành công (booking.jsp - TV4)
     */
    private void handleBookingSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = getAuthenticatedUser(request, response, null);
        if (currentUser == null) return;

        int tripId = parseInt(request.getParameter("tripId"), 0);
        int customerId = parseInt(request.getParameter("customerId"), 0);
        if (tripId <= 0 || customerId <= 0) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        if (!isTicketOwner(currentUser, customerId, request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/search?error=unauthorized");
            return;
        }

        Map<String, Object> trip = bookingDAO.getTripDetails(tripId);
        List<Ticket> recentTickets = new ArrayList<>();

        String ticketsParam = request.getParameter("tickets");
        if (ticketsParam != null && !ticketsParam.trim().isEmpty()) {
            for (String tidStr : ticketsParam.split(",")) {
                int tid = parseInt(tidStr, 0);
                if (tid > 0) {
                    Ticket t = bookingDAO.getById(tid);
                    if (t != null) recentTickets.add(t);
                }
            }
        }

        if (recentTickets.isEmpty()) {
            for (Ticket t : bookingDAO.getByCustomer(customerId)) {
                if (t.getTripId() == tripId) recentTickets.add(t);
            }
        }

        double totalAmount = 0.0;
        for (Ticket t : recentTickets) {
            if (!"Đã hủy".equalsIgnoreCase(t.getStatus())) {
                totalAmount += t.getTotalPrice();
            }
        }

        request.setAttribute("trip", trip);
        request.setAttribute("tickets", recentTickets);
        request.setAttribute("totalAmount", totalAmount);

        CustomerDAO customerDAO = new CustomerDAO();
        model.Customer customer = customerDAO.getCustomerById(customerId);
        request.setAttribute("customer", customer);

        request.getRequestDispatcher("/WEB-INF/user/booking.jsp").forward(request, response);
    }

    /**
     * 5. Xử lý hủy vé và tự động khóa tài khoản nếu hủy từ 3 vé trở lên (Vi phạm đặt vé)
     * Đã khắc phục lỗ hổng IDOR: Bắt buộc đăng nhập và xác thực quyền sở hữu vé trước khi cho phép hủy
     */
    private void handleCancelTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = getAuthenticatedUser(request, response, null);
        if (currentUser == null) return;

        int ticketId = parseInt(request.getParameter("id"), 0);
        if (ticketId <= 0) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        Ticket ticket = bookingDAO.getById(ticketId);
        if (ticket == null) {
            response.sendRedirect(request.getContextPath() + "/search?error=notfound");
            return;
        }

        int tripId = parseInt(request.getParameter("tripId"), ticket.getTripId());
        int customerId = parseInt(request.getParameter("customerId"), ticket.getCustomerId());
        String ticketsParam = request.getParameter("tickets");

        if (!isTicketOwner(currentUser, ticket.getCustomerId(), request.getSession(false))) {
            String redirectUrl = request.getContextPath() + "/booking?action=success&tripId=" + tripId 
                    + "&customerId=" + customerId + (ticketsParam != null ? "&tickets=" + ticketsParam.trim() : "") 
                    + "&cancelMsg=unauthorized";
            response.sendRedirect(redirectUrl);
            return;
        }

        if ("Đã hủy".equalsIgnoreCase(ticket.getStatus())) {
            String redirectUrl = request.getContextPath() + "/booking?action=success&tripId=" + tripId 
                    + "&customerId=" + customerId + (ticketsParam != null ? "&tickets=" + ticketsParam.trim() : "") 
                    + "&cancelMsg=already_cancelled";
            response.sendRedirect(redirectUrl);
            return;
        }

        boolean cancelled = bookingDAO.cancelTicket(ticketId);

        HttpSession session = request.getSession();
        int sessionCancelCount = 0;
        Object sessionCntObj = session.getAttribute("sessionCancelCount");
        if (sessionCntObj instanceof Integer) {
            sessionCancelCount = (Integer) sessionCntObj;
        }
        if (cancelled) {
            sessionCancelCount++;
            session.setAttribute("sessionCancelCount", sessionCancelCount);
        }

        String customerPhone = bookingDAO.getCustomerPhoneById(customerId);
        int dbCancelCount = bookingDAO.countCancelledTickets(customerId, customerPhone);
        int totalViolationCount = Math.max(sessionCancelCount, dbCancelCount);

        if (totalViolationCount >= 3) {
            UserDAO userDAO = new UserDAO();
            userDAO.lockUser(currentUser.getId());
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?msg=locked_violation");
            return;
        }

        String redirectUrl = request.getContextPath() + "/booking?action=success&tripId=" + tripId 
                + "&customerId=" + customerId + (ticketsParam != null ? "&tickets=" + ticketsParam.trim() : "") 
                + "&cancelMsg=success&cancelCount=" + totalViolationCount;
        response.sendRedirect(redirectUrl);
    }

    // ========================================================
    // CÁC HÀM TIỆN ÍCH HELPER DÙNG CHUNG (TÁI CẤU TRÚC CODE SẠCH)
    // ========================================================

    private User getAuthenticatedUser(HttpServletRequest request, HttpServletResponse response, String redirectUrl) throws IOException {
        HttpSession session = (redirectUrl != null) ? request.getSession() : request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            String redirect = (redirectUrl != null) ? "&redirect=" + URLEncoder.encode(redirectUrl, "UTF-8") : "";
            response.sendRedirect(request.getContextPath() + "/login?msg=require_login" + redirect);
            return null;
        }
        if ("Bị khóa".equalsIgnoreCase(currentUser.getStatus())) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?msg=locked_violation");
            return null;
        }
        return currentUser;
    }

    private String validateTripForBooking(Map<String, Object> trip) {
        if (trip == null || trip.isEmpty()) return "notfound";
        String status = (trip.get("status") != null) ? trip.get("status").toString() : "";
        if ("Đã hủy".equalsIgnoreCase(status) || "Hoàn thành".equalsIgnoreCase(status)) return "cancelled";
        Object depObj = trip.get("departureTime");
        if (depObj instanceof Date) {
            long diff = ((Date) depObj).getTime() - System.currentTimeMillis();
            if (diff <= 0) return "departed";
            if (diff < 60 * 60 * 1000L) return "too_close";
        }
        return null;
    }

    private boolean isTicketOwner(User user, int customerId, HttpSession session) {
        if (user.isAdmin()) return true;
        String customerPhone = bookingDAO.getCustomerPhoneById(customerId);
        String userPhone = user.getPhone() != null ? user.getPhone().trim() : "";
        if (!userPhone.isEmpty() && customerPhone != null && userPhone.equalsIgnoreCase(customerPhone.trim())) {
            return true;
        }
        CustomerDAO custDAO = new CustomerDAO();
        model.Customer cust = custDAO.getCustomerById(customerId);
        String userEmail = user.getEmail() != null ? user.getEmail().trim() : "";
        if (cust != null && !userEmail.isEmpty() && userEmail.equalsIgnoreCase(cust.getEmail())) {
            return true;
        }
        if (session != null) {
            Object lastId = session.getAttribute("lastBookedCustomerId");
            if (lastId instanceof Integer && ((Integer) lastId).intValue() == customerId) {
                return true;
            }
        }
        return false;
    }

    private void markBookableStatus(Map<String, Object> map, String timeKey, String bookableKey, String reasonKey, long now) {
        Object depObj = map.get(timeKey);
        if (depObj instanceof Date) {
            long diff = ((Date) depObj).getTime() - now;
            if (diff <= 0) {
                map.put(bookableKey, false);
                map.put(reasonKey, "Đã khởi hành");
            } else if (diff < 60 * 60 * 1000L) {
                map.put(bookableKey, false);
                map.put(reasonKey, "Đã đóng cổng đặt vé");
            } else {
                map.put(bookableKey, true);
            }
        } else {
            map.put(bookableKey, true);
        }
    }

    private Map<String, Object> toTripMap(Trip t, String searchFrom, String searchTo) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", t.getId());
        map.put("price", t.getPrice());
        map.put("departureTime", t.getDepartureTime());
        map.put("arrivalTime", t.getArrivalTime());
        map.put("availableSeats", t.getAvailableSeats());
        map.put("fromLocationName", (t.getRoute() != null && t.getRoute().getFromLocation() != null) 
                ? t.getRoute().getFromLocation().getName() : searchFrom);
        map.put("toLocationName", (t.getRoute() != null && t.getRoute().getToLocation() != null) 
                ? t.getRoute().getToLocation().getName() : searchTo);
        map.put("vehiclePlate", (t.getVehicle() != null && t.getVehicle().getLicensePlate() != null) 
                ? t.getVehicle().getLicensePlate() : "");
        map.put("vehicleType", (t.getVehicle() != null && t.getVehicle().getType() != null) 
                ? t.getVehicle().getType() : "Chất lượng cao");
        map.put("duration", (t.getRoute() != null) ? t.getRoute().getDuration() : 180);
        map.put("distance", (t.getRoute() != null) ? t.getRoute().getDistance() : 150);
        return map;
    }

    private String normalizeLocation(String loc, List<Location> list) {
        if (loc == null || loc.trim().isEmpty() || "Tất cả".equalsIgnoreCase(loc.trim())) {
            return null;
        }
        String trimmed = loc.trim();
        int id = parseInt(trimmed, -1);
        if (id > 0 && list != null) {
            for (Location l : list) {
                if (l.getId() == id) return l.getName();
            }
        }
        if ("TP.HCM".equalsIgnoreCase(trimmed) || "TPHCM".equalsIgnoreCase(trimmed) || "Sài Gòn".equalsIgnoreCase(trimmed)) {
            return "TP. Hồ Chí Minh";
        }
        return trimmed;
    }

    private int findLocationId(String locName, List<Location> list) {
        if (locName == null || locName.trim().isEmpty() || list == null) return 0;
        for (Location l : list) {
            if (l.getName().equalsIgnoreCase(locName.trim())
                    || l.getName().contains(locName.trim())
                    || locName.trim().contains(l.getName())) {
                return l.getId();
            }
        }
        return 0;
    }

    private int parseInt(String str, int defaultVal) {
        if (str != null && !str.trim().isEmpty()) {
            try {
                return Integer.parseInt(str.trim());
            } catch (NumberFormatException ignored) {}
        }
        return defaultVal;
    }
}
