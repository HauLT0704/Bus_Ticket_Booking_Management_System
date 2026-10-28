<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${trip != null && trip.id != 0 ? 'Cập nhật Chuyến xe' : 'Thêm Chuyến xe mới'}</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-12 col-md-9 col-lg-7">
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">

                    <!-- ICON & TIÊU ĐỀ -->
                    <div class="text-center mb-4">
                        <div class="fs-1 text-primary mb-2">
                            <i class="bi ${trip != null && trip.id != 0 ? 'bi-pencil-square text-warning' : 'bi-plus-circle text-primary'}"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">
                            ${trip != null && trip.id != 0 ? 'Cập Nhật Chuyến Xe' : 'Thêm Chuyến Xe Mới'}
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

                    <!-- FORM SUBMIT -->
                    <form action="${pageContext.request.contextPath}/admin/trip" method="POST">
                        
                        <input type="hidden" name="action" value="${trip != null && trip.id != 0 ? 'update' : 'insert'}">
                        <c:if test="${trip != null && trip.id != 0}">
                            <input type="hidden" name="id" value="${trip.id}">
                        </c:if>

                        <div class="row">
                            <!-- Route Dropdown -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Tuyến Đường <span class="text-danger">*</span>
                                </label>
                                <select name="routeId" class="form-select" required autofocus>
                                    <option value="">-- Chọn tuyến đường --</option>
                                    <c:forEach var="r" items="${routeList}">
                                        <option value="${r.id}" ${trip != null && trip.route != null && trip.route.id == r.id ? 'selected' : ''}>
                                            ${r.fromLocation.name} → ${r.toLocation.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Vehicle Dropdown -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Xe (Biển số xe) <span class="text-danger">*</span>
                                </label>
                                <select name="vehicleId" class="form-select" required>
                                    <option value="">-- Chọn xe --</option>
                                    <c:forEach var="v" items="${vehicleList}">
                                        <option value="${v.id}" ${trip != null && trip.vehicle != null && trip.vehicle.id == v.id ? 'selected' : ''}>
                                            ${v.licensePlate}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Định dạng ngày giờ chuẩn cho input datetime-local -->
                        <c:if test="${trip != null && trip.departureTime != null}">
                            <fmt:formatDate value="${trip.departureTime}" pattern="yyyy-MM-dd'T'HH:mm" var="formattedDepTime"/>
                        </c:if>
                        <c:if test="${trip != null && trip.arrivalTime != null}">
                            <fmt:formatDate value="${trip.arrivalTime}" pattern="yyyy-MM-dd'T'HH:mm" var="formattedArrTime"/>
                        </c:if>

                        <div class="row">
                            <!-- Departure Time (datetime-local) -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Thời Gian Khởi Hành <span class="text-danger">*</span>
                                </label>
                                <input type="datetime-local" id="departureTime" name="departureTime" class="form-control" 
                                       value="${formattedDepTime}" required>
                            </div>

                            <!-- Arrival Time (datetime-local) -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Thời Gian Đến Dự Kiến <span class="text-danger">*</span>
                                </label>
                                <input type="datetime-local" id="arrivalTime" name="arrivalTime" class="form-control" 
                                       value="${formattedArrTime}" required>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Available Seats [15 - 59] -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Số Ghế Trống [15 - 59] <span class="text-danger">*</span>
                                </label>
                                <input type="number" min="15" max="59" name="availableSeats" class="form-control" 
                                       value="${trip != null && trip.availableSeats != 0 ? trip.availableSeats : '45'}" required>
                            </div>

                            <!-- Price -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Giá Vé (VNĐ) <span class="text-danger">*</span>
                                </label>
                                <input type="number" step="1000" min="1000" name="price" class="form-control" 
                                       value="${trip != null && trip.price != 0.0 ? trip.price : ''}" 
                                       placeholder="VD: 150000" required>
                            </div>
                        </div>

                        <!-- Status -->
                        <div class="mb-4">
                            <label class="form-label fw-bold small text-secondary">
                                Trạng Thái Chuyến Xe <span class="text-danger">*</span>
                            </label>
                            <select name="status" class="form-select" required>
                                <option value="Active" ${trip != null && trip.status == 'Active' ? 'selected' : ''}>Active (Đang hoạt động)</option>
                                <option value="Delayed" ${trip != null && trip.status == 'Delayed' ? 'selected' : ''}>Delayed (Trễ chuyến)</option>
                                <option value="Cancelled" ${trip != null && trip.status == 'Cancelled' ? 'selected' : ''}>Cancelled (Đã hủy)</option>
                            </select>
                        </div>

                        <!-- NÚT LƯU & QUAY LẠI -->
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary py-2 fw-bold shadow-sm">
                                <i class="bi bi-check-lg me-1"></i> ${trip != null && trip.id != 0 ? 'Lưu Thay Đổi' : 'Thêm Chuyến Xe'}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/trip" class="btn btn-light py-2 text-secondary fw-semibold">
                                <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
                            </a>
                        </div>

                    </form>

                </div>
            </div>
        </div>
    </div>

    <!-- Script JavaScript tự động set min cho datetime-local -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            const currentDateTime = now.toISOString().slice(0, 16);
            
            const depInput = document.getElementById("departureTime");
            const arrInput = document.getElementById("arrivalTime");
            
            if (depInput && !depInput.value) {
                depInput.min = currentDateTime;
            }
            if (arrInput && !arrInput.value) {
                arrInput.min = currentDateTime;
            }
        });
    </script>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>