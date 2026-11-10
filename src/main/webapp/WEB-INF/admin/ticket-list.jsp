<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Vé Xe - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5.3 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container-fluid px-lg-4 py-4">

        <!-- THÔNG BÁO FEEDBACK -->
        <c:if test="${param.msg == 'cancelled'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Thành công!</strong> Đã hủy vé <b>#VE${param.id}</b> và hoàn lại ghế trống cho chuyến xe.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'cancel_failed'}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Thất bại!</strong> Không thể hủy vé này (có thể vé đã bị hủy trước đó).
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'invalid_id'}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2"></i> <strong>Cảnh báo!</strong> Mã vé không hợp lệ!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- TIÊU ĐỀ & NÚT ĐẶT VÉ HỘ KHÁCH HÀNG -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="bi bi-ticket-perforated-fill text-primary me-2"></i>Quản Lý Vé Xe
                </h3>
                <p class="text-muted mb-0 small">Tra cứu, in thẻ vé, hủy vé và tiếp nhận đặt vé qua tổng đài hotline cho hành khách</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-warning fw-bold px-3 py-2 shadow-sm text-dark">
                    <i class="bi bi-telephone-inbound-fill me-1 text-danger"></i> + Đặt Vé Hộ Khách (Điện Thoại)
                </a>
            </div>
        </div>

        <div class="card border-0 shadow-sm rounded-4 bg-white p-4">

            <!-- BỘ LỌC TÌM KIẾM -->
            <form action="${pageContext.request.contextPath}/admin/tickets" method="GET" class="mb-4">
                <div class="row g-2 align-items-center">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search text-muted"></i></span>
                            <input type="text" name="keyword" class="form-control" 
                                   placeholder="Nhập mã vé, SĐT, tên khách, tuyến đường, số ghế..." 
                                   value="<c:out value='${keyword}'/>">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select name="status" class="form-select">
                            <option value="Tất cả" <c:if test="${selectedStatus == 'Tất cả' or empty selectedStatus}">selected</c:if>>-- Tất cả trạng thái --</option>
                            <option value="Đã thanh toán" <c:if test="${selectedStatus == 'Đã thanh toán'}">selected</c:if>>Đã thanh toán</option>
                            <option value="Đã hủy" <c:if test="${selectedStatus == 'Đã hủy'}">selected</c:if>>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-outline-primary px-3">
                            <i class="bi bi-search me-1"></i> Lọc vé
                        </button>
                        <c:if test="${not empty keyword or (not empty selectedStatus and selectedStatus != 'Tất cả')}">
                            <a href="${pageContext.request.contextPath}/admin/tickets" class="btn btn-outline-secondary px-3 ms-1">
                                <i class="bi bi-x-circle me-1"></i> Xóa lọc
                            </a>
                        </c:if>
                        <span class="text-muted small ms-2">Tìm thấy: <b>${totalTickets}</b> vé</span>
                    </div>
                </div>
            </form>

            <!-- BẢNG DANH SÁCH VÉ -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light small">
                        <tr>
                            <th class="py-3 ps-3" style="width: 80px;">Mã Vé</th>
                            <th class="py-3">Khách Hàng</th>
                            <th class="py-3">Số Điện Thoại</th>
                            <th class="py-3">Tuyến Đường</th>
                            <th class="py-3">Khởi Hành</th>
                            <th class="py-3 text-center">Ghế</th>
                            <th class="py-3 text-end">Giá Tiền</th>
                            <th class="py-3 text-center">Trạng Thái</th>
                            <th class="py-3 text-center" style="width: 170px;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty ticketList}">
                                <c:forEach var="t" items="${ticketList}">
                                    <tr>
                                        <td class="ps-3 fw-bold text-primary">#VE${t.id}</td>
                                        <td class="fw-semibold text-dark">
                                            <i class="bi bi-person-circle text-secondary me-1"></i>
                                            <c:out value="${t.customerName}"/>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border">
                                                <c:out value="${t.customerPhone}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="fw-semibold">${t.fromName}</span> 
                                            <i class="bi bi-arrow-right text-muted mx-1"></i> 
                                            <span class="fw-semibold">${t.toName}</span>
                                        </td>
                                        <td class="small">
                                            <fmt:formatDate value="${t.departureTime}" pattern="HH:mm - dd/MM/yyyy" />
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary px-2 py-1 fs-6">${t.seatNumber}</span>
                                        </td>
                                        <td class="text-end fw-bold text-danger">
                                            <fmt:formatNumber value="${t.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${t.status == 'Đã hủy'}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                        <i class="bi bi-x-circle me-1"></i>Đã hủy
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                        <i class="bi bi-check-circle me-1"></i>${t.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center text-nowrap">
                                            <c:if test="${t.status != 'Đã hủy'}">
                                                <a href="${pageContext.request.contextPath}/print-ticket?id=${t.id}" target="_blank"
                                                   class="btn btn-sm btn-outline-primary me-1" title="In thẻ vé">
                                                    <i class="bi bi-printer"></i> In
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/tickets?action=cancel&id=${t.id}" 
                                                   class="btn btn-sm btn-outline-danger" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn HỦY vé #VE${t.id} cho khách hàng ${t.customerName} không? Ghế sẽ được hoàn lại cho chuyến xe.');" 
                                                   title="Hủy vé">
                                                    <i class="bi bi-x-circle"></i> Hủy
                                                </a>
                                            </c:if>
                                            <c:if test="${t.status == 'Đã hủy'}">
                                                <span class="text-muted small fst-italic">Đã hoàn ghế</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="bi bi-ticket-detailed fs-1 d-block mb-2 text-secondary"></i>
                                        Không tìm thấy vé xe nào phù hợp với điều kiện tìm kiếm!
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- PHÂN TRANG (TV5) -->
            <jsp:include page="../common/pagination.jsp" />

        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

</body>
</html>

