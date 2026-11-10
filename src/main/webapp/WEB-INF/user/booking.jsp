<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- THÔNG BÁO THÀNH CÔNG -->
            <div class="text-center mb-4 d-print-none">
                <div class="d-inline-flex align-items-center justify-content-center bg-success text-white rounded-circle mb-3 shadow" style="width: 70px; height: 70px;">
                    <i class="bi bi-check-lg display-6"></i>
                </div>
                <h3 class="fw-bold text-success mb-1">Đặt Vé Thành Công!</h3>
                <p class="text-muted small">Cảm ơn bạn đã đặt vé. Dưới đây là thông tin chi tiết vé xe của bạn.</p>
            </div>

            <c:if test="${param.cancelMsg == 'success'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 shadow-sm d-print-none" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-4 me-3"></i>
                    <div>
                        <strong>Đã hủy vé thành công!</strong>
                        Cảnh báo vi phạm: Bạn đã hủy <b><c:out value="${param.cancelCount}"/>/3</b> vé. Nếu hủy từ <b>3 vé trở lên</b>, tài khoản của bạn sẽ bị khóa tự động do vi phạm chính sách đặt vé!
                    </div>
                </div>
            </c:if>

            <c:if test="${param.cancelMsg == 'unauthorized'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 shadow-sm d-print-none" role="alert">
                    <i class="bi bi-shield-x fs-4 me-3"></i>
                    <div>
                        <strong>Từ chối thao tác:</strong> Bạn không có quyền hủy vé này vì vé không thuộc quyền sở hữu của bạn!
                    </div>
                </div>
            </c:if>

            <c:if test="${param.cancelMsg == 'already_cancelled'}">
                <div class="alert alert-warning d-flex align-items-center mb-4 shadow-sm d-print-none" role="alert">
                    <i class="bi bi-info-circle-fill fs-4 me-3"></i>
                    <div>
                        <strong>Thông báo:</strong> Vé này đã ở trạng thái đã hủy trước đó.
                    </div>
                </div>
            </c:if>

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

                    <!-- THÔNG TIN KHÁCH HÀNG -->
                    <div class="p-3 mb-4 bg-light rounded-3 border">
                        <div class="row g-2">
                            <div class="col-md-6">
                                <span class="text-muted small d-block">Họ và tên khách hàng:</span>
                                <strong class="fs-6 text-primary">
                                    <i class="bi bi-person-fill me-1"></i><c:out value="${not empty customer.fullName ? customer.fullName : sessionScope.currentUser.fullName}"/>
                                </strong>
                            </div>
                            <div class="col-md-6">
                                <span class="text-muted small d-block">Số điện thoại liên hệ:</span>
                                <strong class="fs-6 text-dark">
                                    <i class="bi bi-telephone-fill me-1"></i><c:out value="${not empty customer.phone ? customer.phone : sessionScope.currentUser.phone}"/>
                                </strong>
                            </div>
                        </div>
                    </div>

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
                                    <th class="d-print-none">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${tickets}" var="ticket" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td class="fw-semibold">#VE${ticket.id}</td>
                                        <td><span class="badge bg-primary px-3 py-2 fs-6">${ticket.seatNumber}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${ticket.status == 'Đã hủy'}">
                                                    <span class="badge bg-danger-subtle text-danger">${ticket.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success-subtle text-success">${ticket.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="fw-bold">
                                            <fmt:formatNumber value="${ticket.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </td>
                                        <td class="d-print-none">
                                            <div class="d-flex justify-content-center gap-2">
                                                <c:if test="${ticket.status != 'Đã hủy'}">
                                                    <a href="${pageContext.request.contextPath}/print-ticket?id=${ticket.id}"
                                                       target="_blank" class="btn btn-sm btn-outline-primary" title="In thẻ vé riêng cho ghế này">
                                                        <i class="bi bi-printer me-1"></i>In riêng (Ghế ${ticket.seatNumber})
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/booking/cancel" method="POST" class="d-inline"
                                                          onsubmit="return confirm('Bạn có chắc chắn muốn hủy vé #VE${ticket.id} (Ghế ${ticket.seatNumber}) không? Lưu ý: Hủy từ 3 vé trở lên sẽ bị khóa tài khoản!');">
                                                        <input type="hidden" name="id" value="${ticket.id}">
                                                        <input type="hidden" name="tripId" value="${trip.id}">
                                                        <input type="hidden" name="customerId" value="${ticket.customerId}">
                                                        <input type="hidden" name="tickets" value="<c:out value='${param.tickets}'/>">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="bi bi-x-circle me-1"></i>Hủy vé
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${ticket.status == 'Đã hủy'}">
                                                    <span class="text-muted small fst-italic">Đã hủy</span>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="4" class="text-end fw-bold">Tổng thanh toán:</td>
                                    <td colspan="2" class="text-danger fw-bold fs-5">
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

            <!-- TÙY CHỌN IN VÉ (IN VÉ CHUNG HOẶC IN RIÊNG TỪNG GHẾ) -->
            <div class="card shadow-sm border-0 rounded-4 p-3 bg-white mb-4 d-print-none">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div>
                        <h6 class="fw-bold mb-1 text-dark">
                            <i class="bi bi-printer-fill text-primary me-2"></i>Tùy Chọn In Vé
                        </h6>
                        <small class="text-muted">Bạn có thể chọn in phiếu tổng hợp (in chung) hoặc in thẻ vé riêng cho từng ghế:</small>
                    </div>
                    <div class="d-flex flex-wrap gap-2 align-items-center">
                        <button type="button" onclick="window.print()" class="btn btn-outline-primary fw-semibold px-3 py-2">
                            <i class="bi bi-printer me-1"></i> In Vé Chung (Tất Cả Ghế)
                        </button>
                        <div class="dropdown">
                            <button class="btn btn-primary fw-semibold dropdown-toggle px-3 py-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-ticket-perforated-fill me-1"></i> In Vé Riêng Từng Ghế
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-3">
                                <li><h6 class="dropdown-header">Chọn ghế để mở trang in riêng:</h6></li>
                                <c:forEach items="${tickets}" var="t">
                                    <c:if test="${t.status != 'Đã hủy'}">
                                        <li>
                                            <a class="dropdown-item py-2 d-flex justify-content-between align-items-center" 
                                               href="${pageContext.request.contextPath}/print-ticket?id=${t.id}" target="_blank">
                                                <span><i class="bi bi-person-badge me-2 text-primary"></i>In Ghế <b>${t.seatNumber}</b></span>
                                                <span class="badge bg-light text-dark border">#VE${t.id}</span>
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- NÚT ĐIỀU HƯỚNG -->
            <div class="d-flex justify-content-between align-items-center d-print-none">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4 py-2">
                    <i class="bi bi-house me-1"></i>Về Trang Chủ
                </a>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary px-4 py-2 fw-semibold">
                    <i class="bi bi-plus-circle me-1"></i>Đặt Thêm Vé
                </a>
            </div>

        </div>
    </div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>