package Controller;

import dao.CustomerDAO;
import dao.UserDAO;
import model.Customer;
import model.User;
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
 * Controller Quản lý Khách hàng (kèm tìm kiếm và phân trang)
 * Phân công: Phan Thanh Tu (TV3) - Phối hợp phân trang TV5
 */
@WebServlet(name = "CustomerController", urlPatterns = {"/customer", "/admin/customer", "/admin/customers"})
public class CustomerController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final UserDAO userDAO = new UserDAO();

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
                request.getRequestDispatcher("/WEB-INF/admin/customer-form.jsp").forward(request, response);
                break;

            case "edit":
                try {
                    int idToEdit = Integer.parseInt(request.getParameter("id"));
                    Customer existingCustomer = customerDAO.getCustomerById(idToEdit);
                    if (existingCustomer == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/customer?msg=not_found");
                        return;
                    }
                    request.setAttribute("customer", existingCustomer);
                    request.getRequestDispatcher("/WEB-INF/admin/customer-form.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/customer?msg=invalid_id");
                }
                break;

            case "delete":
                try {
                    int idToDelete = Integer.parseInt(request.getParameter("id"));
                    Customer existingCustomer = customerDAO.getCustomerById(idToDelete);
                    if (existingCustomer == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/customer?msg=not_found");
                        return;
                    }
                    request.setAttribute("customer", existingCustomer);
                    request.getRequestDispatcher("/WEB-INF/admin/customer-delete.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/customer?msg=invalid_id");
                }
                break;

            case "lock":
                try {
                    int userIdToLock = Integer.parseInt(request.getParameter("userId"));
                    userDAO.lockUser(userIdToLock);
                    response.sendRedirect(request.getContextPath() + "/admin/customer?msg=user_locked");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/admin/customer?msg=invalid_id");
                }
                break;

            case "unlock":
                try {
                    int userIdToUnlock = Integer.parseInt(request.getParameter("userId"));
                    userDAO.unlockUser(userIdToUnlock);
                    response.sendRedirect(request.getContextPath() + "/admin/customer?msg=user_unlocked");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/admin/customer?msg=invalid_id");
                }
                break;

            default:
                listCustomers(request, response);
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

        // Xử lý XÓA khách hàng (Bằng phương thức POST chuẩn an toàn)
        if ("delete".equals(action)) {
            int idToDelete = 0;
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    idToDelete = Integer.parseInt(idParam.trim());
                } catch (NumberFormatException ignored) {}
            }
            if (idToDelete <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/customer?msg=invalid_id");
                return;
            }
            Customer existingCustomer = customerDAO.getCustomerById(idToDelete);
            if (existingCustomer == null) {
                response.sendRedirect(request.getContextPath() + "/admin/customer?msg=not_found");
                return;
            }
            boolean deleted = customerDAO.deleteCustomer(idToDelete);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/customer?msg=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/customer?msg=delete_error");
            }
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String idCard = request.getParameter("idCard");

        int id = 0;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                id = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        // Validate dữ liệu khi Thêm / Sửa khách hàng
        if (fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            Customer c = new Customer(id, fullName, phone, email, idCard);
            if (id > 0) {
                request.setAttribute("customer", c);
            }
            request.setAttribute("errorMsg", "Họ tên và Số điện thoại của khách hàng không được để trống!");
            request.getRequestDispatcher("/WEB-INF/admin/customer-form.jsp").forward(request, response);
            return;
        }

        String cleanPhone = phone.trim();
        if (!cleanPhone.matches("^0[0-9]{8,10}$")) {
            Customer c = new Customer(id, fullName.trim(), cleanPhone, email, idCard);
            if (id > 0) {
                request.setAttribute("customer", c);
            }
            request.setAttribute("errorMsg", "Số điện thoại không hợp lệ (phải bắt đầu bằng số 0 và gồm 9 - 11 chữ số)!");
            request.getRequestDispatcher("/WEB-INF/admin/customer-form.jsp").forward(request, response);
            return;
        }

        if (customerDAO.existsByPhone(cleanPhone, id)) {
            Customer c = new Customer(id, fullName.trim(), cleanPhone, email, idCard);
            if (id > 0) {
                request.setAttribute("customer", c);
            }
            request.setAttribute("errorMsg", "Số điện thoại '" + cleanPhone + "' đã được đăng ký cho khách hàng khác!");
            request.getRequestDispatcher("/WEB-INF/admin/customer-form.jsp").forward(request, response);
            return;
        }

        if ("insert".equals(action)) {
            Customer c = new Customer(0, fullName.trim(), cleanPhone, email, idCard);
            customerDAO.insertCustomer(c);
            response.sendRedirect(request.getContextPath() + "/admin/customer?msg=added");

        } else if ("update".equals(action)) {
            if (id <= 0 || customerDAO.getCustomerById(id) == null) {
                response.sendRedirect(request.getContextPath() + "/admin/customer?msg=not_found");
                return;
            }
            Customer c = new Customer(id, fullName.trim(), cleanPhone, email, idCard);
            customerDAO.updateCustomer(c);
            response.sendRedirect(request.getContextPath() + "/admin/customer?msg=updated");
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Customer> fullList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            fullList = customerDAO.searchCustomers(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            fullList = customerDAO.getAllCustomers();
        }

        // Tích hợp phân trang (TV5)
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        PaginationUtil<Customer> pagination = PaginationUtil.paginate(fullList, page, 8);
        request.setAttribute("pagination", pagination);
        request.setAttribute("customerList", pagination.getPageItems());

        String baseUrl = request.getContextPath() + "/admin/customer?action=list";
        if (keyword != null && !keyword.trim().isEmpty()) {
            baseUrl += "&keyword=" + java.net.URLEncoder.encode(keyword.trim(), "UTF-8");
        }
        request.setAttribute("baseUrl", baseUrl);

        request.getRequestDispatcher("/WEB-INF/admin/customer-list.jsp").forward(request, response);
    }
}
