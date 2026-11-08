<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tuyến Đường - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container my-5" style="max-width: 600px;">
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">

            <div class="text-center mb-4">
                <div class="fs-1 text-primary mb-2">
                    <c:choose>
                        <c:when test="${route != null && route.id != 0}">
                            <i class="bi bi-pencil-square text-warning"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-signpost-split-fill text-primary"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h4 class="fw-bold text-dark mb-1">
                    <c:choose>
                        <c:when test="${route != null && route.id != 0}">Cập Nhật Tuyến Đường</c:when>
                        <c:otherwise>Thêm Tuyến Đường Mới</c:otherwise>
                    </c:choose>
                </h4>
                <p class="text-secondary small mb-0">Điền thông tin chi tiết cho tuyến đường di chuyển</p>
            </div>

            <!-- THÔNG BÁO LỖI -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FORM NHẬP LIỆU -->
            <form action="${pageContext.request.contextPath}/admin/route" method="POST">
                <c:choose>
                    <c:when test="${route != null && route.id != 0}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${route.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="insert">
                    </c:otherwise>
                </c:choose>

                <!-- ĐIỂM ĐI -->
                <div class="mb-3">
                    <label for="fromLocationId" class="form-label fw-semibold text-secondary small">
                        ĐIỂM ĐI: <span class="text-danger">*</span>
                    </label>
                    <select class="form-select py-2" id="fromLocationId" name="fromLocationId" required>
                        <option value="">-- Chọn điểm đi --</option>
                        <c:forEach var="loc" items="${locationList}">
                            <option value="${loc.id}" <c:if test="${route != null && route.fromLocation != null && route.fromLocation.id == loc.id}">selected</c:if>>
                                ${loc.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- ĐIỂM ĐẾN -->
                <div class="mb-3">
                    <label for="toLocationId" class="form-label fw-semibold text-secondary small">
                        ĐIỂM ĐẾN: <span class="text-danger">*</span>
                    </label>
                    <select class="form-select py-2" id="toLocationId" name="toLocationId" required>
                        <option value="">-- Chọn điểm đến --</option>
                        <c:forEach var="loc" items="${locationList}">
                            <option value="${loc.id}" <c:if test="${route != null && route.toLocation != null && route.toLocation.id == loc.id}">selected</c:if>>
                                ${loc.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- KHOẢNG CÁCH -->
                <div class="mb-3">
                    <label for="distance" class="form-label fw-semibold text-secondary small">
                        KHOẢNG CÁCH (KM): <span class="text-danger">*</span>
                    </label>
                    <input type="number" step="0.1" class="form-control py-2" id="distance" name="distance" 
                           value="<c:out value='${route.distance}'/>" required placeholder="Ví dụ: 165">
                </div>

                <!-- THỜI GIAN DỰ KIẾN -->
                <div class="mb-4">
                    <label for="duration" class="form-label fw-semibold text-secondary small">
                        THỜI GIAN DỰ KIẾN (PHÚT): <span class="text-danger">*</span>
                    </label>
                    <input type="number" class="form-control py-2" id="duration" name="duration" 
                           value="<c:out value='${route.duration}'/>" required placeholder="Ví dụ: 210 (3 tiếng 30 phút)">
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/route" class="btn btn-outline-secondary px-4 py-2">
                        <i class="bi bi-arrow-left me-1"></i> Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">
                        <i class="bi bi-check2-circle me-1"></i> Lưu Tuyến Đường
                    </button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

</body>
</html>
