/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import dao.LocationDAO;
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
import model.User;

/**
 *
 * @author Lâm Trung Hậu
 */
@WebServlet(name = "LocationController", urlPatterns = {"/admin/location"})
public class LocationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session==null) {
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
        
        if (action == null || action.equals("list")) {
            List<Location> list = locationDAO.getAll();
            request.setAttribute("locationList", list);
            request.getRequestDispatcher("/WEB-INF/admin/location-list.jsp").forward(request, response);
        } else if (action.equals("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Location loc = locationDAO.getById(id);
            request.setAttribute("location", loc);
            request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
        } else if (action.equals("add")) {
            request.getRequestDispatcher("/WEB-INF/admin/location-form.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            locationDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/location?msg=deleted");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        LocationDAO locationDAO = new LocationDAO();
        
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String province = request.getParameter("province");
        
        if ("insert".equals(action)) {
            Location loc = new Location(name, province);
            locationDAO.insert(loc);
            response.sendRedirect(request.getContextPath() + "/admin/location?msg=added");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Location loc = new Location(id, name, province);
            locationDAO.update(loc);
            response.sendRedirect(request.getContextPath() + "/admin/location?msg=updated");
        }
    }
}
