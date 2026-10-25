<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${vehicle != null ? "Cập Nhật Xe Khách" : "Thêm Xe Mới"} - BUS BOOKING</title>
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

    <!-- 1. Nhúng Header dùng chung -->
    <jsp:include page="../common/header.jsp" />

    <!-- 2. Phần Form Nội Dung Chính -->
    <div class="container my-5" style="max-width: 650px;">
        <div class="card card-custom p-4 p-md-5">
            <h3 class="fw-bold text-dark mb-4 text-center">
                ${vehicle != null ? "Cập Nhật Thông Tin Xe" : "Thêm Xe Khách Mới"}
            </h3>
            
            <form action="vehicle" method="POST">
                <input type="hidden" name="action" value="${vehicle != null ? 'update' : 'insert'}">
                <c:if test="${vehicle != null}">
                    <input type="hidden" name="id" value="${vehicle.id}">
                </c:if>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Biển Số Xe:</label>
                    <input type="text" class="form-control py-2" name="licensePlate" value="${vehicle != null ? vehicle.licensePlate : ''}" required placeholder="Ví dụ: 51B-123.45">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Số Ghế:</label>
                    <input type="number" class="form-control py-2" name="totalSeats" value="${vehicle != null ? vehicle.totalSeats : '40'}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Loại Xe:</label>
                    <select name="type" class="form-select py-2">
                        <option value="Giường nằm" ${vehicle != null && vehicle.type == 'Giường nằm' ? 'selected' : ''}>Giường nằm</option>
                        <option value="Limousine VIP" ${vehicle != null && vehicle.type == 'Limousine VIP' ? 'selected' : ''}>Limousine VIP</option>
                        <option value="Ghế ngồi" ${vehicle != null && vehicle.type == 'Ghế ngồi' ? 'selected' : ''}>Ghế ngồi</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Trạng Thái:</label>
                    <select name="status" class="form-select py-2">
                        <option value="Hoạt động" ${vehicle != null && vehicle.status == 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
                        <option value="Bảo dưỡng" ${vehicle != null && vehicle.status == 'Bảo dưỡng' ? 'selected' : ''}>Bảo dưỡng</option>
                        <option value="Tạm ngưng" ${vehicle != null && vehicle.status == 'Tạm ngưng' ? 'selected' : ''}>Tạm ngưng</option>
                    </select>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="vehicle" class="btn btn-secondary px-4 py-2">Quay lại</a>
                    <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">Lưu Thông Tin</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 3. Nhúng Footer dùng chung -->
    <jsp:include page="../common/footer.jsp" />

</body>
</html>