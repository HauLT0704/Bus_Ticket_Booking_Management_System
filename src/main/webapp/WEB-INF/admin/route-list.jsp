<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tuyến Đường - Vé Xe Miền Tây</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container py-4">

        <!-- THÔNG BÁO FEEDBACK -->
        <c:if test="${param.msg == 'added'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công!</strong> Đã thêm tuyến đường mới.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'updated'}">
            <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-info-circle-fill me-2"></i> <strong>Thành công!</strong> Đã cập nhật tuyến đường.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-trash-fill me-2"></i> Đã xóa tuyến đường thành công.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'delete_error'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Không thể xóa!</strong> Tuyến đường này đang có chuyến xe hoạt động. Vui lòng xóa các chuyến xe thuộc tuyến trước.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'not_found'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> <strong>Lỗi!</strong> Tuyến đường yêu cầu không tồn tại trong hệ thống!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'invalid_id'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2"></i> <strong>Cảnh báo!</strong> Mã tuyến đường trên đường dẫn không hợp lệ!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="bi bi-signpost-split-fill text-primary me-2"></i>Quản Lý Tuyến Đường
                </h3>
                <p class="text-muted mb-0 small">Quản lý các cung đường nối các tỉnh thành, khoảng cách km và thời gian dự kiến</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/route?action=add" class="btn btn-primary fw-semibold px-3 py-2 shadow-sm">
                <i class="bi bi-plus-circle me-1"></i> + Thêm Tuyến Đường Mới
            </a>
        </div>

        <!-- BẢNG DANH SÁCH -->
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center py-3 ps-3" style="width: 70px;">MÃ</th>
                            <th class="py-3">ĐIỂM ĐI</th>
                            <th class="py-3">ĐIỂM ĐẾN</th>
                            <th class="py-3 text-center">KHOẢNG CÁCH (KM)</th>
                            <th class="py-3 text-center">THỜI GIAN DỰ KIẾN</th>
                            <th class="text-center py-3" style="width: 140px;">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${list}">
                            <tr>
                                <td class="text-center fw-bold text-muted ps-3">#${r.id}</td>
                                <td class="fw-semibold text-danger">
                                    <i class="bi bi-geo-alt-fill me-1"></i>${r.fromLocation.name}
                                </td>
                                <td class="fw-semibold text-success">
                                    <i class="bi bi-flag-fill me-1"></i>${r.toLocation.name}
                                </td>
                                <td class="text-center fw-semibold">${r.distance} km</td>
                                <td class="text-center">
                                    <span class="badge bg-light text-dark border">
                                        <i class="bi bi-clock me-1"></i>${r.duration} phút
                                    </span>
                                </td>
                                <td class="text-center text-nowrap">
                                    <a href="${pageContext.request.contextPath}/admin/route?action=edit&id=${r.id}" 
                                       class="btn btn-sm btn-outline-warning me-1" title="Sửa tuyến">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/route?action=delete&id=${r.id}" 
                                       class="btn btn-sm btn-outline-danger" title="Xóa tuyến">
                                        <i class="bi bi-trash3-fill"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                    Chưa có tuyến đường nào trong hệ thống!
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <jsp:include page="../common/pagination.jsp" />

        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

</body>
</html>
