/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import dao.RouteDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Location;
import model.Route;
import model.User;

/**
 *
 * @author Nguyễn Tấn Phát (TV2)
 */
@WebServlet(name = "RouteController", urlPatterns = {"/admin/route"})
public class RouteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra trạng thái đăng nhập và quyền admin chung của nhóm
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RouteDAO routeDAO = new RouteDAO();
        String action = request.getParameter("action");

        // Phân nhánh điều hướng giao diện ngay trong doGet giống phong cách bạn Hậu
        if (action == null || action.equals("list")) {
            List<Route> list = routeDAO.getList();
            request.setAttribute("list", list);
            request.getRequestDispatcher("/WEB-INF/admin/route-list.jsp").forward(request, response);

        } else if (action.equals("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Route route = routeDAO.getById(id);
            request.setAttribute("route", route);
            request.getRequestDispatcher("/WEB-INF/admin/route-form.jsp").forward(request, response);

        } else if (action.equals("add")) {
            request.getRequestDispatcher("/WEB-INF/admin/route-form.jsp").forward(request, response);

        } else if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            routeDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/route?msg=deleted");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        RouteDAO routeDAO = new RouteDAO();

        String action = request.getParameter("action");

        // Lấy dữ liệu từ route-form.jsp gửi lên
        int fromLocationId = Integer.parseInt(request.getParameter("fromLocationId"));
        int toLocationId = Integer.parseInt(request.getParameter("toLocationId"));
        double distance = Double.parseDouble(request.getParameter("distance"));
        int duration = Integer.parseInt(request.getParameter("duration"));

        if ("insert".equals(action)) {
            Route route = new Route();
            
            // Đóng gói ID vào đối tượng Location lồng bên trong Route
            Location fromLoc = new Location();
            fromLoc.setId(fromLocationId);
            Location toLoc = new Location();
            toLoc.setId(toLocationId);
            
            route.setFromLocation(fromLoc);
            route.setToLocation(toLoc);
            route.setDistance(distance);
            route.setDuration(duration);
            
            routeDAO.create(route);
            response.sendRedirect(request.getContextPath() + "/admin/route?msg=added");
            
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Route route = new Route();
            route.setId(id);
            
            // Đóng gói ID vào đối tượng Location lồng bên trong Route
            Location fromLoc = new Location();
            fromLoc.setId(fromLocationId);
            Location toLoc = new Location();
            toLoc.setId(toLocationId);
            
            route.setFromLocation(fromLoc);
            route.setToLocation(toLoc);
            route.setDistance(distance);
            route.setDuration(duration);
            
            routeDAO.update(route);
            response.sendRedirect(request.getContextPath() + "/admin/route?msg=updated");
        }
    }
}
