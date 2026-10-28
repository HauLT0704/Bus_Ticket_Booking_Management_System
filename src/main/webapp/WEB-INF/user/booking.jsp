<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- THÔNG BÁO THÀNH CÔNG -->
            <div class="text-center mb-4">
                <div class="d-inline-flex align-items-center justify-content-center bg-success text-white rounded-circle mb-3 shadow" style="width: 70px; height: 70px;">
                    <i class="bi bi-check-lg display-6"></i>
                </div>
                <h3 class="fw-bold text-success mb-1">Đặt Vé Thành Công!</h3>
                <p class="text-muted small">Cảm ơn bạn đã đặt vé. Dưới đây là thông tin chi tiết vé xe của bạn.</p>
            </div>

            <!-- PHIẾU VÉ ĐIỆN TỬ -->
            <div class="card shadow-sm border-0 rounded-4 overflow-hidden mb-4 bg-white" id="ticketInvoice">
                
                <div class="card-header bg-primary text-white p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="badge bg-warning text-dark mb-1">Vé Xe Điện Tử</span>
                            <h5 class="fw-bold mb-0">${trip.fromLocationName} <i class="bi bi-arrow-right mx-1"></i> ${trip.toLocationName}</h5>
                        </div>
                        <div class="text-end">
                            <small class="text-white-50 d-block">Giờ khởi hành</small>
                            <b><fmt:formatDate value="${trip.departureTime}" pattern="HH:mm - dd/MM/yyyy" /></b>
                        </div>
                    </div>
                </div>

                <div class="card-body p-4">

                    <!-- THÔNG TIN CHUYẾN XE -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold">Điểm xuất phát</label>
                            <div class="fs-6 fw-bold text-dark">${trip.fromLocationName}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold">Điểm đến</label>
                            <div class="fs-6 fw-bold text-dark">${trip.toLocationName}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold">Loại xe</label>
                            <div class="fs-6 text-dark">${trip.vehicleType}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold">Biển số xe</label>
                            <div class="fs-6 text-dark"><span class="badge bg-secondary-subtle text-dark">${trip.vehiclePlate}</span></div>
                        </div>
                    </div>

                    <!-- BẢNG CHI TIẾT VÉ ĐÃ ĐẶT -->
                    <div class="table-responsive mb-4">
                        <table class="table table-bordered align-middle text-center mb-0">
                            <thead class="table-light small">
                                <tr>
                                    <th>STT</th>
                                    <th>Mã vé</th>
                                    <th>Số ghế</th>
                                    <th>Trạng thái</th>
                                    <th>Đơn giá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${tickets}" var="ticket" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td class="fw-semibold">#VE${ticket.id}</td>
                                        <td><span class="badge bg-primary px-3 py-2 fs-6">${ticket.seatNumber}</span></td>
                                        <td><span class="badge bg-success-subtle text-success">${ticket.status}</span></td>
                                        <td class="fw-bold">
                                            <fmt:formatNumber value="${ticket.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="4" class="text-end fw-bold">Tổng thanh toán:</td>
                                    <td class="text-danger fw-bold fs-5">
                                        <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <div class="alert alert-warning py-2 px-3 small mb-0 rounded-3">
                        <i class="bi bi-info-circle-fill me-1"></i>
                        Vui lòng có mặt tại bến xe trước giờ xuất bến <b>30 phút</b> để làm thủ tục lên xe.
                    </div>

                </div>
            </div>

            <!-- NÚT ĐIỀU HƯỚNG -->
            <div class="d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4 py-2">
                    <i class="bi bi-house me-1"></i>Về Trang Chủ
                </a>
                <div class="d-flex gap-2">
                    <button onclick="window.print()" class="btn btn-outline-primary px-4 py-2">
                        <i class="bi bi-printer me-1"></i>In Phiếu Vé
                    </button>
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary px-4 py-2 fw-semibold">
                        <i class="bi bi-plus-circle me-1"></i>Đặt Thêm Vé
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>

<style>
    @media print {
        body * {
            visibility: hidden;
        }
        #ticketInvoice, #ticketInvoice * {
            visibility: visible;
        }
        #ticketInvoice {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            border: 1px solid #000 !important;
            box-shadow: none !important;
        }
    }
</style>

<%@ include file="/WEB-INF/common/footer.jsp" %>