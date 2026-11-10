<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Chuyến Xe - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container py-4">

        <!-- THÔNG BÁO FEEDBACK -->
        <c:if test="${param.msg == 'added'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công!</strong> Đã thêm chuyến xe mới.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'updated'}">
            <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-info-circle-fill me-2"></i> <strong>Thành công!</strong> Đã cập nhật chuyến xe.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-trash-fill me-2"></i> Đã xóa chuyến xe thành công.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'delete_error'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Không thể xóa!</strong> Chuyến xe này đã có khách hàng đặt vé (ràng buộc dữ liệu vé).
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'not_found'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> <strong>Lỗi!</strong> Chuyến xe yêu cầu không tồn tại trong hệ thống!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'invalid_id'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2"></i> <strong>Cảnh báo!</strong> Mã chuyến xe trên đường dẫn không hợp lệ!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="bi bi-calendar-check-fill text-primary me-2"></i>Quản Lý Chuyến Xe
                </h3>
                <p class="text-muted mb-0 small">Theo dõi lịch trình khởi hành, quản lý giá vé và danh sách hành khách</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/trip?action=add" class="btn btn-primary fw-semibold px-3 py-2 shadow-sm">
                <i class="bi bi-plus-circle me-1"></i> + Thêm Chuyến Xe Mới
            </a>
        </div>

        <!-- BẢNG DANH SÁCH -->
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center py-3" style="width: 70px;">MÃ</th>
                            <th class="py-3">TUYẾN ĐƯỜNG</th>
                            <th class="py-3">XE (BIỂN SỐ)</th>
                            <th class="py-3">GIỜ KHỞI HÀNH</th>
                            <th class="py-3">GIỜ ĐẾN</th>
                            <th class="text-center py-3">GHẾ TRỐNG</th>
                            <th class="py-3 text-end">GIÁ VÉ</th>
                            <th class="text-center py-3">TRẠNG THÁI</th>
                            <th class="text-center py-3" style="width: 170px;">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="t" items="${list}">
                            <tr>
                                <td class="text-center fw-bold text-muted">#${t.id}</td>
                                <td class="fw-semibold text-dark">
                                    <i class="bi bi-arrow-right-circle text-primary me-1"></i>
                                    ${t.displayRouteName}
                                </td>
                                <td class="text-secondary">
                                    <i class="bi bi-truck-front me-1"></i> ${t.displayVehicleName}
                                </td>
                                <td class="small text-nowrap">
                                    <fmt:formatDate value="${t.departureTime}" pattern="HH:mm - dd/MM/yyyy" />
                                </td>
                                <td class="small text-nowrap">
                                    <fmt:formatDate value="${t.arrivalTime}" pattern="HH:mm - dd/MM/yyyy" />
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${t.availableSeats > 5}">
                                            <span class="badge bg-primary-subtle text-primary fw-bold px-2 py-1">${t.availableSeats} chỗ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger fw-bold px-2 py-1">${t.availableSeats} chỗ</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-bold text-danger text-end">
                                    <fmt:formatNumber value="${t.price}" pattern="#,##0" /> đ
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${t.status == 'Active' || t.status == 'Đang chạy' || t.status == 'Sắp khởi hành'}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1">${t.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill px-3 py-1">${t.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center text-nowrap">
                                    <!-- Nút Xem/In danh sách hành khách theo chuyến (TV5) -->
                                    <a href="${pageContext.request.contextPath}/admin/trips/customers?tripId=${t.id}" 
                                       class="btn btn-sm btn-outline-info me-1" title="Xem danh sách hành khách">
                                        <i class="bi bi-people-fill"></i>
                                    </a>
                                    <!-- Nút Sửa -->
                                    <a href="${pageContext.request.contextPath}/admin/trip?action=edit&id=${t.id}" 
                                       class="btn btn-sm btn-outline-warning me-1" title="Chỉnh sửa chuyến xe">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    <!-- Nút Xóa -->
                                    <a href="${pageContext.request.contextPath}/admin/trip?action=delete&id=${t.id}" 
                                       class="btn btn-sm btn-outline-danger" title="Xóa chuyến">
                                        <i class="bi bi-trash3-fill"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="9" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                    Chưa có chuyến xe nào trong hệ thống!
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
