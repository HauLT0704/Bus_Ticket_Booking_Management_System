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
                boolean deleted = routeDAO.delete(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/route?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/route?msg=delete_error");
                }
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

        int fromLocationId = 0;
        int toLocationId = 0;
        double distance = 0;
        int duration = 0;
        int currentId = 0;

        try {
            fromLocationId = Integer.parseInt(request.getParameter("fromLocationId"));
            toLocationId = Integer.parseInt(request.getParameter("toLocationId"));
            distance = Double.parseDouble(request.getParameter("distance"));
            duration = Integer.parseInt(request.getParameter("duration"));
            if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                currentId = Integer.parseInt(request.getParameter("id"));
            }
        } catch (NumberFormatException e) {
            distance = -1;
        }
        
        if (distance <= 0 || distance > 1000 || duration <= 0 || duration > 1000 || fromLocationId <= 0 || toLocationId <= 0 || fromLocationId == toLocationId) {
            List<Location> locationList = routeDAO.getAllLocations();
            request.setAttribute("locationList", locationList);

            Route route = new Route();
            route.setId(currentId);
            route.setDistance(distance);
            route.setDuration(duration);
            Location fromLoc = new Location(); fromLoc.setId(fromLocationId);
            Location toLoc = new Location(); toLoc.setId(toLocationId);
            route.setFromLocation(fromLoc);
            route.setToLocation(toLoc);

            request.setAttribute("route", route);
            request.setAttribute("errorMsg", "Vui lòng chọn điểm đi khác điểm đến, quãng đường & thời gian dự kiến nằm trong khoảng từ 1 đến 1000!");
            request.getRequestDispatcher("/WEB-INF/admin/route-form.jsp").forward(request, response);
            return;
        }

        if (routeDAO.existsByLocations(fromLocationId, toLocationId, currentId)) {
            List<Location> locationList = routeDAO.getAllLocations();
            request.setAttribute("locationList", locationList);

            Route route = new Route();
            route.setId(currentId);
            route.setDistance(distance);
            route.setDuration(duration);
            Location fromLoc = new Location(); fromLoc.setId(fromLocationId);
            Location toLoc = new Location(); toLoc.setId(toLocationId);
            route.setFromLocation(fromLoc);
            route.setToLocation(toLoc);

            request.setAttribute("route", route);
            request.setAttribute("errorMsg", "Tuyến đường giữa 2 địa điểm này đã tồn tại trong hệ thống!");
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
