<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Tuyến đường - Bus Booking System</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- NAVBAR ADMIN -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold d-flex align-items-center" href="${pageContext.request.contextPath}/admin/route">
                <i class="bi bi-bus-front-fill fs-4 me-2"></i> Bus Ticket Booking
            </a>
            <div class="d-flex align-items-center">
                <span class="text-white me-3 small">
                    <i class="bi bi-person-circle me-1"></i> Xin chào, <b>${currentUser.fullName != null ? currentUser.fullName : currentUser.username}</b>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm fw-semibold">
                    <i class="bi bi-box-arrow-right me-1"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <!-- CONTAINER CHÍNH -->
    <div class="container pb-5">

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

        <!-- TIÊU ĐỀ & NÚT THÊM MỚI -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="fw-bold text-dark mb-0">
                    <i class="bi bi-signpost-split-fill text-primary me-2"></i>Quản Lý Tuyến Đường
                </h4>
                <small class="text-secondary">Quản lý các cung đường di chuyển giữa các bến xe</small>
            </div>
            <a href="${pageContext.request.contextPath}/admin/route?action=add" class="btn btn-primary fw-bold shadow-sm">
                <i class="bi bi-plus-circle me-1"></i> Thêm Tuyến Đường Mới
            </a>
        </div>

        <!-- BẢNG DANH SÁCH -->
        <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-secondary border-bottom">
                        <tr>
                            <th class="text-center py-3" style="width: 70px;">MÃ</th>
                            <th class="py-3">ĐIỂM ĐI</th>
                            <th class="py-3">ĐIỂM ĐẾN</th>
                            <th class="py-3">QUÃNG ĐƯỜNG</th>
                            <th class="py-3">THỜI GIAN DỰ KIẾN</th>
                            <th class="text-center py-3" style="width: 140px;">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${list}">
                            <tr>
                                <td class="text-center fw-bold text-muted">#${r.id}</td>
                                <td class="fw-semibold text-dark">
                                    <i class="bi bi-geo-alt text-danger me-1"></i> ${r.fromLocation != null ? r.fromLocation.name : 'N/A'}
                                </td>
                                <td class="fw-semibold text-dark">
                                    <i class="bi bi-geo-alt-fill text-success me-1"></i> ${r.toLocation != null ? r.toLocation.name : 'N/A'}
                                </td>
                                <td>
                                    <span class="badge bg-info-subtle text-info border border-info-subtle rounded-pill px-3 py-2">
                                        <i class="bi bi-speedometer2 me-1"></i> ${r.distance} km
                                    </span>
                                </td>
                                <td class="text-secondary">
                                    <i class="bi bi-clock me-1"></i> ${r.duration} phút
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/admin/route?action=edit&id=${r.id}" 
                                       class="btn btn-sm btn-outline-warning border-0 me-1" title="Sửa">
                                        <i class="bi bi-pencil-square fs-6"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/route?action=delete&id=${r.id}" 
                                       class="btn btn-sm btn-outline-danger border-0" 
                                       onclick="return confirm('Bạn có chắc muốn xóa tuyến đường #${r.id} này không?');" title="Xóa">
                                        <i class="bi bi-trash3-fill fs-6"></i>
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
        </div>

    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>