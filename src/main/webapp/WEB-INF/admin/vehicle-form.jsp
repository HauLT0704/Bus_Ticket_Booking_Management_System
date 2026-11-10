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

        <!-- Thêm / Sửa / Xóa Xe Khách -->
        <div class="container my-5" style="max-width: 600px;">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">
                <div class="text-center mb-4">
                    <c:choose>
                        <c:when test="${isDelete}">
                            <div class="fs-1 text-danger mb-2"><i class="bi bi-trash3-fill"></i></div>
                            <h3 class="fw-bold text-danger mb-1">Xác Nhận Xóa Xe Khách</h3>
                            <p class="text-secondary small mb-0">Xem lại thông tin xe khách trước khi xác nhận xóa khỏi hệ thống</p>
                        </c:when>
                        <c:when test="${vehicle != null and vehicle.id > 0}">
                            <div class="fs-1 text-warning mb-2"><i class="bi bi-pencil-square"></i></div>
                            <h3 class="fw-bold text-dark mb-1">Cập Nhật Xe Khách</h3>
                            <p class="text-secondary small mb-0">Cập nhật thông tin chi tiết xe khách</p>
                        </c:when>
                        <c:otherwise>
                            <div class="fs-1 text-primary mb-2"><i class="bi bi-truck-front-fill"></i></div>
                            <h3 class="fw-bold text-dark mb-1">Thêm Xe Khách Mới</h3>
                            <p class="text-secondary small mb-0">Điền thông tin để đăng ký xe khách mới</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- CẢNH BÁO NẾU ĐANG Ở CHẾ ĐỘ XÓA -->
                <c:if test="${isDelete}">
                    <div class="alert alert-warning border-warning d-flex align-items-center mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill fs-3 text-warning me-3"></i>
                        <div class="small">
                            <strong>Cảnh báo quan trọng:</strong> Hành động này sẽ xóa xe khách khỏi hệ thống. Nếu xe này đang được phân công chạy các chuyến xe, việc xóa có thể bị từ chối để đảm bảo toàn vẹn dữ liệu.
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/vehicle" method="POST">
                    <c:choose>
                        <c:when test="${isDelete}">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${vehicle.id}">
                        </c:when>
                        <c:when test="${vehicle != null and vehicle.id > 0}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${vehicle.id}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="insert">
                        </c:otherwise>
                    </c:choose>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Biển Số Xe: <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if></label>
                        <input type="text" class="form-control py-2 text-uppercase <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                               name="licensePlate" 
                               value="${vehicle != null ? vehicle.licensePlate : ''}" required 
                               placeholder="Ví dụ: 65B-123.45"
                               pattern="[0-9]{2}[A-Za-z]-([0-9]{3}\.[0-9]{2}|[0-9]{4,5})"
                               title="Định dạng biển số xe: ví dụ 65B-123.45 hoặc 65B-12345"
                               <c:if test="${isDelete}">readonly</c:if>>
                        <c:if test="${!isDelete}">
                            <div class="form-text small text-muted">Định dạng chuẩn: <b>65B-123.45</b> (hoặc 65B-12345)</div>
                        </c:if>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tổng Số Ghế: <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if></label>
                        <input type="number" class="form-control py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                               name="totalSeats" min="10" max="60"
                               value="${vehicle != null ? vehicle.totalSeats : 40}" required
                               <c:if test="${isDelete}">readonly</c:if>>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Loại Xe: <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if></label>
                        <select class="form-select py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                                name="type" required <c:if test="${isDelete}">disabled</c:if>>
                            <option value="Giường nằm" ${vehicle != null && vehicle.type == 'Giường nằm' ? 'selected' : ''}>Giường nằm</option>
                            <option value="Limousine VIP" ${vehicle != null && vehicle.type == 'Limousine VIP' ? 'selected' : ''}>Limousine VIP</option>
                            <option value="Ghế ngồi" ${vehicle != null && vehicle.type == 'Ghế ngồi' ? 'selected' : ''}>Ghế ngồi</option>
                        </select>
                    </div>

                    <input type="hidden" name="status" value="${vehicle != null && vehicle.status != null ? vehicle.status : 'Hoạt động'}">

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/admin/vehicle" class="btn btn-outline-secondary px-4 py-2">
                            <i class="bi bi-arrow-left me-1"></i> <c:choose><c:when test="${isDelete}">Hủy Bỏ</c:when><c:otherwise>Quay lại</c:otherwise></c:choose>
                        </a>
                        <c:choose>
                            <c:when test="${isDelete}">
                                <button type="submit" class="btn btn-danger px-4 py-2 fw-semibold">
                                    <i class="bi bi-trash3-fill me-1"></i> Xác Nhận Xóa
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">
                                    <i class="bi bi-check2-circle me-1"></i> Lưu Thông Tin
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />

    </body>
</html>
