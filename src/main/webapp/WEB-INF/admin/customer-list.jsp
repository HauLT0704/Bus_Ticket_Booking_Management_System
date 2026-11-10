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
        <c:if test="${param.msg == 'not_found'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> <strong>Lỗi!</strong> Khách hàng yêu cầu không tồn tại trong hệ thống!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'user_locked'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-lock-fill me-2"></i> <strong>Thành công!</strong> Đã khóa tài khoản người dùng liên kết.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'user_unlocked'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công!</strong> Đã kích hoạt / mở khóa tài khoản người dùng.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'invalid_id'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2"></i> <strong>Cảnh báo!</strong> Mã yêu cầu không hợp lệ!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="bi bi-people-fill text-primary me-2"></i>Quản Lý Khách Hàng
                </h3>
                <p class="text-muted mb-0 small">Xem, tìm kiếm và quản lý thông tin khách hàng & tài khoản trong hệ thống</p>
            </div>
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
                            <th class="py-3">Tài Khoản (User)</th>
                            <th class="py-3">Số Điện Thoại</th>
                            <th class="py-3">Email</th>
                            <th class="py-3 text-center">Trạng Thái Tài Khoản</th>
                            <th class="py-3 text-center" style="width: 220px;">Hoạt Động</th>
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
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty c.username}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                                        <i class="bi bi-person-badge me-1"></i>${c.username}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small fst-italic">Khách vãng lai</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${c.phone}</span></td>
                                        <td>${c.email != null ? c.email : '-'}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${empty c.userId}">
                                                    <span class="badge bg-secondary-subtle text-secondary border">Chưa có tài khoản</span>
                                                </c:when>
                                                <c:when test="${!c.accountOwner}">
                                                    <span class="badge bg-light text-muted border"><i class="bi bi-person me-1"></i>Hành khách</span>
                                                </c:when>
                                                <c:when test="${c.userStatus == 'Bị khóa'}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                        <i class="bi bi-lock-fill me-1"></i>Bị khóa
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                        <i class="bi bi-check-circle-fill me-1"></i>Hoạt động
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center text-nowrap">
                                            <c:if test="${not empty c.userId and c.accountOwner}">
                                                <c:choose>
                                                    <c:when test="${c.userStatus == 'Bị khóa'}">
                                                        <a href="${pageContext.request.contextPath}/admin/customer?action=unlock&userId=${c.userId}" 
                                                           class="btn btn-sm btn-outline-success me-1" 
                                                           onclick="return confirm('Kích hoạt / Mở khóa lại tài khoản [${c.username}]?');" 
                                                           title="Kích hoạt tài khoản">
                                                            <i class="bi bi-unlock-fill"></i> Kích hoạt
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/admin/customer?action=lock&userId=${c.userId}" 
                                                           class="btn btn-sm btn-outline-danger me-1" 
                                                           onclick="return confirm('Bạn có chắc muốn KHÓA tài khoản [${c.username}]?');" 
                                                           title="Khóa tài khoản">
                                                            <i class="bi bi-lock-fill"></i> Khóa
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/admin/customer?action=edit&id=${c.id}" 
                                               class="btn btn-sm btn-outline-warning me-1" title="Sửa thông tin">
                                                <i class="bi bi-pencil-square"></i> Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/customer?action=delete&id=${c.id}" 
                                               class="btn btn-sm btn-outline-danger" title="Xóa khách hàng">
                                                <i class="bi bi-trash3-fill"></i> Xóa
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
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
