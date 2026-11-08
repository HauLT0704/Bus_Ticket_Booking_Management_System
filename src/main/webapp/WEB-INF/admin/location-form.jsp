<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tỉnh / Thành Phố - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container my-5" style="max-width: 550px;">
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">

            <div class="text-center mb-4">
                <div class="fs-1 text-primary mb-2">
                    <c:choose>
                        <c:when test="${location != null and location.id > 0}">
                            <i class="bi bi-pencil-square text-warning"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-geo-alt-fill text-primary"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h4 class="fw-bold text-dark mb-1">
                    <c:choose>
                        <c:when test="${location != null and location.id > 0}">
                            Cập Nhật Tỉnh / Thành Phố
                        </c:when>
                        <c:otherwise>
                            Thêm Tỉnh / Thành Phố Mới
                        </c:otherwise>
                    </c:choose>
                </h4>
                <p class="text-secondary small mb-0">Nhập tên tỉnh hoặc thành phố vào ô bên dưới</p>
            </div>

            <!-- THÔNG BÁO LỖI VALIDATE -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FORM NHẬP LIỆU -->
            <form action="${pageContext.request.contextPath}/admin/location" method="POST">
                <c:choose>
                    <c:when test="${location != null and location.id > 0}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${location.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="insert">
                    </c:otherwise>
                </c:choose>

                <div class="mb-4">
                    <label for="name" class="form-label fw-semibold text-secondary small">
                        TÊN TỈNH / THÀNH PHỐ: <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-muted border-end-0">
                            <i class="bi bi-geo-alt"></i>
                        </span>
                        <input type="text" 
                               class="form-control border-start-0 py-2" 
                               id="name" 
                               name="name" 
                               value="<c:out value='${location.name}'/>" 
                               required 
                               placeholder="Ví dụ: Cần Thơ, TP. Hồ Chí Minh, An Giang...">
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/location" class="btn btn-outline-secondary px-4 py-2">
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
