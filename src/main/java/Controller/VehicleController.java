package Controller;

import dao.VehicleDAO;
import model.Vehicle;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * @author Phan Thanh Tu (TV3)
 */
@WebServlet(name = "VehicleController", urlPatterns = {"/vehicle"})
public class VehicleController extends HttpServlet {

    private VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                // Mở trang form để điền thông tin thêm xe mới
                request.getRequestDispatcher("/WEB-INF/admin/vehicle-form.jsp").forward(request, response);
                break;

            case "edit":
                // Lấy ID xe cần sửa và mở form điền thông tin cũ
                int idToEdit = Integer.parseInt(request.getParameter("id"));
                Vehicle existingVehicle = vehicleDAO.getVehicleById(idToEdit);
                request.setAttribute("vehicle", existingVehicle);
                request.getRequestDispatcher("/WEB-INF/admin/vehicle-form.jsp").forward(request, response);
                break;

            case "delete":
                // Xóa xe theo ID rồi quay lại trang danh sách xe
                int idToDelete = Integer.parseInt(request.getParameter("id"));
                vehicleDAO.deleteVehicle(idToDelete);
                response.sendRedirect("vehicle");
                break;

            default:
                // Hiển thị danh sách xe khách
                listVehicles(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            // Lấy dữ liệu từ form thêm xe mới
            String licensePlate = request.getParameter("licensePlate");
            int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
            String type = request.getParameter("type");
            String status = request.getParameter("status");

            Vehicle v = new Vehicle(0, licensePlate, totalSeats, type, status);
            vehicleDAO.insertVehicle(v);
            response.sendRedirect("vehicle");

        } else if ("update".equals(action)) {
            // Lấy dữ liệu từ form cập nhật xe
            int id = Integer.parseInt(request.getParameter("id"));
            String licensePlate = request.getParameter("licensePlate");
            int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
            String type = request.getParameter("type");
            String status = request.getParameter("status");

            Vehicle v = new Vehicle(id, licensePlate, totalSeats, type, status);
            vehicleDAO.updateVehicle(v);
            response.sendRedirect("vehicle");
        }
    }

    private void listVehicles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Vehicle> list = vehicleDAO.getAllVehicles();
        request.setAttribute("vehicleList", list);
        request.getRequestDispatcher("/WEB-INF/admin/vehicle-list.jsp").forward(request, response);
    }
}