<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/common/header.jsp"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<c:set var="minLeadTime" value="${nowDate.time + 3600000}" />

<div class="container py-4">

    <!-- TIÊU ĐỀ & QUAY LẠI -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h3 class="fw-bold text-dark mb-1">
                <i class="bi bi-arrow-left-right text-primary me-2"></i>Gợi Ý Ghép Chuyến (Nối Chuyến)
            </h3>
            <p class="text-muted mb-0 small">
                Giải pháp di chuyển thông minh bằng cách kết hợp 2 chặng xe khi chuyến đi thẳng hết vé
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Quay lại trang chủ
        </a>
    </div>

    <!-- THÔNG TIN TÌM KIẾM -->
    <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white">
        <div class="row g-3 text-center align-items-center">
            <div class="col-6 col-md-3">
                <span class="text-muted small d-block">Điểm khởi hành</span>
                <strong class="text-primary fs-6">
                    <c:choose>
                        <c:when test="${not empty fromName}">${fromName}</c:when>
                        <c:otherwise>Trạm #${fromId}</c:otherwise>
                    </c:choose>
                </strong>
            </div>
            <div class="col-6 col-md-3">
                <span class="text-muted small d-block">Điểm đến đích</span>
                <strong class="text-success fs-6">
                    <c:choose>
                        <c:when test="${not empty toName}">${toName}</c:when>
                        <c:otherwise>Trạm #${toId}</c:otherwise>
                    </c:choose>
                </strong>
            </div>
            <div class="col-6 col-md-3">
                <span class="text-muted small d-block">Ngày khởi hành</span>
                <strong class="text-dark fs-6">${selectedDate}</strong>
            </div>
            <div class="col-6 col-md-3">
                <span class="text-muted small d-block">Số lượng khách</span>
                <strong class="text-danger fs-6">${guests} người</strong>
            </div>
        </div>
    </div>

    <!-- PHẦN 1: KẾT QUẢ NỐI 2 CHẶNG TRUNG GIAN (TRANSFER DAO - TV6) -->
    <c:choose>
        <c:when test="${not empty transferOptions}">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-dark mb-0">
                    <i class="bi bi-diagram-3-fill text-primary me-1"></i>Lộ trình nối 2 chặng qua trạm trung chuyển
                </h5>
                <span class="badge bg-primary px-3 py-2">Tìm thấy ${transferOptions.size()} lựa chọn</span>
            </div>

            <c:forEach var="option" items="${transferOptions}">
                <div class="card border-0 shadow-sm rounded-4 mb-4 bg-white overflow-hidden">
                    <div class="card-body p-4">

                        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 border-bottom pb-2">
                            <h6 class="fw-bold text-primary mb-0">
                                <i class="bi bi-shuffle me-2"></i>Hành trình nối 2 chặng (Trung chuyển tại: ${option.transferLocationName})
                            </h6>
                            <span class="badge bg-warning text-dark px-3 py-1">Đảm bảo đủ ghế trống cho ${guests} hành khách</span>
                        </div>

                        <div class="row g-3">
                            <!-- CHẶNG 1 -->
                            <div class="col-md-5">
                                <div class="bg-light rounded-3 p-3 h-100 border">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="badge bg-primary px-2 py-1">Chặng 1 (${fromName} &rarr; ${option.transferLocationName})</span>
                                        <span class="text-muted small">Mã: #${option.firstTrip.id}</span>
                                    </div>
                                    <p class="mb-1 small">
                                        <i class="bi bi-clock-fill text-primary me-1"></i>
                                        Khởi hành: <b><fmt:formatDate value="${option.firstTrip.departureTime}" pattern="HH:mm - dd/MM/yyyy"/></b>
                                    </p>
                                    <p class="mb-1 small">
                                        <i class="bi bi-geo-alt text-success me-1"></i>
                                        Đến trạm ${option.transferLocationName}: <b><fmt:formatDate value="${option.firstTrip.arrivalTime}" pattern="HH:mm - dd/MM/yyyy"/></b>
                                    </p>
                                    <p class="mb-2 small">
                                        Ghế trống: <b class="text-success">${option.firstTrip.availableSeats} chỗ</b> &bull; 
                                        Giá: <b class="text-danger"><fmt:formatNumber value="${option.firstTrip.price}" pattern="#,##0"/> đ</b>
                                    </p>
                                    <c:choose>
                                        <c:when test="${option.firstTrip.departureTime.time <= nowDate.time}">
                                            <button class="btn btn-secondary btn-sm w-100 fw-semibold" disabled title="Chuyến xe đã khởi hành">
                                                <i class="bi bi-clock-history me-1"></i> Đã khởi hành
                                            </button>
                                        </c:when>
                                        <c:when test="${option.firstTrip.departureTime.time < minLeadTime}">
                                            <button class="btn btn-secondary btn-sm w-100 fw-semibold" disabled title="Đã đóng cổng đặt vé trực tuyến (dưới 60 phút)">
                                                <i class="bi bi-hourglass-bottom me-1"></i> Đã đóng cổng đặt vé
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/booking/seats?tripId=${option.firstTrip.id}" 
                                               class="btn btn-outline-primary btn-sm w-100 fw-semibold">
                                                <i class="bi bi-ticket-perforated me-1"></i> Chọn ghế chặng 1
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- MŨI TÊN NỐI -->
                            <div class="col-md-2 d-none d-md-flex flex-column align-items-center justify-content-center text-center">
                                <div class="p-2 bg-light rounded-circle border mb-1">
                                    <i class="bi bi-arrow-right fs-4 text-primary"></i>
                                </div>
                                <span class="badge bg-secondary-subtle text-dark small">${option.transferLocationName}</span>
                            </div>

                            <!-- CHẶNG 2 -->
                            <div class="col-md-5">
                                <div class="bg-light rounded-3 p-3 h-100 border">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="badge bg-success px-2 py-1">Chặng 2 (${option.transferLocationName} &rarr; ${toName})</span>
                                        <span class="text-muted small">Mã: #${option.secondTrip.id}</span>
                                    </div>
                                    <p class="mb-1 small">
                                        <i class="bi bi-clock-fill text-success me-1"></i>
                                        Khởi hành: <b><fmt:formatDate value="${option.secondTrip.departureTime}" pattern="HH:mm - dd/MM/yyyy"/></b>
                                    </p>
                                    <p class="mb-1 small">
                                        <i class="bi bi-flag-fill text-danger me-1"></i>
                                        Đến đích (${toName}): <b><fmt:formatDate value="${option.secondTrip.arrivalTime}" pattern="HH:mm - dd/MM/yyyy"/></b>
                                    </p>
                                    <p class="mb-2 small">
                                        Ghế trống: <b class="text-success">${option.secondTrip.availableSeats} chỗ</b> &bull; 
                                        Giá: <b class="text-danger"><fmt:formatNumber value="${option.secondTrip.price}" pattern="#,##0"/> đ</b>
                                    </p>
                                    <c:choose>
                                        <c:when test="${option.secondTrip.departureTime.time <= nowDate.time}">
                                            <button class="btn btn-secondary btn-sm w-100 fw-semibold" disabled title="Chuyến xe đã khởi hành">
                                                <i class="bi bi-clock-history me-1"></i> Đã khởi hành
                                            </button>
                                        </c:when>
                                        <c:when test="${option.secondTrip.departureTime.time < minLeadTime}">
                                            <button class="btn btn-secondary btn-sm w-100 fw-semibold" disabled title="Đã đóng cổng đặt vé trực tuyến (dưới 60 phút)">
                                                <i class="bi bi-hourglass-bottom me-1"></i> Đã đóng cổng đặt vé
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/booking/seats?tripId=${option.secondTrip.id}" 
                                               class="btn btn-outline-success btn-sm w-100 fw-semibold">
                                                <i class="bi bi-ticket-perforated me-1"></i> Chọn ghế chặng 2
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- TỔNG TIỀN -->
                        <div class="d-flex flex-wrap justify-content-between align-items-center mt-3 pt-3 border-top">
                            <div>
                                <span class="text-muted small">Tổng giá vé ước tính cho cả 2 chặng:</span>
                                <h4 class="fw-bold text-danger mb-0">
                                    <fmt:formatNumber value="${option.firstTrip.price + option.secondTrip.price}" pattern="#,##0"/> đ / khách
                                </h4>
                            </div>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle p-2">
                                Tiết kiệm thời gian chờ đợi
                            </span>
                        </div>

                    </div>
                </div>
            </c:forEach>
        </c:when>
    </c:choose>

    <!-- PHẦN 2: GỢI Ý GHÉP CHUYẾN TUYẾN DÀI ĐI NGANG QUA (VD: HẾT GHẾ CT - HCM CÓ THỂ GHÉP CÀ MAU - HCM) -->
    <c:if test="${not empty passThroughTrips}">
        <div class="d-flex justify-content-between align-items-center mb-3 mt-4">
            <h5 class="fw-bold text-dark mb-0">
                <i class="bi bi-signpost-split-fill text-success me-1"></i>Gợi ý ghép tuyến đường dài đi ngang qua điểm đón (Ví dụ: ghép tuyến Cà Mau &rarr; ${toName})
            </h5>
            <span class="badge bg-success px-3 py-2">${passThroughTrips.size()} chuyến tuyến dài</span>
        </div>

        <c:forEach var="pt" items="${passThroughTrips}">
            <div class="card border-0 shadow-sm rounded-4 mb-3 bg-white">
                <div class="card-body p-3">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <span class="badge bg-warning text-dark mb-2">Ghép chuyến tuyến liên tỉnh</span>
                            <span class="badge bg-secondary-subtle text-dark ms-1">${pt.trip1Type} (${pt.trip1Plate})</span>
                            <div class="fs-6 fw-bold text-dark">
                                Tuyến gốc: <span class="text-secondary">${pt.fromName}</span>
                                <i class="bi bi-arrow-right mx-1"></i>
                                <span class="text-primary">Đón khách ghép tại: ${pt.midName}</span>
                                <i class="bi bi-arrow-right mx-1"></i>
                                <span class="text-success">${pt.toName}</span>
                            </div>
                            <div class="small text-muted mt-1">
                                <i class="bi bi-clock me-1"></i>Khởi hành: <b><fmt:formatDate value="${pt.trip1Dep}" pattern="HH:mm - dd/MM/yyyy"/></b>
                                &bull; Còn trống: <b class="text-success">${pt.trip1Seats} chỗ</b>
                            </div>
                        </div>
                        <div class="col-md-4 text-md-end mt-3 mt-md-0">
                            <div class="text-danger fw-bold fs-4 mb-1">
                                <fmt:formatNumber value="${pt.totalPrice}" pattern="#,##0"/> đ
                            </div>
                            <c:choose>
                                <c:when test="${pt.trip1Dep.time <= nowDate.time}">
                                    <button class="btn btn-secondary btn-sm px-4 fw-semibold" disabled title="Chuyến xe đã khởi hành">
                                        <i class="bi bi-clock-history me-1"></i> Đã khởi hành
                                    </button>
                                </c:when>
                                <c:when test="${pt.trip1Dep.time < minLeadTime}">
                                    <button class="btn btn-secondary btn-sm px-4 fw-semibold" disabled title="Đã đóng cổng đặt vé trực tuyến (dưới 60 phút)">
                                        <i class="bi bi-hourglass-bottom me-1"></i> Đóng cổng đặt vé
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/booking/seats?tripId=${pt.trip1Id}" class="btn btn-primary btn-sm px-4 fw-semibold">
                                        <i class="bi bi-check2-circle me-1"></i>Chọn Ghép Tuyến Này
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <c:if test="${empty transferOptions and empty passThroughTrips}">
        <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
            <i class="bi bi-calendar-x display-3 text-warning mb-3"></i>
            <h4 class="fw-bold">Không tìm thấy phương án ghép chuyến phù hợp!</h4>
            <p class="text-muted mb-4">
                Hiện chưa có lộ trình trung chuyển nào nối giữa 2 địa điểm này vào ngày bạn đã chọn.
            </p>
            <div>
                <a href="${pageContext.request.contextPath}/home?mode=transfer" class="btn btn-primary px-4">
                    <i class="bi bi-arrow-repeat me-1"></i> Tìm ngày hoặc tuyến khác
                </a>
            </div>
        </div>
    </c:if>

</div>

<%@ include file="/WEB-INF/common/footer.jsp"%>
