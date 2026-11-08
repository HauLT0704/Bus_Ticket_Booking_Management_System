<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khách Hàng - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <!-- Phần Form Nội Dung Chính -->
    <div class="container my-5" style="max-width: 600px;">
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">
            <h3 class="fw-bold text-dark mb-4 text-center">
                <i class="bi bi-person-lines-fill text-primary me-2"></i>
                <c:choose>
                    <c:when test="${customer != null and customer.id > 0}">Cập Nhật Khách Hàng</c:when>
                    <c:otherwise>Thêm Khách Hàng Mới</c:otherwise>
                </c:choose>
            </h3>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/customer" method="POST">
                <c:choose>
                    <c:when test="${customer != null and customer.id > 0}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${customer.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="insert">
                    </c:otherwise>
                </c:choose>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Họ và Tên: <span class="text-danger">*</span></label>
                    <input type="text" class="form-control py-2" name="fullName" 
                           value="${customer != null ? customer.fullName : ''}" required 
                           placeholder="Ví dụ: Nguyễn Văn A">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Số Điện Thoại: <span class="text-danger">*</span></label>
                    <input type="tel" class="form-control py-2" name="phone" 
                           value="${customer != null ? customer.phone : ''}" required 
                           placeholder="Ví dụ: 0912345678">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Email:</label>
                    <input type="email" class="form-control py-2" name="email" 
                           value="${customer != null ? customer.email : ''}" 
                           placeholder="Ví dụ: nguyenvana@gmail.com">
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Số CCCD / CMND:</label>
                    <input type="text" class="form-control py-2" name="idCard" 
                           value="${customer != null ? customer.idCard : ''}" 
                           placeholder="Ví dụ: 079123456789">
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/customer" class="btn btn-outline-secondary px-4 py-2">
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
