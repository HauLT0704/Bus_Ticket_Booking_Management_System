<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-4">

    <!-- BREADCRUMB -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/search">Tìm chuyến</a></li>
            <li class="breadcrumb-item active" aria-current="page">Chọn ghế & Đặt vé</li>
        </ol>
    </nav>

    <!-- THÔNG BÁO LỖI NẾU CÓ -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- BANNER TỔNG QUAN CHUYẾN XE -->
    <div class="card shadow-sm border-0 rounded-4 mb-4 bg-primary text-white">
        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col-md-7">
                    <span class="badge bg-warning text-dark mb-2 fw-bold">
                        <i class="bi bi-bus-front-fill me-1"></i>${trip.vehicleType} (${trip.vehiclePlate})
                    </span>
                    <h3 class="fw-bold mb-1">
                        ${trip.fromLocationName} <i class="bi bi-arrow-right mx-2"></i> ${trip.toLocationName}
                    </h3>
                    <p class="mb-0 text-white-50">
                        <i class="bi bi-clock-fill me-1"></i>Khởi hành: 
                        <b><fmt:formatDate value="${trip.departureTime}" pattern="HH:mm - dd/MM/yyyy" /></b>
                    </p>
                </div>
                <div class="col-md-5 text-md-end mt-3 mt-md-0">
                    <div class="text-white-50 small">Giá vé mỗi ghế:</div>
                    <div class="fs-2 fw-bold text-warning">
                        <fmt:formatNumber value="${trip.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">

        <!-- CỘT BÊN TRÁI: SƠ ĐỒ CHỌN GHẾ BẰNG HTML/CSS (TV4) -->
        <div class="col-lg-7">
            <div class="card shadow-sm border-0 rounded-4 p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-dark mb-0">
                        <i class="bi bi-grid-3x3-gap-fill text-primary me-2"></i>Sơ Đồ Ghế Ngồi
                    </h5>
                    <span class="text-muted small">Nhấp vào ghế để chọn</span>
                </div>

                <!-- CHÚ THÍCH MÀU GHẾ -->
                <div class="d-flex justify-content-around bg-light py-2 px-3 rounded-3 mb-4 small">
                    <div class="d-flex align-items-center gap-2">
                        <div class="seat-sample seat-available-sample"></div>
                        <span>Ghế trống</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="seat-sample seat-selected-sample"></div>
                        <span>Đang chọn</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="seat-sample seat-booked-sample"></div>
                        <span>Đã đặt</span>
                    </div>
                </div>

                <!-- ĐẦU XE -->
                <div class="text-center p-2 mb-4 bg-light rounded-3 text-muted small fw-semibold">
                    <i class="bi bi-steering-wheel fs-5 me-1"></i> Khu Vực Bác Tài / Cửa Lên Xuống
                </div>

                <!-- KHU VỰC SƠ ĐỒ GHẾ: 2 DÃY / 2 TẦNG (A VÀ B) -->
                <div class="row g-3">
                    <!-- DÃY A -->
                    <div class="col-6">
                        <h6 class="text-center fw-bold text-primary mb-3">
                            <i class="bi bi-layers-fill me-1"></i>Tầng Dưới (Dãy A)
                        </h6>
                        <div class="seat-grid">
                            <c:forEach var="i" begin="1" end="18">
                                <c:set var="seatCode" value="${i < 10 ? 'A0' : 'A'}${i}" />
                                <c:set var="isBooked" value="${bookedSeats.contains(seatCode)}" />

                                <div class="seat-item ${isBooked ? 'seat-booked' : 'seat-available'}"
                                     data-seat="${seatCode}"
                                     onclick="toggleSeat(this, '${seatCode}')">
                                    <i class="bi bi-square-fill seat-icon"></i>
                                    <span class="seat-label">${seatCode}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- DÃY B -->
                    <div class="col-6 border-start ps-3">
                        <h6 class="text-center fw-bold text-success mb-3">
                            <i class="bi bi-layers-half me-1"></i>Tầng Trên (Dãy B)
                        </h6>
                        <div class="seat-grid">
                            <c:forEach var="i" begin="1" end="18">
                                <c:set var="seatCode" value="${i < 10 ? 'B0' : 'B'}${i}" />
                                <c:set var="isBooked" value="${bookedSeats.contains(seatCode)}" />

                                <div class="seat-item ${isBooked ? 'seat-booked' : 'seat-available'}"
                                     data-seat="${seatCode}"
                                     onclick="toggleSeat(this, '${seatCode}')">
                                    <i class="bi bi-square-fill seat-icon"></i>
                                    <span class="seat-label">${seatCode}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- CỘT BÊN PHẢI: FORM NHẬP THÔNG TIN KHÁCH HÀNG (TV4) -->
        <div class="col-lg-5">
            <div class="card shadow-sm border-0 rounded-4 p-4 bg-white sticky-top" style="top: 20px;">
                <h5 class="fw-bold text-dark mb-3">
                    <i class="bi bi-person-lines-fill text-primary me-2"></i>Thông Tin Đặt Vé
                </h5>

                <form id="bookingForm" action="${pageContext.request.contextPath}/booking/confirm" method="POST">
                    <input type="hidden" name="tripId" value="${trip.id}">
                    <input type="hidden" id="selectedSeatsInput" name="selectedSeats" value="">

                    <!-- DANH SÁCH GHẾ ĐÃ CHỌN -->
                    <div class="p-3 bg-light rounded-3 mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted small">Ghế đang chọn:</span>
                            <span id="selectedSeatsText" class="fw-bold text-primary">Chưa chọn ghế</span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted small">Số lượng vé:</span>
                            <span id="seatCountText" class="fw-bold">0 vé</span>
                        </div>
                        <hr class="my-2">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fw-bold text-dark">Tổng thanh toán:</span>
                            <span id="totalPriceText" class="fs-4 fw-bold text-danger">0 ₫</span>
                        </div>
                    </div>

                    <!-- FORM NHẬP THÔNG TIN KHÁCH HÀNG -->
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted mb-1">
                            Họ và tên khách hàng <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-person"></i></span>
                            <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted mb-1">
                            Số điện thoại liên hệ <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-telephone"></i></span>
                            <input type="tel" name="phone" class="form-control" placeholder="0912345678" pattern="[0-9]{9,11}" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted mb-1">
                            Email
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" class="form-control" placeholder="email@example.com">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted mb-1">
                            Số CMND / Căn cước (CCCD)
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-white"><i class="bi bi-card-text"></i></span>
                            <input type="text" name="idCard" class="form-control" placeholder="079xxxxxxxx">
                        </div>
                    </div>

                    <button type="submit" id="btnConfirmBooking" class="btn btn-warning w-100 py-3 fw-bold shadow-sm rounded-3" disabled>
                        <i class="bi bi-check-circle-fill me-1"></i>XÁC NHẬN ĐẶT VÉ
                    </button>

                    <div class="text-center mt-3 small text-muted">
                        <i class="bi bi-lock-fill text-success"></i> Giữ đúng chỗ ngồi & Xác nhận tức thì
                    </div>
                </form>

            </div>
        </div>

    </div>

</div>

<!-- CSS CHO SƠ ĐỒ GHẾ (TV4) -->
<style>
    .seat-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 12px;
    }

    .seat-item {
        border-radius: 8px;
        padding: 10px 4px;
        text-align: center;
        cursor: pointer;
        user-select: none;
        transition: all 0.2s ease;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        border: 2px solid #dee2e6;
        background-color: #ffffff;
    }

    .seat-item .seat-icon {
        font-size: 1.4rem;
        line-height: 1;
        color: #adb5bd;
    }

    .seat-item .seat-label {
        font-size: 0.8rem;
        font-weight: 700;
        margin-top: 4px;
    }

    /* Ghế còn trống */
    .seat-available:hover {
        border-color: #0d6efd;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(13, 110, 253, 0.2);
    }
    .seat-available:hover .seat-icon {
        color: #0d6efd;
    }

    /* Ghế đang chọn */
    .seat-selected {
        background-color: #0d6efd !important;
        border-color: #0a58ca !important;
        color: #ffffff !important;
        box-shadow: 0 4px 10px rgba(13, 110, 253, 0.35);
    }
    .seat-selected .seat-icon {
        color: #ffffff !important;
    }

    /* Ghế đã đặt */
    .seat-booked {
        background-color: #e9ecef !important;
        border-color: #ced4da !important;
        color: #6c757d !important;
        cursor: not-allowed !important;
        opacity: 0.6;
    }
    .seat-booked .seat-icon {
        color: #dc3545 !important;
    }

    /* Mẫu chú thích */
    .seat-sample {
        width: 18px;
        height: 18px;
        border-radius: 4px;
    }
    .seat-available-sample {
        border: 2px solid #adb5bd;
        background: #fff;
    }
    .seat-selected-sample {
        background: #0d6efd;
    }
    .seat-booked-sample {
        background: #e9ecef;
        border: 1px solid #ced4da;
    }
</style>

<!-- JAVASCRIPT CHỌN GHẾ REAL-TIME (TV4) -->
<script>
    const pricePerSeat = ${trip.price != null ? trip.price : 0};
    const selectedSeats = new Set();

    function toggleSeat(element, seatCode) {
        if (element.classList.contains('seat-booked')) {
            return; // Ghế đã đặt không cho bấm
        }

        if (selectedSeats.has(seatCode)) {
            selectedSeats.delete(seatCode);
            element.classList.remove('seat-selected');
        } else {
            selectedSeats.add(seatCode);
            element.classList.add('seat-selected');
        }

        updateSummary();
    }

    function updateSummary() {
        const seatsArray = Array.from(selectedSeats).sort();
        const count = seatsArray.length;
        const total = count * pricePerSeat;

        document.getElementById('selectedSeatsText').innerText = count > 0 ? seatsArray.join(', ') : 'Chưa chọn ghế';
        document.getElementById('seatCountText').innerText = count + ' vé';
        document.getElementById('totalPriceText').innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(total);

        document.getElementById('selectedSeatsInput').value = seatsArray.join(',');
        document.getElementById('btnConfirmBooking').disabled = count === 0;
    }
</script>

<%@ include file="/WEB-INF/common/footer.jsp" %>