/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import dao.TripDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import model.Route;
import model.Trip;
import model.User;
import model.Vehicle;

/**
 *
 * @author Nguyễn Tấn Phát (TV2)
 */
@WebServlet(name = "TripController", urlPatterns = {"/admin/trip"})
public class TripController extends HttpServlet {

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
        
        TripDAO tripDAO = new TripDAO();
        String action = request.getParameter("action");
        
        // Phân nhánh điều hướng giao diện ngay trong doGet giống phong cách bạn Hậu
        if (action == null || action.equals("list")) {
            List<Trip> list = tripDAO.getList();
            request.setAttribute("list", list);
            request.getRequestDispatcher("/WEB-INF/admin/trip-list.jsp").forward(request, response);
            
        } else if (action.equals("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Trip trip = tripDAO.getById(id);
            List<Route> routeList = tripDAO.getAllRoutes();
            List<Vehicle> vehicleList = tripDAO.getAllVehicles();
            
            request.setAttribute("trip", trip);
            request.setAttribute("routeList", routeList);
            request.setAttribute("vehicleList", vehicleList);
            request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            
        } else if (action.equals("add")) {
            List<Route> routeList = tripDAO.getAllRoutes();
            List<Vehicle> vehicleList = tripDAO.getAllVehicles();
            
            request.setAttribute("routeList", routeList);
            request.setAttribute("vehicleList", vehicleList);
            request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            
        } else if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            tripDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/trip?msg=deleted");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        TripDAO tripDAO = new TripDAO();
        
        String action = request.getParameter("action");
        
        // Lấy dữ liệu từ trip-form.jsp gửi lên
        int routeId = Integer.parseInt(request.getParameter("routeId"));
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        
       // Nhận dữ liệu từ <input type="datetime-local"> (Định dạng gửi lên: YYYY-MM-DDTHH:mm)
        String depParam = request.getParameter("departureTime");
        String arrParam = request.getParameter("arrivalTime");
        
        if (depParam == null || depParam.isEmpty() || arrParam == null || arrParam.isEmpty()) {
            List<Route> routeList = tripDAO.getAllRoutes();
            List<Vehicle> vehicleList = tripDAO.getAllVehicles();
            request.setAttribute("routeList", routeList);
            request.setAttribute("vehicleList", vehicleList);
            request.setAttribute("errorMsg", "Vui lòng chọn đầy đủ thời gian khởi hành và thời gian đến!");
            request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            return;
        }
        
        // Chuyển đổi sang chuẩn SQL Timestamp (thêm :00 cho giây)
        String depTimeStr = depParam.replace("T", " ") + ":00";
        String arrTimeStr = arrParam.replace("T", " ") + ":00";
        Timestamp departureTime = Timestamp.valueOf(depTimeStr);
        Timestamp arrivalTime = Timestamp.valueOf(arrTimeStr);
        
        int availableSeats = Integer.parseInt(request.getParameter("availableSeats"));
        double price = Double.parseDouble(request.getParameter("price"));
        String status = request.getParameter("status");
        
        // Tạo mốc thời gian hiện tại, TRỪ HAO đi 5 phút (300000 ms) để bấm nút Today không bị lỗi lệch vài giây
        Timestamp nowWithTolerance = new Timestamp(System.currentTimeMillis() - 300000);
        
        if (departureTime.before(nowWithTolerance) || arrivalTime.before(departureTime) || availableSeats < 15 || availableSeats > 59 || price < 0) {
            List<Route> routeList = tripDAO.getAllRoutes();
            List<Vehicle> vehicleList = tripDAO.getAllVehicles();
            request.setAttribute("routeList", routeList);
            request.setAttribute("vehicleList", vehicleList);
            
            Trip trip = new Trip();
            Route r = new Route(); r.setId(routeId);
            Vehicle v = new Vehicle(); v.setId(vehicleId);
            trip.setRoute(r);
            trip.setVehicle(v);
            trip.setDepartureTime(departureTime);
            trip.setArrivalTime(arrivalTime);
            trip.setAvailableSeats(availableSeats);
            trip.setPrice(price);
            trip.setStatus(status);
            
            if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                trip.setId(Integer.parseInt(request.getParameter("id")));
            }
            
            request.setAttribute("trip", trip);
            request.setAttribute("errorMsg", "Lỗi dữ liệu: Thời gian khởi hành không được ở trong quá khứ, thời gian đến phải sau thời gian khởi hành, số ghế phải từ 15 đến 59!");
            request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            return;
        }

        if ("insert".equals(action)) {
            Trip trip = new Trip();
            
            // Đóng gói ID vào đối tượng Route lồng bên trong Trip
            Route route = new Route();
            route.setId(routeId);
            trip.setRoute(route);
            
            // Đóng gói ID vào đối tượng Vehicle lồng bên trong Trip
            Vehicle vehicle = new Vehicle();
            vehicle.setId(vehicleId);
            trip.setVehicle(vehicle);
            
            trip.setDepartureTime(departureTime);
            trip.setArrivalTime(arrivalTime);
            trip.setAvailableSeats(availableSeats);
            trip.setPrice(price);
            trip.setStatus(status);
            
            tripDAO.create(trip);
            response.sendRedirect(request.getContextPath() + "/admin/trip?msg=added");
            
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Trip trip = new Trip();
            trip.setId(id);
            
            // Đóng gói ID vào đối tượng Route lồng bên trong Trip
            Route route = new Route();
            route.setId(routeId);
            trip.setRoute(route);
            
            // Đóng gói ID vào đối tượng Vehicle lồng bên trong Trip
            Vehicle vehicle = new Vehicle();
            vehicle.setId(vehicleId);
            trip.setVehicle(vehicle);
            
            trip.setDepartureTime(departureTime);
            trip.setArrivalTime(arrivalTime);
            trip.setAvailableSeats(availableSeats);
            trip.setPrice(price);
            trip.setStatus(status);
            
            tripDAO.update(trip);
            response.sendRedirect(request.getContextPath() + "/admin/trip?msg=updated");
        }
    }

}
