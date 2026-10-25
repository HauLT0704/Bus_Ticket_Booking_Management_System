<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${location != null ? 'Cập nhật Tỉnh / Thành' : 'Thêm Tỉnh / Thành mới'}</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-12 col-md-8 col-lg-5">
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">

                    <!-- ICON & TIÊU ĐỀ -->
                    <div class="text-center mb-4">
                        <div class="fs-1 text-primary mb-2">
                            <i class="bi ${location != null ? 'bi-pencil-square text-warning' : 'bi-plus-circle text-primary'}"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">
                            ${location != null ? 'Cập Nhật Tỉnh / Thành' : 'Thêm Tỉnh / Thành Mới'}
                        </h4>
                        <p class="text-secondary small mb-0">Nhập tên tỉnh hoặc thành phố vào ô bên dưới</p>
                    </div>

                    <!-- FORM SUBMIT (Chỉ 1 ô duy nhất) -->
                    <form action="${pageContext.request.contextPath}/admin/location" method="POST">
                        
                        <!-- Biến ẩn nhận diện Thêm hay Sửa -->
                        <input type="hidden" name="action" value="${location != null ? 'update' : 'insert'}">
                        <c:if test="${location != null}">
                            <input type="hidden" name="id" value="${location.id}">
                        </c:if>

                        <!-- Ô DUY NHẤT: Tên Tỉnh / Thành phố -->
                        <div class="mb-4">
                            <label class="form-label fw-bold small text-secondary">
                                Tên Tỉnh / Thành Phố <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="name" class="form-control form-control-lg fs-6" 
                                   value="${location != null ? location.name : ''}" 
                                   placeholder="VD: Cần Thơ, An Giang, Cà Mau..." required autofocus>
                        </div>

                        <!-- NÚT LƯU & QUAY LẠI -->
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary py-2 fw-bold shadow-sm">
                                <i class="bi bi-check-lg me-1"></i> ${location != null ? 'Lưu Thay Đổi' : 'Thêm Tỉnh / Thành'}
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/location" class="btn btn-light py-2 text-secondary fw-semibold">
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