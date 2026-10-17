package Controller;

import dao.CustomerDAO;
import model.Customer;
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
@WebServlet(name = "CustomerController", urlPatterns = {"/customer"})
public class CustomerController extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();

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
                // Mở trang form để điền thông tin thêm mới
                request.getRequestDispatcher("/WEB-INF/admin/customer-form.jsp").forward(request, response);
                break;

            case "edit":
                // Lấy ID khách hàng cần sửa và mở form điền thông tin cũ
                int idToEdit = Integer.parseInt(request.getParameter("id"));
                Customer existingCustomer = customerDAO.getCustomerById(idToEdit);
                request.setAttribute("customer", existingCustomer);
                request.getRequestDispatcher("/WEB-INF/admin/customer-form.jsp").forward(request, response);
                break;

            case "delete":
                // Xóa khách hàng theo ID rồi quay lại trang danh sách
                int idToDelete = Integer.parseInt(request.getParameter("id"));
                customerDAO.deleteCustomer(idToDelete);
                response.sendRedirect("customer");
                break;

            default:
                // Hiển thị danh sách khách hàng
                listCustomers(request, response);
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
            // Lấy dữ liệu từ form thêm mới
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String idCard = request.getParameter("idCard");

            Customer c = new Customer(0, fullName, phone, email, idCard);
            customerDAO.insertCustomer(c);
            response.sendRedirect("customer");

        } else if ("update".equals(action)) {
            // Lấy dữ liệu từ form cập nhật
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String idCard = request.getParameter("idCard");

            Customer c = new Customer(id, fullName, phone, email, idCard);
            customerDAO.updateCustomer(c);
            response.sendRedirect("customer");
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Customer> list = customerDAO.getAllCustomers();
        request.setAttribute("customerList", list);
        request.getRequestDispatcher("/WEB-INF/admin/customer-list.jsp").forward(request, response);
    }
}