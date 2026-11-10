/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Lâm Trung Hậu
 */
@WebServlet(name = "AuthController", urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    private UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("currentUser") != null) {
                User loggedIn = (User) session.getAttribute("currentUser");
                String redirect = request.getParameter("redirect");
                if (redirect != null && !redirect.trim().isEmpty() && redirect.startsWith("/")) {
                    response.sendRedirect(request.getContextPath() + redirect.trim());
                    return;
                }
                if (loggedIn.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
                return;
            }

            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("rememberedUser".equals(c.getName())) {
                        request.setAttribute("username", c.getValue());
                        request.setAttribute("rememberMe", true);
                        break;
                    }
                }
            }
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
        } else if ("/register".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
        } else if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login?msg=logged_out");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            String u = request.getParameter("username");
            String p = request.getParameter("password");
            String remember = request.getParameter("rememberMe");
            String redirect = request.getParameter("redirect");

            User user = userDao.checkLogin(u, p);

            if (user != null) {
                if ("Bị khóa".equalsIgnoreCase(user.getStatus())) {
                    request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa do vi phạm đặt vé!");
                    if (redirect != null && !redirect.trim().isEmpty()) {
                        request.setAttribute("redirect", redirect);
                    }
                    request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
                    return;
                }
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);

                // Lưu hoặc xóa Cookie ghi nhớ đăng nhập (Tiêu chí Cookies)
                Cookie userCookie;
                if ("on".equals(remember)) {
                    userCookie = new Cookie("rememberedUser", u.trim());
                    userCookie.setMaxAge(7 * 24 * 60 * 60); // Lưu 7 ngày
                } else {
                    userCookie = new Cookie("rememberedUser", "");
                    userCookie.setMaxAge(0); // Xóa cookie nếu bỏ chọn
                }
                response.addCookie(userCookie);

                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else if (redirect != null && !redirect.trim().isEmpty() && redirect.startsWith("/")) {
                    response.sendRedirect(request.getContextPath() + redirect.trim());
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }

            } else {
                request.setAttribute("errorMessage", "Sai tên đăng nhập hoặc mật khẩu!");
                request.setAttribute("username", u);
                if (redirect != null && !redirect.trim().isEmpty()) {
                    request.setAttribute("redirect", redirect);
                }
                request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);

            }
        } else if ("/register".equals(path)) {
            String u = request.getParameter("username");
            String p = request.getParameter("password");
            String confirmP = request.getParameter("confirmPassword");
            String name = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            String cleanUsername = (u != null) ? u.trim() : "";
            String cleanName = (name != null) ? name.trim() : "";
            String cleanPhone = (phone != null) ? phone.trim() : "";
            String cleanEmail = (email != null) ? email.trim() : "";

            // Lưu lại thông tin đã nhập để người dùng không phải nhập lại toàn bộ khi có lỗi
            request.setAttribute("username", cleanUsername);
            request.setAttribute("fullName", cleanName);
            request.setAttribute("phone", cleanPhone);
            request.setAttribute("email", cleanEmail);

            if (cleanUsername.isEmpty() || p == null || p.length() < 6 || cleanName.isEmpty() || cleanPhone.isEmpty() || cleanEmail.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tất cả thông tin (mật khẩu tối thiểu 6 ký tự)!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra số điện thoại: bắt buộc đủ 10 số (bắt đầu bằng số 0)
            if (!cleanPhone.matches("^0[0-9]{9}$")) {
                request.setAttribute("errorMessage", "Số điện thoại không hợp lệ! Bắt buộc phải đủ đúng 10 chữ số (bắt đầu bằng 0).");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra email: bắt buộc phải có đuôi @gmail.com
            if (!cleanEmail.toLowerCase().matches("^[a-z0-9._%+-]+@gmail\\.com$")) {
                request.setAttribute("errorMessage", "Email không hợp lệ! Bắt buộc phải là địa chỉ Gmail có đuôi @gmail.com.");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            if (!p.equals(confirmP)) {
                request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra trùng lặp Tên đăng nhập, Số điện thoại và Email
            if (userDao.findByUsername(cleanUsername) != null) {
                request.setAttribute("errorMessage", "Tên đăng nhập '" + cleanUsername + "' đã có người sử dụng!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            if (userDao.findByPhone(cleanPhone) != null) {
                request.setAttribute("errorMessage", "Số điện thoại '" + cleanPhone + "' đã được đăng ký cho tài khoản khác!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            if (userDao.findByEmail(cleanEmail) != null) {
                request.setAttribute("errorMessage", "Email '" + cleanEmail + "' đã được đăng ký cho tài khoản khác!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            User newUser = new User(0, cleanUsername, p, "user", cleanName, cleanEmail, cleanPhone, "Hoạt động", null);
            if (userDao.insert(newUser)) {
                request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Đăng ký thất bại, vui lòng thử lại!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
            }
        }
    }

}
