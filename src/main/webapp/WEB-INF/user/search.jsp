<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="container py-4">

    <!-- KHỐI TÌM KIẾM CHUYẾN XE (PHÂN CÔNG TV4) -->
    <div class="card shadow-sm border-0 rounded-4 mb-4" style="background: linear-gradient(135deg, #0d6efd 0%, #0043a8 100%);">
        <div class="card-body p-4 text-white">
            <h3 class="fw-bold mb-1"><i class="bi bi-search me-2"></i>Tìm Vé Xe Khách</h3>
            <p class="text-white-50 mb-3 small">Tra cứu lịch trình và giá vé các tuyến đường</p>

            <form action="${pageContext.request.contextPath}/search" method="GET" class="bg-white p-3 rounded-3 text-dark shadow-sm">
                <div class="row g-2 align-items-end">

                    <!-- Điểm đi -->
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted mb-1">
                            <i class="bi bi-geo-alt-fill text-danger me-1"></i>Điểm đi
                        </label>
                        <select name="from" class="form-select form-select-sm">
                            <option value="">-- Tất cả điểm đi --</option>
                            <option value="Cần Thơ" ${selectedFrom == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                            <option value="TP.HCM" ${selectedFrom == 'TP.HCM' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                            <option value="Đà Lạt" ${selectedFrom == 'Đà Lạt' ? 'selected' : ''}>Đà Lạt (Lâm Đồng)</option>
                            <option value="Nha Trang" ${selectedFrom == 'Nha Trang' ? 'selected' : ''}>Nha Trang (Khánh Hòa)</option>
                            <option value="Đà Nẵng" ${selectedFrom == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                            <option value="Hà Nội" ${selectedFrom == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                        </select>
                    </div>

                    <!-- Điểm đến -->
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted mb-1">
                            <i class="bi bi-flag-fill text-success me-1"></i>Điểm đến
                        </label>
                        <select name="to" class="form-select form-select-sm">
                            <option value="">-- Tất cả điểm đến --</option>
                            <option value="Cần Thơ" ${selectedTo == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                            <option value="TP.HCM" ${selectedTo == 'TP.HCM' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                            <option value="Đà Lạt" ${selectedTo == 'Đà Lạt' ? 'selected' : ''}>Đà Lạt (Lâm Đồng)</option>
                            <option value="Nha Trang" ${selectedTo == 'Nha Trang' ? 'selected' : ''}>Nha Trang (Khánh Hòa)</option>
                            <option value="Đà Nẵng" ${selectedTo == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                            <option value="Hà Nội" ${selectedTo == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                        </select>
                    </div>

                    <!-- Ngày đi -->
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted mb-1">
                            <i class="bi bi-calendar-event me-1 text-primary"></i>Ngày đi
                        </label>
                        <input type="date" name="date" class="form-control form-control-sm" value="${selectedDate}">
                    </div>

                    <!-- Số khách -->
                    <div class="col-md-1">
                        <label class="form-label small fw-bold text-muted mb-1">
                            <i class="bi bi-people-fill text-info me-1"></i>Khách
                        </label>
                        <input type="number" name="guests" min="1" max="10" class="form-control form-control-sm" value="${selectedGuests != null ? selectedGuests : 1}">
                    </div>

                    <!-- Nút tìm kiếm -->
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-warning btn-sm w-100 fw-bold py-2 shadow-sm">
                            <i class="bi bi-search me-1"></i>Tìm chuyến
                        </button>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <!-- DANH SÁCH CHUYẾN XE PHÙ HỢP -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="fw-bold mb-0 text-dark">
            <i class="bi bi-bus-front text-primary me-2"></i>Danh Sách Chuyến Xe Phù Hợp
        </h4>
        <span class="badge bg-primary fs-6 px-3 py-2 rounded-pill">
            ${trips != null ? trips.size() : 0} chuyến xe
        </span>
    </div>

    <c:choose>
        <c:when test="${not empty trips}">
            <div class="d-flex flex-column gap-3">
                <c:forEach items="${trips}" var="trip">
                    <div class="card shadow-sm border-0 rounded-3 hover-shadow transition">
                        <div class="card-body p-3">
                            <div class="row align-items-center">

                                <!-- Giờ xe & Tuyến đường -->
                                <div class="col-md-5">
                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <span class="badge bg-light text-dark border">
                                            <i class="bi bi-truck-front text-primary me-1"></i>${trip.vehicleType}
                                        </span>
                                        <span class="badge bg-secondary-subtle text-secondary small">
                                            BS: ${trip.vehiclePlate}
                                        </span>
                                        <span class="badge ${trip.availableSeats > 5 ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-danger'} small">
                                            Còn ${trip.availableSeats} chỗ trống
                                        </span>
                                    </div>

                                    <div class="d-flex align-items-center gap-3">
                                        <div>
                                            <h5 class="fw-bold text-primary mb-0">
                                                <fmt:formatDate value="${trip.departureTime}" pattern="HH:mm" />
                                            </h5>
                                            <small class="text-muted d-block fw-semibold">${trip.fromLocationName}</small>
                                            <small class="text-muted" style="font-size: 0.75rem;">
                                                <fmt:formatDate value="${trip.departureTime}" pattern="dd/MM/yyyy" />
                                            </small>
                                        </div>

                                        <div class="text-center px-2">
                                            <span class="text-muted small d-block">${trip.duration != null ? trip.duration : 240} phút</span>
                                            <i class="bi bi-arrow-right fs-4 text-secondary"></i>
                                            <span class="text-muted small d-block">${trip.distance != null ? trip.distance : 150} km</span>
                                        </div>

                                        <div>
                                            <h5 class="fw-bold text-success mb-0">
                                                <fmt:formatDate value="${trip.arrivalTime}" pattern="HH:mm" />
                                            </h5>
                                            <small class="text-muted d-block fw-semibold">${trip.toLocationName}</small>
                                            <small class="text-muted" style="font-size: 0.75rem;">
                                                <fmt:formatDate value="${trip.arrivalTime}" pattern="dd/MM/yyyy" />
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Tiện ích & Giá vé -->
                                <div class="col-md-4 text-center border-start border-end">
                                    <div class="d-flex justify-content-center gap-3 text-muted small mb-2">
                                        <span><i class="bi bi-wifi text-primary"></i> Wifi</span>
                                        <span><i class="bi bi-water text-info"></i> Nước</span>
                                        <span><i class="bi bi-lightning-charge text-warning"></i> Sạc</span>
                                    </div>
                                    <div class="text-danger fw-bold fs-4">
                                        <fmt:formatNumber value="${trip.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                    </div>
                                    <span class="text-muted small">/ vé</span>
                                </div>

                                <!-- Nút chọn chuyến -> Chuyển sang sơ đồ ghế (TV4) -->
                                <div class="col-md-3 text-end">
                                    <c:choose>
                                        <c:when test="${trip.availableSeats > 0}">
                                            <a href="${pageContext.request.contextPath}/booking/seats?tripId=${trip.id}" 
                                               class="btn btn-primary px-4 py-2 fw-semibold shadow-sm w-100 mb-1">
                                                <i class="bi bi-check2-circle me-1"></i>Chọn Chuyến
                                            </a>
                                            <span class="text-success small d-block text-center">
                                                <i class="bi bi-shield-check"></i> Xác nhận trực tuyến
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-secondary px-4 py-2 fw-semibold w-100" disabled>
                                                <i class="bi bi-x-circle me-1"></i>Hết Vé
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <!-- Khi không có chuyến nào -->
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
                <i class="bi bi-calendar-x text-warning display-3 mb-3"></i>
                <h4 class="fw-bold">Không tìm thấy chuyến xe phù hợp!</h4>
                <p class="text-muted mb-4">Vui lòng thử chọn lại ngày đi khác hoặc đổi điểm đi / điểm đến.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-outline-primary px-4 me-2">
                        <i class="bi bi-arrow-repeat me-1"></i>Xem tất cả chuyến xe
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4">
                        <i class="bi bi-house me-1"></i>Về Trang Chủ
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<style>
    .hover-shadow:hover {
        transform: translateY(-2px);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.12) !important;
    }
    .transition {
        transition: all 0.2s ease-in-out;
    }
</style>

<%@ include file="/WEB-INF/common/footer.jsp" %>