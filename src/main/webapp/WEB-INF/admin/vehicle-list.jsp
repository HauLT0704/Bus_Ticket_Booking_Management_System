<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Xe Khách - Vé Xe Miền Tây</title>
        <!-- Bootstrap 5.3 & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">

        <jsp:include page="../common/header.jsp" />

        <div class="container py-4">

            <!-- THÔNG BÁO FEEDBACK -->
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công!</strong> Đã thêm xe khách mới.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-info-circle-fill me-2"></i> <strong>Thành công!</strong> Đã cập nhật xe khách.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-trash-fill me-2"></i> Đã xóa thông tin xe thành công.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'delete_error'}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Không thể xóa!</strong> Xe khách này đang được phân công chạy chuyến xe trong hệ thống.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <div>
                    <h3 class="fw-bold text-dark mb-1">
                        <i class="bi bi-truck-front-fill text-primary me-2"></i>Quản Lý Xe Khách
                    </h3>
                    <p class="text-muted mb-0 small">Quản lý phương tiện, loại xe, số lượng ghế ngồi và trạng thái vận hành</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/vehicle?action=add" class="btn btn-primary fw-semibold px-3 py-2 shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i> + Thêm Xe Khách Mới
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="py-3 ps-3" style="width: 70px;">ID</th>
                                <th class="py-3">Biển Số Xe</th>
                                <th class="py-3 text-center">Tổng Số Ghế</th>
                                <th class="py-3">Loại Xe</th>
                                <th class="py-3 text-center">Trạng Thái</th>
                                <th class="py-3 text-center" style="width: 140px;">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty vehicleList}">
                                    <c:forEach var="v" items="${vehicleList}">
                                        <tr>
                                            <td class="ps-3 fw-bold text-muted">#${v.id}</td>
                                            <td class="fw-bold text-primary">
                                                <i class="bi bi-truck-front me-1"></i> ${v.licensePlate}
                                            </td>
                                            <td class="text-center fw-semibold">${v.totalSeats} chỗ</td>
                                            <td>
                                                <span class="badge bg-secondary-subtle text-dark border px-2 py-1">
                                                    ${v.type}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${v.status == 'Hoạt động' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-warning-subtle text-warning border border-warning-subtle'} rounded-pill px-3 py-1">
                                                    ${v.status}
                                                </span>
                                            </td>
                                            <td class="text-center text-nowrap">
                                                <a href="${pageContext.request.contextPath}/admin/vehicle?action=edit&id=${v.id}" 
                                                   class="btn btn-sm btn-outline-warning me-1" title="Sửa xe">
                                                    <i class="bi bi-pencil-square"></i> Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/vehicle?action=delete&id=${v.id}" 
                                                   class="btn btn-sm btn-outline-danger" 
                                                   onclick="return confirm('Bạn có chắc muốn xóa xe ${v.licensePlate}?');" title="Xóa xe">
                                                    <i class="bi bi-trash3-fill"></i> Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                            Chưa có xe khách nào trong hệ thống!
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <jsp:include page="../common/pagination.jsp" />

            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />

    </body>
</html>
