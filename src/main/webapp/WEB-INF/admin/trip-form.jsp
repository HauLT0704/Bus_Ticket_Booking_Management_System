<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${trip != null ? 'Cập nhật Chuyến xe' : 'Thêm Chuyến xe mới'}</title>
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
                            <i class="bi ${trip != null ? 'bi-pencil-square text-warning' : 'bi-plus-circle text-primary'}"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">
                            ${trip != null ? 'Cập Nhật Chuyến Xe' : 'Thêm Chuyến Xe Mới'}
                        </h4>
                        <p class="text-secondary small mb-0">Thiết lập lịch trình chuyến xe, số ghế và giá vé</p>
                    </div>

                    <!-- FORM SUBMIT -->
                    <form action="${pageContext.request.contextPath}/admin/trip" method="POST">
                        
                        <!-- Biến ẩn nhận diện Thêm hay Sửa -->
                        <input type="hidden" name="action" value="${trip != null ? 'update' : 'insert'}">
                        <c:if test="${trip != null}">
                            <input type="hidden" name="id" value="${trip.id}">
                        </c:if>

                        <div class="row">
                            <!-- Route ID -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    ID Tuyến Đường (Route ID) <span class="text-danger">*</span>
                                </label>
                                <input type="number" name="routeId" class="form-control" 
                                       value="${trip != null && trip.route != null ? trip.route.id : ''}" 
                                       placeholder="Nhập ID tuyến..." required autofocus>
                            </div>

                            <!-- Vehicle ID -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    ID Xe (Vehicle ID) <span class="text-danger">*</span>
                                </label>
                                <input type="number" name="vehicleId" class="form-control" 
                                       value="${trip != null && trip.vehicle != null ? trip.vehicle.id : ''}" 
                                       placeholder="Nhập ID xe..." required>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Departure Time -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Thời Gian Khởi Hành <span class="text-danger">*</span>
                                </label>
                                <input type="datetime-local" name="departureTime" class="form-control" 
                                       value="${trip != null ? trip.departureTime : ''}" required>
                            </div>

                            <!-- Arrival Time -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Thời Gian Đến Dự Kiến <span class="text-danger">*</span>
                                </label>
                                <input type="datetime-local" name="arrivalTime" class="form-control" 
                                       value="${trip != null ? trip.arrivalTime : ''}" required>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Available Seats -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Số Ghế Trống <span class="text-danger">*</span>
                                </label>
                                <input type="number" name="availableSeats" class="form-control" 
                                       value="${trip != null ? trip.availableSeats : '45'}" required>
                            </div>

                            <!-- Price -->
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">
                                    Giá Vé (VNĐ) <span class="text-danger">*</span>
                                </label>
                                <input type="number" step="1000" name="price" class="form-control" 
                                       value="${trip != null ? trip.price : ''}" 
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
                                <i class="bi bi-check-lg me-1"></i> ${trip != null ? 'Lưu Thay Đổi' : 'Thêm Chuyến Xe'}
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

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>