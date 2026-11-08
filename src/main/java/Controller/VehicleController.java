package Controller;

import dao.VehicleDAO;
import model.User;
import model.Vehicle;
import util.PaginationUtil;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller Quản lý Xe khách (kèm phân trang)
 * Phân công: Phan Thanh Tu (TV3) - Phối hợp phân trang TV5
 */
@WebServlet(name = "VehicleController", urlPatterns = {"/vehicle", "/admin/vehicle", "/admin/vehicles"})
public class VehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập và phân quyền Admin
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

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                request.getRequestDispatcher("/WEB-INF/admin/vehicle-form.jsp").forward(request, response);
                break;

            case "edit":
                try {
                    int idToEdit = Integer.parseInt(request.getParameter("id"));
                    Vehicle existingVehicle = vehicleDAO.getVehicleById(idToEdit);
                    request.setAttribute("vehicle", existingVehicle);
                    request.getRequestDispatcher("/WEB-INF/admin/vehicle-form.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/vehicle");
                }
                break;

            case "delete":
                boolean deleted = false;
                try {
                    int idToDelete = Integer.parseInt(request.getParameter("id"));
                    deleted = vehicleDAO.deleteVehicle(idToDelete);
                } catch (NumberFormatException ignored) {}
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/vehicle?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/vehicle?msg=delete_error");
                }
                break;

            default:
                listVehicles(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập và phân quyền Admin
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

        String action = request.getParameter("action");
        String licensePlate = request.getParameter("licensePlate");
        String totalSeatsStr = request.getParameter("totalSeats");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        int id = 0;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                id = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        int totalSeats = 0;
        try {
            totalSeats = Integer.parseInt(totalSeatsStr);
        } catch (NumberFormatException e) {
            totalSeats = -1;
        }

        // Validate dữ liệu khi Thêm / Sửa xe khách
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            Vehicle v = new Vehicle(id, "", totalSeats, type, status);
            if (id > 0) {
                request.setAttribute("vehicle", v);
            }
            request.setAttribute("errorMsg", "Biển số xe không được để trống!");
            request.getRequestDispatcher("/WEB-INF/admin/vehicle-form.jsp").forward(request, response);
            return;
        }

        String cleanPlate = licensePlate.trim().toUpperCase();
        if (totalSeats < 10 || totalSeats > 60) {
            Vehicle v = new Vehicle(id, cleanPlate, totalSeats, type, status);
            if (id > 0) {
                request.setAttribute("vehicle", v);
            }
            request.setAttribute("errorMsg", "Tổng số ghế của xe phải nằm trong khoảng từ 10 đến 60 chỗ!");
            request.getRequestDispatcher("/WEB-INF/admin/vehicle-form.jsp").forward(request, response);
            return;
        }

        if (vehicleDAO.existsByLicensePlate(cleanPlate, id)) {
            Vehicle v = new Vehicle(id, cleanPlate, totalSeats, type, status);
            if (id > 0) {
                request.setAttribute("vehicle", v);
            }
            request.setAttribute("errorMsg", "Biển số xe '" + cleanPlate + "' đã tồn tại trong hệ thống!");
            request.getRequestDispatcher("/WEB-INF/admin/vehicle-form.jsp").forward(request, response);
            return;
        }

        if ("insert".equals(action)) {
            Vehicle v = new Vehicle(0, cleanPlate, totalSeats, type, status);
            vehicleDAO.insertVehicle(v);
            response.sendRedirect(request.getContextPath() + "/admin/vehicle?msg=added");

        } else if ("update".equals(action)) {
            Vehicle v = new Vehicle(id, cleanPlate, totalSeats, type, status);
            vehicleDAO.updateVehicle(v);
            response.sendRedirect(request.getContextPath() + "/admin/vehicle?msg=updated");
        }
    }

    private void listVehicles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Vehicle> fullList = vehicleDAO.getAllVehicles();

        // Tích hợp phân trang (TV5)
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        PaginationUtil<Vehicle> pagination = PaginationUtil.paginate(fullList, page, 8);
        request.setAttribute("pagination", pagination);
        request.setAttribute("vehicleList", pagination.getPageItems());
        request.setAttribute("baseUrl", request.getContextPath() + "/admin/vehicle?action=list");

        request.getRequestDispatcher("/WEB-INF/admin/vehicle-list.jsp").forward(request, response);
    }
}
