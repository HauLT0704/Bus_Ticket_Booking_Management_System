
package Controller;

import dao.LocationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final LocationDAO locationDAO = new LocationDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy Session hiện tại, không tạo Session mới
        HttpSession session = request.getSession(false);

        // 2. Chưa đăng nhập -> Login
        if (session == null
                || !(session.getAttribute("currentUser") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        User currentUser =
                (User) session.getAttribute("currentUser");

        // 3. Admin -> trang quản trị
        if (currentUser.isAdmin()) {

            response.sendRedirect(
                    request.getContextPath() + "/admin/location"
            );
            return;
        }

        // 4. User -> lấy danh sách địa điểm từ database
        request.setAttribute(
                "locations",
                locationDAO.getAll()
        );

        // 5. Forward vào giao diện Home
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
