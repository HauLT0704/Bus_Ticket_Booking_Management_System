package Controller;

/**
 * @author Châu Thành Tâm (TV6)
 */
import dao.BookingDAO;
import dao.LocationDAO;
import dao.TransferDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Location;
import model.TransferOption;

@WebServlet(name = "TransferController", urlPatterns = {"/transfer", "/booking/transfer"})
public class TransferController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            LocationDAO locationDAO = new LocationDAO();
            List<Location> locations = locationDAO.getAll();
            request.setAttribute("locations", locations);

            String fromIdParam = request.getParameter("fromId");
            String toIdParam = request.getParameter("toId");
            String fromNameParam = request.getParameter("from");
            String toNameParam = request.getParameter("to");
            String dateValue = request.getParameter("date");
            String guestsValue = request.getParameter("guests");

            // Nếu người dùng mở trang /transfer mà chưa truyền tham số -> hiển thị form tìm ghép chuyến
            if ((fromIdParam == null && fromNameParam == null)
                    || (toIdParam == null && toNameParam == null)) {
                request.setAttribute("selectedDate", LocalDate.now().toString());
                request.setAttribute("guests", 1);
                request.getRequestDispatcher("/WEB-INF/user/transfer.jsp").forward(request, response);
                return;
            }

            int fromId = 0;
            int toId = 0;
            String fromName = "";
            String toName = "";

            if (fromIdParam != null && !fromIdParam.trim().isEmpty()) {
                fromId = Integer.parseInt(fromIdParam.trim());
            }
            if (toIdParam != null && !toIdParam.trim().isEmpty()) {
                toId = Integer.parseInt(toIdParam.trim());
            }

            for (Location loc : locations) {
                if (fromId > 0 && loc.getId() == fromId) {
                    fromName = loc.getName();
                } else if (fromNameParam != null && loc.getName().equalsIgnoreCase(fromNameParam.trim())) {
                    fromId = loc.getId();
                    fromName = loc.getName();
                }

                if (toId > 0 && loc.getId() == toId) {
                    toName = loc.getName();
                } else if (toNameParam != null && loc.getName().equalsIgnoreCase(toNameParam.trim())) {
                    toId = loc.getId();
                    toName = loc.getName();
                }
            }

            int guests = 1;
            if (guestsValue != null && !guestsValue.trim().isEmpty()) {
                guests = Integer.parseInt(guestsValue.trim());
            }

            LocalDate date;
            if (dateValue != null && !dateValue.trim().isEmpty()) {
                date = LocalDate.parse(dateValue.trim());
            } else {
                date = LocalDate.now();
            }

            if (fromId <= 0 || toId <= 0 || fromId == toId
                    || guests < 1 || guests > 10) {
                throw new IllegalArgumentException();
            }

            TransferDAO dao = new TransferDAO();
            List<TransferOption> options = dao.findTransferOptions(
                    fromId, toId, date, guests
            );

            // Bổ sung gợi ý ghép chuyến tuyến dài đi ngang qua điểm đón (VD: hết ghế Cần Thơ -> TP.HCM, có thể ghép Cà Mau -> TP.HCM)
            BookingDAO bookingDAO = new BookingDAO();
            List<Map<String, Object>> allTransferMaps = bookingDAO.searchTransferTrips(
                    fromName, toName, date.toString(), guests
            );
            List<Map<String, Object>> passThroughTrips = new ArrayList<>();
            for (Map<String, Object> item : allTransferMaps) {
                if ("pass_through".equals(item.get("transferType"))) {
                    passThroughTrips.add(item);
                }
            }

            request.setAttribute("transferOptions", options);
            request.setAttribute("passThroughTrips", passThroughTrips);
            request.setAttribute("fromId", fromId);
            request.setAttribute("toId", toId);
            request.setAttribute("fromName", fromName);
            request.setAttribute("toName", toName);
            request.setAttribute("selectedDate", date.toString());
            request.setAttribute("guests", guests);

            request.getRequestDispatcher(
                    "/WEB-INF/user/transfer.jsp"
            ).forward(request, response);

        } catch (IllegalArgumentException
                | DateTimeParseException ex) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Thông tin tìm kiếm ghép chuyến không hợp lệ!"
            );

        } catch (IllegalStateException ex) {

            log("Transfer search failed", ex);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to search transfer trips"
            );
        }
    }
}
