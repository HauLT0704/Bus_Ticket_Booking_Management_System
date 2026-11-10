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

    <div class="container my-5" style="max-width: 620px;">
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">

            <div class="text-center mb-4">
                <c:choose>
                    <c:when test="${isDelete}">
                        <div class="fs-1 text-danger mb-2">
                            <i class="bi bi-trash3-fill"></i>
                        </div>
                        <h4 class="fw-bold text-danger mb-1">Xác Nhận Xóa Tuyến Đường</h4>
                        <p class="text-secondary small mb-0">Xem lại thông tin tuyến đường trước khi xác nhận xóa vĩnh viễn</p>
                    </c:when>
                    <c:when test="${route != null && route.id != 0}">
                        <div class="fs-1 text-warning mb-2">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">Cập Nhật Tuyến Đường</h4>
                        <p class="text-secondary small mb-0">Chỉnh sửa thông tin cự ly và thời gian của tuyến đường</p>
                    </c:when>
                    <c:otherwise>
                        <div class="fs-1 text-primary mb-2">
                            <i class="bi bi-signpost-split-fill"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">Thêm Tuyến Đường Mới</h4>
                        <p class="text-secondary small mb-0">Thiết lập tuyến đường kết nối giữa hai tỉnh thành</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- CẢNH BÁO NẾU ĐANG Ở CHẾ ĐỘ XÓA -->
            <c:if test="${isDelete}">
                <div class="alert alert-warning border-warning d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-3 text-warning me-3"></i>
                    <div class="small">
                        <strong>Cảnh báo quan trọng:</strong> Hành động này sẽ xóa hoàn toàn tuyến đường khỏi hệ thống. Nếu tuyến đường đã có chuyến xe hoặc vé được đặt, hệ thống sẽ từ chối xóa để bảo toàn dữ liệu.
                    </div>
                </div>
            </c:if>

            <!-- THÔNG BÁO LỖI -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FORM NHẬP LIỆU / XÁC NHẬN XÓA -->
            <form action="${pageContext.request.contextPath}/admin/route" method="POST">
                <c:choose>
                    <c:when test="${isDelete}">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${route.id}">
                    </c:when>
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
                        ĐIỂM ĐI: <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                    </label>
                    <select class="form-select py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                            id="fromLocationId" name="fromLocationId" required <c:if test="${isDelete}">disabled</c:if>>
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
                        ĐIỂM ĐẾN: <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                    </label>
                    <select class="form-select py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                            id="toLocationId" name="toLocationId" required <c:if test="${isDelete}">disabled</c:if>>
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
                        KHOẢNG CÁCH (KM): <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                    </label>
                    <div class="input-group">
                        <input type="number" step="0.1" min="20" max="1000" 
                               class="form-control py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                               id="distance" name="distance" 
                               value="<c:out value='${route.distance > 0 ? route.distance : ""}'/>" required 
                               placeholder="Từ 20.0 đến 1000.0 km" <c:if test="${isDelete}">readonly</c:if>>
                        <span class="input-group-text bg-light text-secondary">km</span>
                    </div>
                    <c:if test="${!isDelete}">
                        <div class="form-text text-muted small">Quy định từ 20.0 đến 1,000.0 km</div>
                    </c:if>
                </div>

                <!-- THỜI GIAN DỰ KIẾN -->
                <div class="mb-4">
                    <label for="duration" class="form-label fw-semibold text-secondary small">
                        THỜI GIAN DỰ KIẾN (PHÚT): <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                    </label>
                    <div class="input-group">
                        <input type="number" min="30" max="1440" 
                               class="form-control py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                               id="duration" name="duration" 
                               value="<c:out value='${route.duration > 0 ? route.duration : ""}'/>" required 
                               placeholder="Từ 30 đến 1440 phút (24 giờ)" <c:if test="${isDelete}">readonly</c:if>>
                        <span class="input-group-text bg-light text-secondary">phút</span>
                    </div>
                    <c:if test="${!isDelete}">
                        <div class="form-text text-muted small">Quy định từ 30 đến 1,440 phút (tối đa 24 giờ)</div>
                    </c:if>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/route" class="btn btn-outline-secondary px-4 py-2">
                        <i class="bi bi-arrow-left me-1"></i> <c:choose><c:when test="${isDelete}">Hủy Bỏ</c:when><c:otherwise>Quay Lại</c:otherwise></c:choose>
                    </a>
                    <c:choose>
                        <c:when test="${isDelete}">
                            <button type="submit" class="btn btn-danger px-4 py-2 fw-semibold">
                                <i class="bi bi-trash3-fill me-1"></i> Xác Nhận Xóa
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">
                                <i class="bi bi-check2-circle me-1"></i> Lưu Tuyến Đường
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
