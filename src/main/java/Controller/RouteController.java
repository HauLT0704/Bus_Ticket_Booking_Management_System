package Controller;

import dao.RouteDAO;
import java.io.IOException;
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
import util.PaginationUtil;

/**
 * Controller Quản lý Tuyến đường (kèm phân trang)
 * Phân công: Nguyễn Tấn Phát (TV2) - Phối hợp phân trang TV5
 */
@WebServlet(name = "RouteController", urlPatterns = {"/admin/route", "/admin/routes"})
public class RouteController extends HttpServlet {

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

        RouteDAO routeDAO = new RouteDAO();
        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            List<Route> fullList = routeDAO.getList();

            // Tích hợp phân trang (TV5)
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) {}
            }
            PaginationUtil<Route> pagination = PaginationUtil.paginate(fullList, page, 8);
            request.setAttribute("pagination", pagination);
            request.setAttribute("list", pagination.getPageItems());
            request.setAttribute("baseUrl", request.getContextPath() + "/admin/route?action=list");

            request.getRequestDispatcher("/WEB-INF/admin/route-list.jsp").forward(request, response);

        } else if (action.equals("edit")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Route route = routeDAO.getById(id);
                if (route == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/route?msg=not_found");
                    return;
                }
                List<Location> locationList = routeDAO.getAllLocations();
                request.setAttribute("route", route);
                request.setAttribute("locationList", locationList);
                request.getRequestDispatcher("/WEB-INF/admin/route-form.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/route?msg=invalid_id");
            }
            
        } else if (action.equals("add")) {
            List<Location> locationList = routeDAO.getAllLocations();
            request.setAttribute("locationList", locationList);
            request.getRequestDispatcher("/WEB-INF/admin/route-form.jsp").forward(request, response);
            
        } else if (action.equals("delete")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Route route = routeDAO.getById(id);
                if (route == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/route?msg=not_found");
                    return;
                }
                List<Location> locationList = routeDAO.getAllLocations();
                request.setAttribute("route", route);
                request.setAttribute("locationList", locationList);
                request.setAttribute("isDelete", true);
                request.getRequestDispatcher("/WEB-INF/admin/route-form.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/route?msg=invalid_id");
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

        RouteDAO routeDAO = new RouteDAO();

        String action = request.getParameter("action");

        // Xử lý XÓA tuyến đường qua POST
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Route route = routeDAO.getById(id);
                if (route == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/route?msg=not_found");
                    return;
                }
                boolean deleted = routeDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/route?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/route?msg=delete_error");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/route?msg=invalid_id");
            }
            return;
        }

        int fromLocationId = 0;
        int toLocationId = 0;
        double distance = 0;
        int duration = 0;
        int currentId = 0;
        boolean hasParseError = false;

        try {
            fromLocationId = Integer.parseInt(request.getParameter("fromLocationId"));
            toLocationId = Integer.parseInt(request.getParameter("toLocationId"));
            if (request.getParameter("distance") != null && !request.getParameter("distance").trim().isEmpty()) {
                distance = Double.parseDouble(request.getParameter("distance").trim());
            } else {
                hasParseError = true;
            }
            if (request.getParameter("duration") != null && !request.getParameter("duration").trim().isEmpty()) {
                duration = Integer.parseInt(request.getParameter("duration").trim());
            } else {
                hasParseError = true;
            }
            if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                currentId = Integer.parseInt(request.getParameter("id"));
            }
        } catch (NumberFormatException e) {
            hasParseError = true;
        }

        List<Location> locationList = routeDAO.getAllLocations();
        String fromName = "";
        String toName = "";
        for (Location loc : locationList) {
            if (loc.getId() == fromLocationId) fromName = loc.getName();
            if (loc.getId() == toLocationId) toName = loc.getName();
        }

        // Kiểm tra ràng buộc dữ liệu
        boolean isInvalid = false;
        String errorMessage = "";

        if (hasParseError || fromLocationId <= 0 || toLocationId <= 0) {
            isInvalid = true;
            errorMessage = "Vui lòng chọn đầy đủ Điểm đi, Điểm đến và nhập đúng định dạng số!";
        } else if (fromLocationId == toLocationId) {
            isInvalid = true;
            errorMessage = "Điểm đi và Điểm đến không được trùng nhau!";
        } else if (distance < 20.0 || distance > 1000.0) {
            isInvalid = true;
            errorMessage = "Khoảng cách tuyến đường phải từ 20.0 km đến 1,000.0 km!";
        } else if (duration < 30 || duration > 1440) {
            isInvalid = true;
            errorMessage = "Thời gian di chuyển dự kiến phải từ 30 phút đến 1,440 phút (tối đa 24 giờ)!";
        } else if (routeDAO.existsByLocations(fromLocationId, toLocationId, currentId)) {
            isInvalid = true;
            errorMessage = "Tuyến đường giữa 2 địa điểm này đã tồn tại trong hệ thống!";
        }

        if (isInvalid) {
            request.setAttribute("locationList", locationList);

            Route route = new Route();
            route.setId(currentId);
            route.setDistance(distance > 0 ? distance : 0);
            route.setDuration(duration > 0 ? duration : 0);
            Location fromLoc = new Location(fromLocationId, fromName);
            Location toLoc = new Location(toLocationId, toName);
            route.setFromLocation(fromLoc);
            route.setToLocation(toLoc);

            request.setAttribute("route", route);
            request.setAttribute("errorMsg", errorMessage);
            request.getRequestDispatcher("/WEB-INF/admin/route-form.jsp").forward(request, response);
            return;
        }

        if ("insert".equals(action)) {
            Route route = new Route();
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
            if (currentId <= 0 || routeDAO.getById(currentId) == null) {
                response.sendRedirect(request.getContextPath() + "/admin/route?msg=not_found");
                return;
            }
            int id = currentId;
            Route route = new Route();
            route.setId(id);

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
