<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khách Hàng - Hệ Thống Bến Xe</title>
    <style>
        :root {
            --sidebar-width: 250px;
            --primary-color: #1e293b;
            --accent-color: #2563eb;
            --bg-color: #f8fafc;
        }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-color); margin: 0; display: flex; }
        
        /* Sidebar */
        .sidebar { width: var(--sidebar-width); background-color: var(--primary-color); color: white; height: 100vh; position: fixed; padding: 20px; box-sizing: border-box; }
        .sidebar h2 { font-size: 18px; color: #38bdf8; margin-bottom: 30px; text-transform: uppercase; letter-spacing: 1px; text-align: center; }
        .sidebar a { display: block; color: #94a3b8; text-decoration: none; padding: 12px 15px; border-radius: 6px; margin-bottom: 8px; font-weight: 500; transition: 0.2s; }
        .sidebar a:hover, .sidebar a.active { background-color: var(--accent-color); color: white; }
        
        /* Main Content */
        .main-content { margin-left: var(--sidebar-width); flex: 1; padding: 30px; box-sizing: border-box; }
        .header-bar { display: flex; justify-content: space-between; align-items: center; background: white; padding: 15px 25px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); margin-bottom: 25px; }
        .header-bar h2 { margin: 0; color: #1e293b; font-size: 22px; }
        
        /* Table & Card */
        .card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .btn-add { background-color: var(--accent-color); color: white; padding: 10px 16px; text-decoration: none; border-radius: 6px; font-weight: 600; font-size: 14px; }
        .btn-add:hover { background-color: #1d4ed8; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        th { background-color: #f8fafc; color: #475569; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; }
        tr:hover { background-color: #f8fafc; }
        
        .action-links a { text-decoration: none; font-weight: 600; margin-right: 12px; font-size: 14px; }
        .action-edit { color: #d97706; }
        .action-edit:hover { color: #b45309; }
        .action-delete { color: #dc2626; }
        .action-delete:hover { color: #b91c1c; }
    </style>
</head>
<body>

    <!-- Sidebar hệ thống bến xe -->
    <div class="sidebar">
        <h2>GooXe Management</h2>
        <a href="customer" class="active">Quản Lý Khách Hàng</a>
        <a href="vehicle">Quản Lý Xe Khách</a>
    </div>

    <!-- Nội dung chính -->
    <div class="main-content">
        <div class="header-bar">
            <h2>Quản Lý Khách Hàng</h2>
            <span style="color: #64748b; font-weight: 500;">Xin chào, TV3 (Phan Thanh Tú)</span>
        </div>

        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h3 style="margin: 0; font-size: 16px; color: #334155;">Danh sách khách hàng trên hệ thống</h3>
                <a href="customer?action=add" class="btn-add">+ Thêm Khách Hàng Mới</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và Tên</th>
                        <th>Số Điện Thoại</th>
                        <th>Email</th>
                        <th>CCCD / ID Card</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${customerList}">
                        <tr>
                            <td>${c.id}</td>
                            <td><strong>${c.fullName}</strong></td>
                            <td>${c.phone}</td>
                            <td>${c.email}</td>
                            <td>${c.idCard}</td>
                            <td class="action-links">
                                <a href="customer?action=edit&id=${c.id}" class="action-edit">Sửa</a>
                                <a href="customer?action=delete&id=${c.id}" class="action-delete" onclick="return confirm('Bạn có chắc muốn xóa khách hàng này?');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>