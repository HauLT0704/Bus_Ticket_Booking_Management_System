<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Chuyến xe - Bus Booking System</title>
        <!-- Bootstrap 5.3 & Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    </head>
    <body class="bg-light">

        <!-- NAVBAR ADMIN -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm mb-4">
            <div class="container">
                <a class="navbar-brand fw-bold d-flex align-items-center" href="${pageContext.request.contextPath}/admin/trip">
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

            <!-- TIÊU ĐỀ & NÚT THÊM MỚI -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h4 class="fw-bold text-dark mb-0">
                        <i class="bi bi-calendar-check-fill text-success me-2"></i>Quản Lý Chuyến Xe
                    </h4>
                    <small class="text-secondary">Quản lý lịch trình khởi hành, giá vé và số ghế trống</small>
                </div>
                <a href="${pageContext.request.contextPath}/admin/trip?action=add" class="btn btn-primary fw-bold shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i> Thêm Chuyến Xe Mới
                </a>
            </div>

            <!-- BẢNG DANH SÁCH -->
            <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-secondary border-bottom">
                            <tr>
                                <th class="text-center py-3" style="width: 70px;">MÃ</th>
                                <th class="py-3">TUYẾN ĐƯỜNG</th>
                                <th class="py-3">XE (BIỂN SỐ)</th>
                                <th class="py-3">GIỜ KHỞI HÀNH</th>
                                <th class="py-3">GIỜ ĐẾN</th>
                                <th class="text-center py-3">GHẾ TRỐNG</th>
                                <th class="py-3">GIÁ VÉ</th>
                                <th class="py-3">TRẠNG THÁI</th>
                                <th class="text-center py-3" style="width: 130px;">HÀNH ĐỘNG</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${list}">
                                <tr>
                                    <td class="text-center fw-bold text-muted">#${t.id}</td>
                                    
                                    <td class="fw-semibold text-dark">${t.displayRouteName}</td>
                                    <td class="text-secondary"><i class="bi bi-truck me-1"></i> ${t.displayVehicleName}</td>
                                    <td class="small text-nowrap">${t.departureTime}</td>
                                    <td class="small text-nowrap">${t.arrivalTime}</td>
                                    <td class="text-center fw-bold text-primary">${t.availableSeats}</td>
                                    <td class="fw-bold text-danger">${t.price} VNĐ</td>
                                    <td>
                                        <span class="badge ${t.status == 'Active' || t.status == 'Đang chạy' ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-secondary-subtle text-secondary border border-secondary-subtle'} rounded-pill px-3 py-1">
                                            ${t.status}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin/trip?action=edit&id=${t.id}" 
                                           class="btn btn-sm btn-outline-warning border-0 me-1" title="Sửa">
                                            <i class="bi bi-pencil-square fs-6"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/trip?action=delete&id=${t.id}" 
                                           class="btn btn-sm btn-outline-danger border-0" 
                                           onclick="return confirm('Bạn có chắc muốn xóa chuyến xe #${t.id} này không?');" title="Xóa">
                                            <i class="bi bi-trash3-fill fs-6"></i>
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
            </div>

        </div>

        <!-- Bootstrap Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>