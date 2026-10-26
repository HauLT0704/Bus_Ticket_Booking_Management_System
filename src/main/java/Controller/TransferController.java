package Controller;

/**
 * @author Châu Thành Tâm (TV6)
 */
import dao.TransferDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TransferOption;

@WebServlet(name = "TransferController", urlPatterns = {"/transfer"})
public class TransferController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String fromValue = request.getParameter("fromId");
            String toValue = request.getParameter("toId");
            String dateValue = request.getParameter("date");
            String guestsValue = request.getParameter("guests");

            if (fromValue == null || toValue == null
                    || dateValue == null || guestsValue == null) {
                throw new IllegalArgumentException();
            }

            int fromId = Integer.parseInt(fromValue);
            int toId = Integer.parseInt(toValue);
            int guests = Integer.parseInt(guestsValue);
            LocalDate date = LocalDate.parse(dateValue);

            if (fromId <= 0 || toId <= 0 || fromId == toId
                    || guests < 1 || guests > 10
                    || date.isBefore(LocalDate.now())) {

                throw new IllegalArgumentException();
            }

            TransferDAO dao = new TransferDAO();

            List<TransferOption> options
                    = dao.findTransferOptions(
                            fromId, toId, date, guests
                    );

            request.setAttribute("transferOptions", options);
            request.setAttribute("fromId", fromId);
            request.setAttribute("toId", toId);
            request.setAttribute("selectedDate", date.toString());
            request.setAttribute("guests", guests);

            request.getRequestDispatcher(
                    "/WEB-INF/user/transfer.jsp"
            ).forward(request, response);

        } catch (IllegalArgumentException
                | DateTimeParseException ex) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid transfer search information"
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
