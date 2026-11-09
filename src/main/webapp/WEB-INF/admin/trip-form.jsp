<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Chuyến Xe - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container my-5" style="max-width: 680px;">
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">

            <!-- ICON & TIÊU ĐỀ -->
            <div class="text-center mb-4">
                <div class="fs-1 text-primary mb-2">
                    <c:choose>
                        <c:when test="${trip != null && trip.id != 0}">
                            <i class="bi bi-pencil-square text-warning"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-calendar-plus text-primary"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h4 class="fw-bold text-dark mb-1">
                    <c:choose>
                        <c:when test="${trip != null && trip.id != 0}">Cập Nhật Chuyến Xe</c:when>
                        <c:otherwise>Thêm Chuyến Xe Mới</c:otherwise>
                    </c:choose>
                </h4>
                <p class="text-secondary small mb-0">Thiết lập lịch trình chuyến xe, số ghế và giá vé</p>
            </div>

            <!-- THÔNG BÁO LỖI -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Lỗi!</strong> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FORM NHẬP LIỆU -->
            <form action="${pageContext.request.contextPath}/admin/trip" method="POST" novalidate>
                <c:choose>
                    <c:when test="${trip != null && trip.id != 0}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${trip.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="insert">
                    </c:otherwise>
                </c:choose>

                <!-- TUYẾN ĐƯỜNG -->
                <div class="mb-3">
                    <label for="routeId" class="form-label fw-semibold text-secondary small">
                        TUYẾN ĐƯỜNG: <span class="text-danger">*</span>
                    </label>
                    <select class="form-select py-2" id="routeId" name="routeId" required>
                        <option value="">-- Chọn tuyến đường --</option>
                        <c:forEach var="r" items="${routeList}">
                            <option value="${r.id}" <c:if test="${trip != null && trip.route != null && trip.route.id == r.id}">selected</c:if>>
                                ${r.fromLocation.name} &rarr; ${r.toLocation.name} (${r.distance} km)
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- XE VẬN HÀNH -->
                <div class="mb-3">
                    <label for="vehicleId" class="form-label fw-semibold text-secondary small">
                        XE VẬN HÀNH: <span class="text-danger">*</span>
                    </label>
                    <select class="form-select py-2" id="vehicleId" name="vehicleId" required>
                        <option value="">-- Chọn xe phục vụ --</option>
                        <c:forEach var="v" items="${vehicleList}">
                            <option value="${v.id}" <c:if test="${trip != null && trip.vehicle != null && trip.vehicle.id == v.id}">selected</c:if>>
                                ${v.licensePlate} - ${v.type} (${v.totalSeats} chỗ)
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <c:set var="depVal" value="" />
                <c:if test="${trip != null && trip.departureTime != null}">
                    <c:set var="depVal" value="${trip.departureTime.toString().substring(0,16).replace(' ', 'T')}" />
                </c:if>
                <c:set var="arrVal" value="" />
                <c:if test="${trip != null && trip.arrivalTime != null}">
                    <c:set var="arrVal" value="${trip.arrivalTime.toString().substring(0,16).replace(' ', 'T')}" />
                </c:if>
                <c:set var="seatsVal" value="34" />
                <c:if test="${trip != null}">
                    <c:set var="seatsVal" value="${trip.availableSeats}" />
                </c:if>
                <c:set var="priceVal" value="200000" />
                <c:if test="${trip != null}">
                    <c:set var="priceVal" value="${trip.price}" />
                </c:if>

                <div class="row">
                    <!-- GIỜ KHỞI HÀNH -->
                    <div class="col-md-6 mb-3">
                        <label for="departureTime" class="form-label fw-semibold text-secondary small">
                            GIỜ KHỞI HÀNH: <span class="text-danger">*</span>
                        </label>
                        <input type="datetime-local" class="form-control py-2" id="departureTime" name="departureTime" 
                               value="${depVal}" required>
                    </div>

                    <!-- GIỜ ĐẾN DỰ KIẾN -->
                    <div class="col-md-6 mb-3">
                        <label for="arrivalTime" class="form-label fw-semibold text-secondary small">
                            GIỜ ĐẾN (DỰ KIẾN): <span class="text-danger">*</span>
                        </label>
                        <input type="datetime-local" class="form-control py-2" id="arrivalTime" name="arrivalTime" 
                               value="${arrVal}" required>
                    </div>
                </div>

                <div class="row">
                    <!-- SỐ GHẾ TRỐNG -->
                    <div class="col-md-6 mb-3">
                        <label for="availableSeats" class="form-label fw-semibold text-secondary small">
                            SỐ GHẾ TRỐNG: <span class="text-danger">*</span>
                        </label>
                        <input type="number" class="form-control py-2" id="availableSeats" name="availableSeats" min="0" 
                               value="${seatsVal}" required>
                    </div>

                    <!-- GIÁ VÉ -->
                    <div class="col-md-6 mb-3">
                        <label for="price" class="form-label fw-semibold text-secondary small">
                            GIÁ VÉ (VNĐ): <span class="text-danger">*</span>
                        </label>
                        <input type="number" step="1000" class="form-control py-2" id="price" name="price" 
                               value="${priceVal}" required placeholder="Từ 100.000 đến 1.000.000">
                        <div class="form-text text-muted small">Quy định từ 100.000 đến 1.000.000 VNĐ</div>
                    </div>
                </div>

                <!-- TRẠNG THÁI -->
                <div class="mb-4">
                    <label for="status" class="form-label fw-semibold text-secondary small">
                        TRẠNG THÁI: <span class="text-danger">*</span>
                    </label>
                    <select class="form-select py-2" id="status" name="status" required>
                        <option value="Sắp khởi hành" <c:if test="${trip != null && trip.status == 'Sắp khởi hành'}">selected</c:if>>Sắp khởi hành</option>
                        <option value="Đang chạy" <c:if test="${trip != null && trip.status == 'Đang chạy'}">selected</c:if>>Đang chạy</option>
                        <option value="Hoàn thành" <c:if test="${trip != null && trip.status == 'Hoàn thành'}">selected</c:if>>Hoàn thành</option>
                        <option value="Đã hủy" <c:if test="${trip != null && trip.status == 'Đã hủy'}">selected</c:if>>Đã hủy</option>
                    </select>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/trip" class="btn btn-outline-secondary px-4 py-2">
                        <i class="bi bi-arrow-left me-1"></i> Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">
                        <i class="bi bi-check2-circle me-1"></i> Lưu Chuyến Xe
                    </button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

</body>
</html>
