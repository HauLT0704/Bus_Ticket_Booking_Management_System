<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Xe Khách - Vé Xe Miền Tây</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">

        <jsp:include page="../common/header.jsp" />

        <!--Thêm / Sửa Xe Khách -->
        <div class="container my-5" style="max-width: 600px;">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">
                <h3 class="fw-bold text-dark mb-4 text-center">
                    <i class="bi bi-truck-front-fill text-primary me-2"></i>
                    <c:choose>
                        <c:when test="${vehicle != null and vehicle.id > 0}">Cập Nhật Xe Khách</c:when>
                        <c:otherwise>Thêm Xe Khách Mới</c:otherwise>
                    </c:choose>
                </h3>

                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/vehicle" method="POST">
                    <c:choose>
                        <c:when test="${vehicle != null and vehicle.id > 0}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${vehicle.id}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="insert">
                        </c:otherwise>
                    </c:choose>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Biển Số Xe: <span class="text-danger">*</span></label>
                        <input type="text" class="form-control py-2" name="licensePlate" 
                               value="${vehicle != null ? vehicle.licensePlate : ''}" required 
                               placeholder="Ví dụ: 65B-123.45">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tổng Số Ghế: <span class="text-danger">*</span></label>
                        <input type="number" class="form-control py-2" name="totalSeats" min="10" max="60"
                               value="${vehicle != null ? vehicle.totalSeats : 40}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Loại Xe: <span class="text-danger">*</span></label>
                        <select class="form-select py-2" name="type" required>
                            <option value="Giường nằm" ${vehicle != null && vehicle.type == 'Giường nằm' ? 'selected' : ''}>Giường nằm</option>
                            <option value="Limousine VIP" ${vehicle != null && vehicle.type == 'Limousine VIP' ? 'selected' : ''}>Limousine VIP</option>
                            <option value="Ghế ngồi" ${vehicle != null && vehicle.type == 'Ghế ngồi' ? 'selected' : ''}>Ghế ngồi</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Trạng Thái: <span class="text-danger">*</span></label>
                        <select class="form-select py-2" name="status" required>
                            <option value="Hoạt động" ${vehicle != null && vehicle.status == 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
                            <option value="Bảo dưỡng" ${vehicle != null && vehicle.status == 'Bảo dưỡng' ? 'selected' : ''}>Bảo dưỡng</option>
                            <option value="Ngừng hoạt động" ${vehicle != null && vehicle.status == 'Ngừng hoạt động' ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/vehicle" class="btn btn-outline-secondary px-4 py-2">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Lưu Thông Tin
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />

    </body>
</html>
