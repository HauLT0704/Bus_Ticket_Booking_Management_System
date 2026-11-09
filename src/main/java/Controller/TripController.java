package Controller;

import dao.TripDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.List;
import model.Route;
import model.Trip;
import model.User;
import model.Vehicle;
import util.PaginationUtil;

/**
 * Controller Quản lý Chuyến xe (kèm phân trang)
 * Phân công: Nguyễn Tấn Phát (TV2) - Phối hợp phân trang TV5
 */
@WebServlet(name = "TripController", urlPatterns = {"/admin/trip"})
public class TripController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        
        if (action == null || action.equals("list")) {
            List<Trip> fullList = tripDAO.getList();
            
            // Tích hợp phân trang (TV5)
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) {}
            }
            PaginationUtil<Trip> pagination = PaginationUtil.paginate(fullList, page, 8);
            request.setAttribute("pagination", pagination);
            request.setAttribute("list", pagination.getPageItems());
            request.setAttribute("baseUrl", request.getContextPath() + "/admin/trip?action=list");
            
            request.getRequestDispatcher("/WEB-INF/admin/trip-list.jsp").forward(request, response);
            
        } else if (action.equals("edit")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Trip trip = tripDAO.getById(id);
                if (trip == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/trip?msg=not_found");
                    return;
                }
                List<Route> routeList = tripDAO.getAllRoutes();
                List<Vehicle> vehicleList = tripDAO.getAllVehicles();
                
                request.setAttribute("trip", trip);
                request.setAttribute("routeList", routeList);
                request.setAttribute("vehicleList", vehicleList);
                request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/trip?msg=invalid_id");
            }
            
        } else if (action.equals("add")) {
            List<Route> routeList = tripDAO.getAllRoutes();
            List<Vehicle> vehicleList = tripDAO.getAllVehicles();
            
            request.setAttribute("routeList", routeList);
            request.setAttribute("vehicleList", vehicleList);
            request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            
        } else if (action.equals("delete")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Trip trip = tripDAO.getById(id);
                if (trip == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/trip?msg=not_found");
                    return;
                }
                boolean deleted = tripDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/trip?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/trip?msg=delete_error");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/trip?msg=invalid_id");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

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
        int routeId = 0;
        int vehicleId = 0;
        int availableSeats = -1;
        double price = -1;
        int currentId = 0;
        Timestamp departureTime = null;
        Timestamp arrivalTime = null;
        boolean hasParseError = false;

        try {
            routeId = Integer.parseInt(request.getParameter("routeId"));
            vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            availableSeats = Integer.parseInt(request.getParameter("availableSeats"));
            price = Double.parseDouble(request.getParameter("price"));

            if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                currentId = Integer.parseInt(request.getParameter("id"));
            }

            String depParam = request.getParameter("departureTime");
            String arrParam = request.getParameter("arrivalTime");

            if (depParam == null || depParam.isEmpty() || arrParam == null || arrParam.isEmpty()) {
                hasParseError = true;
            } else {
                String depTimeStr = depParam.replace("T", " ");
                if (depParam.length() == 16) {
                    depTimeStr = depTimeStr + ":00";
                }
                String arrTimeStr = arrParam.replace("T", " ");
                if (arrParam.length() == 16) {
                    arrTimeStr = arrTimeStr + ":00";
                }
                departureTime = Timestamp.valueOf(depTimeStr);
                arrivalTime = Timestamp.valueOf(arrTimeStr);
            }
        } catch (Exception e) {
            hasParseError = true;
        }

        if (hasParseError || departureTime == null || arrivalTime == null || routeId <= 0 || vehicleId <= 0) {
            List<Route> routeList = tripDAO.getAllRoutes();
            List<Vehicle> vehicleList = tripDAO.getAllVehicles();
            request.setAttribute("routeList", routeList);
            request.setAttribute("vehicleList", vehicleList);
            request.setAttribute("errorMsg", "Dữ liệu nhập không hợp lệ! Vui lòng chọn tuyến xe, loại xe, thời gian hợp lệ và nhập đúng định dạng số.");
            request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            return;
        }

        if ("update".equals(action)) {
            if (currentId <= 0 || tripDAO.getById(currentId) == null) {
                response.sendRedirect(request.getContextPath() + "/admin/trip?msg=not_found");
                return;
            }
        }

        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "Sắp khởi hành";
        }
        
        Timestamp nowWithTolerance = new Timestamp(System.currentTimeMillis() - 300000);
        int maxVehicleSeats = tripDAO.getVehicleMaxSeats(vehicleId);

        boolean isInvalid = false;
        String errorMessage = "";

        if ("insert".equals(action) && departureTime.before(nowWithTolerance)) {
            isInvalid = true;
            errorMessage = "Thời gian khởi hành của chuyến mới không được nằm trong quá khứ!";
        } else if (!arrivalTime.after(departureTime)) {
            isInvalid = true;
            errorMessage = "Thời gian đến dự kiến phải sau thời gian khởi hành!";
        } else if (availableSeats < 0 || availableSeats > maxVehicleSeats) {
            isInvalid = true;
            errorMessage = "Số ghế trống phải từ 0 đến tối đa " + maxVehicleSeats + " ghế (theo sức chứa của xe đã chọn)!";
        } else if (price < 100000 || price > 1000000) {
            isInvalid = true;
            errorMessage = "Giá vé phải nằm trong khoảng từ 100.000 đến 1.000.000 VNĐ!";
        }
        
        if (isInvalid) {
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
            
            if (currentId > 0) {
                trip.setId(currentId);
            }
            
            request.setAttribute("trip", trip);
            request.setAttribute("errorMsg", errorMessage);
            request.getRequestDispatcher("/WEB-INF/admin/trip-form.jsp").forward(request, response);
            return;
        }

        if ("insert".equals(action)) {
            Trip trip = new Trip();
            Route route = new Route();
            route.setId(routeId);
            trip.setRoute(route);
            
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
            int id = currentId;
            Trip trip = new Trip();
            trip.setId(id);
            
            Route route = new Route();
            route.setId(routeId);
            trip.setRoute(route);
            
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
