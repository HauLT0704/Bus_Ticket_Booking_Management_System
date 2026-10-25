<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Xe Khách - BUS BOOKING</title>
    <!-- Sử dụng Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        /* Cấu hình Flexbox để ép footer luôn xuống sát đáy màn hình */
        html, body {
            height: 100%;
            margin: 0;
        }
        body {
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container.my-4 {
            flex: 1; /* Giúp phần nội dung giãn nở, đẩy footer xuống */
        }
        
        .table-dark-custom { background-color: #212529; color: white; }
        .card-custom { border: none; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); background: white; }
    </style>
</head>
<body>

    <!-- 1. Nhúng Header dùng chung -->
    <jsp:include page="../common/header.jsp" />

    <!-- 2. Nội dung chính (Danh sách Xe Khách) -->
    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Quản Lý Xe Khách</h3>
                <p class="text-muted mb-0" style="font-size: 14px;">Xem và quản lý phương tiện vận chuyển trong hệ thống</p>
            </div>
            <a href="vehicle?action=add" class="btn btn-primary fw-semibold px-3 py-2">+ Thêm Xe Mới</a>
        </div>

        <div class="card card-custom p-4">
            <h5 class="fw-bold mb-3 text-secondary">Danh sách phương tiện</h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr class="table-dark-custom">
                            <th class="py-3 ps-3">ID</th>
                            <th class="py-3">Biển Số Xe</th>
                            <th class="py-3">Số Ghế</th>
                            <th class="py-3">Loại Xe</th>
                            <th class="py-3">Trạng Thái</th>
                            <th class="py-3 text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="v" items="${vehicleList}">
                            <tr>
                                <td class="ps-3">${v.id}</td>
                                <td class="fw-bold">${v.licensePlate}</td>
                                <td>${v.totalSeats} chỗ</td>
                                <td><span class="badge bg-info text-dark">${v.type}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.status == 'Hoạt động'}">
                                            <span class="badge bg-success">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${v.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <a href="vehicle?action=edit&id=${v.id}" class="btn btn-sm btn-primary px-3">Sửa</a>
                                    <a href="vehicle?action=delete&id=${v.id}" class="btn btn-sm btn-danger px-3" onclick="return confirm('Bạn có chắc muốn xóa xe này?');">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- 3. Nhúng Footer dùng chung -->
    <jsp:include page="../common/footer.jsp" />

</body>
</html>