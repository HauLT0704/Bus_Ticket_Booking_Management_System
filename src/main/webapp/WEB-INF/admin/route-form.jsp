<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${route != null ? 'Cập nhật Tuyến đường' : 'Thêm Tuyến đường mới'}</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-12 col-md-8 col-lg-6">
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">

                    <!-- ICON & TIÊU ĐỀ -->
                    <div class="text-center mb-4">
                        <div class="fs-1 text-primary mb-2">
                            <i class="bi ${route != null ? 'bi-pencil-square text-warning' : 'bi-plus-circle text-primary'}"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">
                            ${route != null ? 'Cập Nhật Tuyến Đường' : 'Thêm Tuyến Đường Mới'}
                        </h4>
                        <p class="text-secondary small mb-0">Điền thông tin chi tiết cho tuyến đường di chuyển</p>
                    </div>

                    <!-- FORM SUBMIT -->
                    <form action="${pageContext.request.contextPath}/admin/route" method="POST">
                        
                        <!-- Biến ẩn nhận diện Thêm hay Sửa -->
                        <input type="hidden" name="action" value="${route != null ? 'update' : 'insert'}">
                        <c:if test="${route != null}">
                            <input type="hidden" name="id" value="${route.id}">
                        </c:if>

                        <!-- Điểm đi (fromLocationId) -->
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-secondary">
                                ID Điểm Đi (From Location ID) <span class="text-danger">*</span>
                            </label>
                            <input type="number" name="fromLocationId" class="form-control" 
                                   value="${route != null && route.fromLocation != null ? route.fromLocation.id : ''}" 
                                   placeholder="Nhập ID bến đi..." required autofocus>
                        </div>

                        <!-- Điểm đến (toLocationId) -->
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-secondary">
                                ID Điểm Đến (To Location ID) <span class="text-danger">*</span>
                            </label>
                            <input type="number" name="toLocationId" class="form-control" 
                                   value="${route != null && route.toLocation != null ? route.toLocation.id : ''}" 
                                   placeholder="Nhập ID bến đến..." required>
                        </div>

                        <!-- Quãng đường (distance) -->
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-secondary">
                                Quãng Đường (km) <span class="text-danger">*</span>
                            </label>
                            <input type="number" step="0.1" name="distance" class="form-control" 
                                   value="${route != null ? route.distance : ''}" 
                                   placeholder="VD: 120.5" required>
                        </div>

                        <!-- Thời gian dự kiến (duration) -->
                        <div class="mb-4">
                            <label class="form-label fw-bold small text-secondary">
                                Thời Gian Dự Kiến (phút) <span class="text-danger">*</span>
                            </label>
                            <input type="number" name="duration" class="form-control" 
                                   value="${route != null ? route.duration : ''}" 
                                   placeholder="VD: 180" required>
                        </div>

                        <!-- NÚT LƯU & QUAY LẠI -->
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary py-2 fw-bold shadow-sm">
                                <i class="bi bi-check-lg me-1"></i> ${route != null ? 'Lưu Thay Đổi' : 'Thêm Tuyến Đường'}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/route" class="btn btn-light py-2 text-secondary fw-semibold">
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