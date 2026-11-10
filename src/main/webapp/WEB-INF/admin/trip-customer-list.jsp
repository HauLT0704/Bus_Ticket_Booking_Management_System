<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-4">

    <!-- THANH ĐIỀU HƯỚNG VÀ NÚT IN -->
    <div class="d-flex justify-content-between align-items-center mb-4 d-print-none">
        <a href="${pageContext.request.contextPath}/admin/trip" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại quản lý chuyến
        </a>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-primary fw-semibold px-4" onclick="window.print()">
                <i class="bi bi-printer me-1"></i> In danh sách hành khách
            </button>
        </div>
    </div>

    <!-- TỜ IN DANH SÁCH HÀNH KHÁCH -->
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">

        <!-- HEADER BÁO CÁO -->
        <div class="row align-items-center pb-3 mb-4 border-bottom">
            <div class="col-8">
                <h3 class="fw-bold text-primary mb-1">
                    <i class="bi bi-bus-front-fill me-2"></i>DANH SÁCH HÀNH KHÁCH THEO CHUYẾN XE
                </h3>
                <p class="text-muted mb-0 small">Hệ Thống Quản Lý Đặt Vé Xe Khách Miền Tây</p>
            </div>
            <div class="col-4 text-end">
                <span class="badge bg-primary fs-6 px-3 py-2">Mã chuyến: #${tripId}</span>
            </div>
        </div>

        <!-- THÔNG TIN TỔNG QUAN CHUYẾN XE -->
        <c:if test="${not empty trip}">
            <div class="bg-light rounded-3 p-3 mb-4 border">
                <div class="row g-3">
                    <div class="col-md-4">
                        <span class="text-muted small d-block">Tuyến đường:</span>
                        <strong class="text-dark fs-6">${trip.fromLocation} &rarr; ${trip.toLocation}</strong>
                    </div>
                    <div class="col-md-4">
                        <span class="text-muted small d-block">Giờ khởi hành:</span>
                        <strong class="text-primary fs-6">
                            <fmt:formatDate value="${trip.departureTime}" pattern="HH:mm - dd/MM/yyyy" />
                        </strong>
                    </div>
                    <div class="col-md-4">
                        <span class="text-muted small d-block">Xe vận hành:</span>
                        <strong>${trip.vehicleType} (${trip.licensePlate})</strong>
                    </div>
                    <div class="col-md-4">
                        <span class="text-muted small d-block">Giá vé:</span>
                        <strong class="text-danger">
                            <fmt:formatNumber value="${trip.price}" pattern="#,##0" /> VNĐ
                        </strong>
                    </div>
                    <div class="col-md-4">
                        <span class="text-muted small d-block">Tổng số ghế:</span>
                        <strong>${trip.totalSeats} chỗ</strong>
                    </div>
                    <div class="col-md-4">
                        <span class="text-muted small d-block">Số khách đã đặt vé:</span>
                        <span class="badge bg-success fs-6">${customerList.size()} hành khách</span>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- BẢNG DANH SÁCH HÀNH KHÁCH -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-primary">
                    <tr>
                        <th class="text-center py-2" style="width: 50px;">STT</th>
                        <th class="text-center py-2" style="width: 80px;">SỐ GHẾ</th>
                        <th class="py-2">HỌ VÀ TÊN HÀNH KHÁCH</th>
                        <th class="py-2">SỐ ĐIỆN THOẠI</th>
                        <th class="py-2">EMAIL</th>
                        <th class="py-2">CCCD / CMND</th>
                        <th class="py-2">NGÀY ĐẶT</th>
                        <th class="text-end py-2">GIÁ TIỀN</th>
                        <th class="text-center py-2">TRẠNG THÁI</th>
                        <th class="text-center py-2 d-print-none">IN VÉ LẺ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty customerList}">
                            <c:forEach var="c" items="${customerList}" varStatus="status">
                                <tr>
                                    <td class="text-center fw-bold text-muted">${status.index + 1}</td>
                                    <td class="text-center">
                                        <span class="badge bg-primary-subtle text-primary fw-bold px-2 py-1">
                                            ${c.seatNumber}
                                        </span>
                                    </td>
                                    <td class="fw-semibold text-dark"><c:out value="${c.fullName}"/></td>
                                    <td><c:out value="${c.phone}"/></td>
                                    <td class="small text-muted">
                                        <c:choose>
                                            <c:when test="${not empty c.email}"><c:out value="${c.email}"/></c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty c.idCard}"><c:out value="${c.idCard}"/></c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="small text-muted">
                                        <fmt:formatDate value="${c.bookingTime}" pattern="HH:mm dd/MM/yyyy" />
                                    </td>
                                    <td class="text-end fw-semibold text-danger">
                                        <fmt:formatNumber value="${c.totalPrice}" pattern="#,##0" /> đ
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-success">
                                            ${c.ticketStatus}
                                        </span>
                                    </td>
                                    <td class="text-center d-print-none">
                                        <a href="${pageContext.request.contextPath}/print-ticket?id=${c.ticketId}"
                                           class="btn btn-sm btn-outline-primary" title="In vé của hành khách này">
                                            <i class="bi bi-printer"></i> In vé
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="10" class="text-center py-4 text-muted">
                                    <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                    Chưa có hành khách nào đặt vé cho chuyến xe này.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- CHỮ KÝ XÁC NHẬN (KHI IN) -->
        <div class="row mt-5 pt-4 text-center">
            <div class="col-4">
                <p class="mb-1 text-muted small">Tài xế / Phụ xe</p>
                <p class="fw-semibold text-dark mb-5">(Ký và ghi rõ họ tên)</p>
            </div>
            <div class="col-4">
                <p class="mb-1 text-muted small">Người lập bảng</p>
                <p class="fw-semibold text-dark mb-5">(Ký và ghi rõ họ tên)</p>
            </div>
            <div class="col-4">
                <p class="mb-1 text-muted small">Đại diện ban quản lý</p>
                <p class="fw-semibold text-dark mb-5">(Ký và đóng dấu)</p>
            </div>
        </div>

    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>
