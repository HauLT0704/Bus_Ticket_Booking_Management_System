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
                            <c:choose>
                                <c:when test="${not empty locationList}">
                                    <c:forEach items="${locationList}" var="loc">
                                        <option value="${loc.name}" ${selectedFrom == loc.name ? 'selected' : ''}>${loc.name}</option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="TP. Hồ Chí Minh" ${selectedFrom == 'TP. Hồ Chí Minh' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                                    <option value="Cần Thơ" ${selectedFrom == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                                    <option value="Kiên Giang" ${selectedFrom == 'Kiên Giang' ? 'selected' : ''}>Kiên Giang</option>
                                    <option value="An Giang" ${selectedFrom == 'An Giang' ? 'selected' : ''}>An Giang</option>
                                    <option value="Cà Mau" ${selectedFrom == 'Cà Mau' ? 'selected' : ''}>Cà Mau</option>
                                    <option value="Bạc Liêu" ${selectedFrom == 'Bạc Liêu' ? 'selected' : ''}>Bạc Liêu</option>
                                    <option value="Sóc Trăng" ${selectedFrom == 'Sóc Trăng' ? 'selected' : ''}>Sóc Trăng</option>
                                    <option value="Đồng Tháp" ${selectedFrom == 'Đồng Tháp' ? 'selected' : ''}>Đồng Tháp</option>
                                    <option value="Bến Tre" ${selectedFrom == 'Bến Tre' ? 'selected' : ''}>Bến Tre</option>
                                    <option value="Vĩnh Long" ${selectedFrom == 'Vĩnh Long' ? 'selected' : ''}>Vĩnh Long</option>
                                    <option value="Tiền Giang" ${selectedFrom == 'Tiền Giang' ? 'selected' : ''}>Tiền Giang</option>
                                    <option value="Trà Vinh" ${selectedFrom == 'Trà Vinh' ? 'selected' : ''}>Trà Vinh</option>
                                    <option value="Hậu Giang" ${selectedFrom == 'Hậu Giang' ? 'selected' : ''}>Hậu Giang</option>
                                    <option value="Long An" ${selectedFrom == 'Long An' ? 'selected' : ''}>Long An</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>

                    <!-- Điểm đến -->
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted mb-1">
                            <i class="bi bi-flag-fill text-success me-1"></i>Điểm đến
                        </label>
                        <select name="to" class="form-select form-select-sm">
                            <option value="">-- Tất cả điểm đến --</option>
                            <c:choose>
                                <c:when test="${not empty locationList}">
                                    <c:forEach items="${locationList}" var="loc">
                                        <option value="${loc.name}" ${selectedTo == loc.name ? 'selected' : ''}>${loc.name}</option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="TP. Hồ Chí Minh" ${selectedTo == 'TP. Hồ Chí Minh' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                                    <option value="Cần Thơ" ${selectedTo == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                                    <option value="Kiên Giang" ${selectedTo == 'Kiên Giang' ? 'selected' : ''}>Kiên Giang</option>
                                    <option value="An Giang" ${selectedTo == 'An Giang' ? 'selected' : ''}>An Giang</option>
                                    <option value="Cà Mau" ${selectedTo == 'Cà Mau' ? 'selected' : ''}>Cà Mau</option>
                                    <option value="Bạc Liêu" ${selectedTo == 'Bạc Liêu' ? 'selected' : ''}>Bạc Liêu</option>
                                    <option value="Sóc Trăng" ${selectedTo == 'Sóc Trăng' ? 'selected' : ''}>Sóc Trăng</option>
                                    <option value="Đồng Tháp" ${selectedTo == 'Đồng Tháp' ? 'selected' : ''}>Đồng Tháp</option>
                                    <option value="Bến Tre" ${selectedTo == 'Bến Tre' ? 'selected' : ''}>Bến Tre</option>
                                    <option value="Vĩnh Long" ${selectedTo == 'Vĩnh Long' ? 'selected' : ''}>Vĩnh Long</option>
                                    <option value="Tiền Giang" ${selectedTo == 'Tiền Giang' ? 'selected' : ''}>Tiền Giang</option>
                                    <option value="Trà Vinh" ${selectedTo == 'Trà Vinh' ? 'selected' : ''}>Trà Vinh</option>
                                    <option value="Hậu Giang" ${selectedTo == 'Hậu Giang' ? 'selected' : ''}>Hậu Giang</option>
                                    <option value="Long An" ${selectedTo == 'Long An' ? 'selected' : ''}>Long An</option>
                                </c:otherwise>
                            </c:choose>
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
            <c:choose>
                <c:when test="${not empty transferTrips}">
                    <!-- GỢI Ý GHÉP CHUYẾN (TV4 TÍCH HỢP) NẾU CÓ CHUYẾN TRUNG GIAN -->
                    <div class="alert alert-info border-0 rounded-4 shadow-sm p-4 mb-4" style="background-color: #e8f4fd;">
                        <div class="d-flex align-items-center gap-3">
                            <i class="bi bi-shuffle fs-1 text-primary"></i>
                            <div>
                                <h5 class="fw-bold mb-1 text-primary">Không có chuyến đi thẳng - Gợi Ý Ghép Chuyến Phù Hợp</h5>
                                <p class="mb-0 text-muted">Chúng tôi đã tìm thấy các phương án nối chuyến trung gian (2 chặng) cho hành trình của bạn.</p>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex flex-column gap-3 mb-4">
                        <c:forEach items="${transferTrips}" var="tr">
                            <div class="card shadow-sm border-0 rounded-3 p-3 bg-white hover-shadow transition">
                                <div class="row align-items-center">
                                    <div class="col-md-9">
                                        <!-- Chặng 1 -->
                                        <div class="d-flex align-items-center gap-3 mb-2 p-2 bg-light rounded-3">
                                            <span class="badge bg-primary px-2 py-1">Chặng 1</span>
                                            <div class="fw-bold text-dark">
                                                <fmt:formatDate value="${tr.trip1Dep}" pattern="HH:mm" /> 
                                                <span class="text-primary fw-bold">${tr.fromName}</span>
                                                <i class="bi bi-arrow-right mx-1 text-secondary"></i>
                                                <fmt:formatDate value="${tr.trip1Arr}" pattern="HH:mm" />
                                                <span class="text-success fw-bold">${tr.midName} (Trung chuyển)</span>
                                            </div>
                                            <span class="badge bg-secondary-subtle text-dark small ms-auto">
                                                ${tr.trip1Type} (${tr.trip1Plate})
                                            </span>
                                            <a href="${pageContext.request.contextPath}/booking/seats?tripId=${tr.trip1Id}" class="btn btn-outline-primary btn-sm fw-semibold">
                                                <i class="bi bi-ticket-perforated me-1"></i>Chọn Chặng 1
                                            </a>
                                        </div>

                                        <!-- Chặng 2 -->
                                        <div class="d-flex align-items-center gap-3 p-2 bg-light rounded-3">
                                            <span class="badge bg-success px-2 py-1">Chặng 2</span>
                                            <div class="fw-bold text-dark">
                                                <fmt:formatDate value="${tr.trip2Dep}" pattern="HH:mm" /> 
                                                <span class="text-success fw-bold">${tr.midName}</span>
                                                <i class="bi bi-arrow-right mx-1 text-secondary"></i>
                                                <fmt:formatDate value="${tr.trip2Arr}" pattern="HH:mm" />
                                                <span class="text-danger fw-bold">${tr.toName} (Đích đến)</span>
                                            </div>
                                            <span class="badge bg-secondary-subtle text-dark small ms-auto">
                                                ${tr.trip2Type} (${tr.trip2Plate})
                                            </span>
                                            <a href="${pageContext.request.contextPath}/booking/seats?tripId=${tr.trip2Id}" class="btn btn-outline-success btn-sm fw-semibold">
                                                <i class="bi bi-ticket-perforated me-1"></i>Chọn Chặng 2
                                            </a>
                                        </div>
                                    </div>

                                    <div class="col-md-3 text-center border-start">
                                        <div class="text-muted small">Tổng giá vé ước tính</div>
                                        <div class="text-danger fw-bold fs-4">
                                            <fmt:formatNumber value="${tr.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </div>
                                        <span class="badge bg-warning-subtle text-dark mt-1">Hành trình 2 chặng</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- Khi hoàn toàn không có chuyến nào -->
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
                        <i class="bi bi-calendar-x text-warning display-3 mb-3"></i>
                        <h4 class="fw-bold">Không tìm thấy chuyến xe phù hợp!</h4>
                        <p class="text-muted mb-4">Vui lòng thử chọn lại ngày đi khác hoặc đổi điểm đi / điểm đến.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-outline-primary px-4 me-2">
                                <i class="bi bi-arrow-repeat me-1"></i>Xem tất cả chuyến xe
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
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