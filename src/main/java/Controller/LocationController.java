package Controller;

import dao.LocationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Location;
import model.User;
import util.PaginationUtil;

/**
 * Phân công: Lâm Trung Hậu
 */
@WebServlet(name = "LocationController", urlPatterns = {"/admin/location"})
public class LocationController extends HttpServlet {

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
        
        LocationDAO locationDAO = new LocationDAO();
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        if (action.equals("list")) {
            List<Location> fullList = locationDAO.getAll();

            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) {}
            }
            PaginationUtil<Location> pagination = PaginationUtil.paginate(fullList, page, 8);
            request.setAttribute("pagination", pagination);
            request.setAttribute("locationList", pagination.getPageItems());
            request.setAttribute("baseUrl", request.getContextPath() + "/admin/location?action=list");

            request.getRequestDispatcher("/WEB-INF/admin/location-list.jsp").forward(request, response);
        } else if (action.equals("edit")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Location loc = locationDAO.getById(id);
                if (loc == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/location?msg=not_found");
                    return;
                }
                request.setAttribute("location", loc);
                request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/location?msg=invalid_id");
            }
        } else if (action.equals("add")) {
            request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Location loc = locationDAO.getById(id);
                if (loc == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/location?msg=not_found");
                    return;
                }
                request.setAttribute("location", loc);
                request.setAttribute("isDelete", true);
                request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/location?msg=invalid_id");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
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

        LocationDAO locationDAO = new LocationDAO();
        String action = request.getParameter("action");

        // Xử lý XÓA địa điểm qua POST
        if ("delete".equals(action)) {
            try {
                int idToDelete = Integer.parseInt(request.getParameter("id"));
                Location loc = locationDAO.getById(idToDelete);
                if (loc == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/location?msg=not_found");
                    return;
                }
                boolean deleted = locationDAO.delete(idToDelete);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/location?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/location?msg=delete_error");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/location?msg=invalid_id");
            }
            return;
        }

        String name = request.getParameter("name");
        
        int id = 0;
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                id = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        // Validate dữ liệu đầu vào khi Thêm / Sửa
        if (name == null || name.trim().isEmpty()) {
            Location loc = new Location(id, "");
            if (id > 0) {
                request.setAttribute("location", loc);
            }
            request.setAttribute("errorMsg", "Tên tỉnh / thành phố không được để trống!");
            request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
            return;
        }

        String cleanName = name.trim();
        if (cleanName.length() < 2 || cleanName.length() > 100) {
            Location loc = new Location(id, cleanName);
            if (id > 0) {
                request.setAttribute("location", loc);
            }
            request.setAttribute("errorMsg", "Tên tỉnh / thành phố phải từ 2 đến 100 ký tự!");
            request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
            return;
        }

        if (locationDAO.existsByName(cleanName, id)) {
            Location loc = new Location(id, cleanName);
            if (id > 0) {
                request.setAttribute("location", loc);
            }
            request.setAttribute("errorMsg", "Tỉnh / thành phố '" + cleanName + "' đã tồn tại trong hệ thống!");
            request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
            return;
        }
        
        if ("insert".equals(action)) {
            Location loc = new Location(cleanName);
            locationDAO.insert(loc);
            response.sendRedirect(request.getContextPath() + "/admin/location?msg=added");
        } else if ("update".equals(action)) {
            if (id <= 0 || locationDAO.getById(id) == null) {
                response.sendRedirect(request.getContextPath() + "/admin/location?msg=not_found");
                return;
            }
            Location loc = new Location(id, cleanName);
            locationDAO.update(loc);
            response.sendRedirect(request.getContextPath() + "/admin/location?msg=updated");
        }
    }
}
