<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khách Hàng - Vé Xe Miền Tây</title>
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
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công!</strong> Đã thêm khách hàng mới.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'updated'}">
            <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-info-circle-fill me-2"></i> <strong>Thành công!</strong> Đã cập nhật thông tin khách hàng.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-trash-fill me-2"></i> Đã xóa thông tin khách hàng thành công.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'delete_error'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Không thể xóa!</strong> Khách hàng này đã có lịch sử đặt vé trong hệ thống.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="bi bi-people-fill text-primary me-2"></i>Quản Lý Khách Hàng
                </h3>
                <p class="text-muted mb-0 small">Xem, tìm kiếm và quản lý thông tin khách hàng trong hệ thống</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/customer?action=add" class="btn btn-primary fw-semibold px-3 py-2 shadow-sm">
                <i class="bi bi-person-plus-fill me-1"></i> + Thêm Khách Hàng Mới
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 bg-white p-4">

            <!-- THANH TÌM KIẾM THEO TÊN / SĐT -->
            <form action="${pageContext.request.contextPath}/admin/customer" method="GET" class="mb-4">
                <input type="hidden" name="action" value="list">
                <div class="row g-2 align-items-center">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search text-muted"></i></span>
                            <input type="text" name="keyword" class="form-control" 
                                   placeholder="Nhập tên hoặc số điện thoại..." 
                                   value="${keyword}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-outline-primary px-3">
                            <i class="bi bi-search me-1"></i> Tìm kiếm
                        </button>
                        <c:if test="${not empty keyword}">
                            <a href="${pageContext.request.contextPath}/admin/customer" class="btn btn-outline-secondary px-3 ms-1">
                                <i class="bi bi-x-circle me-1"></i> Bỏ lọc
                            </a>
                        </c:if>
                    </div>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="py-3 ps-3" style="width: 70px;">ID</th>
                            <th class="py-3">Họ và Tên</th>
                            <th class="py-3">Số Điện Thoại</th>
                            <th class="py-3">Email</th>
                            <th class="py-3">CCCD / CMND</th>
                            <th class="py-3 text-center" style="width: 140px;">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty customerList}">
                                <c:forEach var="c" items="${customerList}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-muted">#${c.id}</td>
                                        <td class="fw-semibold text-dark">
                                            <i class="bi bi-person-circle text-secondary me-1"></i>
                                            ${c.fullName}
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${c.phone}</span></td>
                                        <td>${c.email != null ? c.email : '-'}</td>
                                        <td>${c.idCard != null ? c.idCard : '-'}</td>
                                        <td class="text-center text-nowrap">
                                            <a href="${pageContext.request.contextPath}/admin/customer?action=edit&id=${c.id}" 
                                               class="btn btn-sm btn-outline-warning me-1" title="Sửa thông tin">
                                                <i class="bi bi-pencil-square"></i> Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/customer?action=delete&id=${c.id}" 
                                               class="btn btn-sm btn-outline-danger" 
                                               onclick="return confirm('Bạn có chắc muốn xóa khách hàng #${c.id} này?');" title="Xóa">
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
                                        Không tìm thấy khách hàng nào phù hợp!
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
