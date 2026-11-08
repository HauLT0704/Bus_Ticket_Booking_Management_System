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

            User user = userDao.checkLogin(u, p);

            if (user != null) {
                if ("Bị khóa".equalsIgnoreCase(user.getStatus())) {
                    request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa do vi phạm đặt vé!");
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
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }

            } else {
                request.setAttribute("errorMessage", "Sai tên đăng nhập hoặc mật khẩu!");
                request.setAttribute("username", u);
                request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);

            }
        } else if ("/register".equals(path)) {
            String u = request.getParameter("username");
            String p = request.getParameter("password");
            String confirmP = request.getParameter("confirmPassword");
            String name = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            if (u == null || u.trim().isEmpty() || p == null || p.length() < 6 || name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin (mật khẩu tối thiểu 6 ký tự)!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            if (!p.equals(confirmP)) {
                request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            if (userDao.findByUsername(u.trim()) != null) {
                request.setAttribute("errorMessage", "Tên đăng nhập này đã có người sử dụng!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            User newUser = new User(0, u.trim(), p, "user", name.trim(), email, phone, "Hoạt động", null);
            if (userDao.insert(newUser)) {
                request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Đăng ký thất bại!");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
            }
        }
    }

}
