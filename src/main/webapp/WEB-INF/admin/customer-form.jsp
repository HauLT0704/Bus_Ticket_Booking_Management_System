<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${customer != null ? "Cập Nhật Khách Hàng" : "Thêm Khách Hàng Mới"} - BUS BOOKING</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-custom { border: none; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background: white; }
    </style>
</head>
<body>

    <!-- Nhúng Header từ thư mục common -->
    <jsp:include page="../common/header.jsp" />

    <!-- Phần Form Nội Dung Chính -->
    <div class="container my-5" style="max-width: 650px;">
        <div class="card card-custom p-4 p-md-5">
            <h3 class="fw-bold text-dark mb-4 text-center">
                ${customer != null ? "Cập Nhật Thông Tin Khách Hàng" : "Thêm Khách Hàng Mới"}
            </h3>
            
            <form action="customer" method="POST">
                <input type="hidden" name="action" value="${customer != null ? 'update' : 'insert'}">
                <c:if test="${customer != null}">
                    <input type="hidden" name="id" value="${customer.id}">
                </c:if>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Họ và Tên:</label>
                    <input type="text" class="form-control py-2" name="fullName" value="${customer != null ? customer.fullName : ''}" required placeholder="Nhập họ và tên...">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Số Điện Thoại:</label>
                    <input type="text" class="form-control py-2" name="phone" value="${customer != null ? customer.phone : ''}" required placeholder="Nhập số điện thoại...">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Email:</label>
                    <input type="email" class="form-control py-2" name="email" value="${customer != null ? customer.email : ''}" placeholder="Nhập địa chỉ email...">
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">CCCD / ID Card:</label>
                    <input type="text" class="form-control py-2" name="idCard" value="${customer != null ? customer.idCard : ''}" placeholder="Nhập số CCCD/CMND...">
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="customer" class="btn btn-secondary px-4 py-2">Quay lại</a>
                    <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">Lưu Thông Tin</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Nhúng Footer từ thư mục common -->
    <jsp:include page="../common/footer.jsp" />

</body>
</html>