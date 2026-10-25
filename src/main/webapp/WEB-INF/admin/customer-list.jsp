<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khách Hàng - BUS BOOKING</title>
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

    <!-- Nhúng Header từ thư mục common -->
    <jsp:include page="../common/header.jsp" />

    <!-- Nội dung chính (Danh sách Khách Hàng) -->
    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Quản Lý Khách Hàng</h3>
                <p class="text-muted mb-0" style="font-size: 14px;">Xem và quản lý thông tin khách hàng trong hệ thống</p>
            </div>
            <a href="customer?action=add" class="btn btn-primary fw-semibold px-3 py-2">+ Thêm Khách Hàng Mới</a>
        </div>

        <div class="card card-custom p-4">
            <h5 class="fw-bold mb-3 text-secondary">Danh sách khách hàng</h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr class="table-dark-custom">
                            <th class="py-3 ps-3">ID</th>
                            <th class="py-3">Họ và Tên</th>
                            <th class="py-3">Số Điện Thoại</th>
                            <th class="py-3">Email</th>
                            <th class="py-3">CCCD / ID Card</th>
                            <th class="py-3 text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${customerList}">
                            <tr>
                                <td class="ps-3">${c.id}</td>
                                <td class="fw-semibold">${c.fullName}</td>
                                <td>${c.phone}</td>
                                <td>${c.email}</td>
                                <td>${c.idCard}</td>
                                <td class="text-center">
                                    <a href="customer?action=edit&id=${c.id}" class="btn btn-sm btn-primary px-3">Sửa</a>
                                    <a href="customer?action=delete&id=${c.id}" class="btn btn-sm btn-danger px-3" onclick="return confirm('Bạn có chắc muốn xóa khách hàng này?');">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Nhúng Footer từ thư mục common -->
    <jsp:include page="../common/footer.jsp" />

</body>
</html>