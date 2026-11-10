<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Nhận Xóa Khách Hàng - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5.3 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-7">

                <!-- BREADCRUMB -->
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Bảng điều khiển</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/customer">Quản lý khách hàng</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Xác nhận xóa</li>
                    </ol>
                </nav>

                <!-- CARD XÁC NHẬN XÓA -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                    <div class="card-header bg-danger text-white py-3 px-4">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-exclamation-triangle-fill fs-4"></i>
                            <h5 class="fw-bold mb-0">CẢNH BÁO XÁC NHẬN XÓA KHÁCH HÀNG</h5>
                        </div>
                    </div>

                    <div class="card-body p-4 p-md-5">
                        <p class="text-danger fw-semibold mb-4">
                            Bạn có chắc chắn muốn xóa khách hàng dưới đây khỏi hệ thống không? Vui lòng kiểm tra kỹ thông tin trước khi thực hiện:
                        </p>

                        <!-- BẢNG CHI TIẾT THÔNG TIN KHÁCH HÀNG SẮP XÓA -->
                        <div class="bg-light rounded-3 p-4 border mb-4">
                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Mã khách hàng:</span>
                                    <strong class="fs-6 text-dark">#${customer.id}</strong>
                                </div>
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Tài khoản User liên kết:</span>
                                    <c:choose>
                                        <c:when test="${not empty customer.username}">
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                                <i class="bi bi-person-badge me-1"></i>${customer.username}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted fst-italic">Khách vãng lai (Chưa đăng ký)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Họ và tên:</span>
                                    <strong class="fs-6 text-primary">${customer.fullName}</strong>
                                </div>
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Số điện thoại:</span>
                                    <span class="badge bg-white text-dark border px-2 py-1 fs-6">${customer.phone}</span>
                                </div>
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Email:</span>
                                    <strong>${not empty customer.email ? customer.email : '-'}</strong>
                                </div>
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Số CCCD / CMND:</span>
                                    <strong>${not empty customer.idCard ? customer.idCard : '-'}</strong>
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-warning border-0 rounded-3 small mb-4 d-flex align-items-center">
                            <i class="bi bi-info-circle-fill me-2 fs-5 text-warning flex-shrink-0"></i>
                            <div>
                                <b>Lưu ý quan trọng:</b> Nếu khách hàng này đã từng đặt vé xe trong hệ thống, cơ sở dữ liệu sẽ chặn thao tác xóa để bảo vệ tính toàn vẹn của lịch sử chuyến xe và báo cáo doanh thu.
                            </div>
                        </div>

                        <!-- FORM POST XÁC NHẬN XÓA (CHUẨN POST AN TOÀN) -->
                        <form action="${pageContext.request.contextPath}/admin/customer" method="POST">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${customer.id}">

                            <div class="d-flex justify-content-end gap-2 pt-2 border-top">
                                <a href="${pageContext.request.contextPath}/admin/customer" class="btn btn-outline-secondary px-4 py-2">
                                    <i class="bi bi-x-circle me-1"></i> Hủy bỏ & Quay lại
                                </a>
                                <button type="submit" class="btn btn-danger px-4 py-2 fw-semibold shadow-sm">
                                    <i class="bi bi-trash3-fill me-1"></i> Xác Nhận Xóa Vĩnh Viễn
                                </button>
                            </div>
                        </form>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

</body>
</html>

