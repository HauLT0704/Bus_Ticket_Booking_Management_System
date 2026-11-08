<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/common/header.jsp" %>

<!-- HERO BANNER (CÓ HÌNH NỀN XE KHÁCH) & FORM TÌM VÉ TRUNG TÂM -->
<div class="position-relative overflow-hidden py-5"
     style="background: linear-gradient(135deg, rgba(13, 110, 253, 0.84) 0%, rgba(15, 23, 42, 0.88) 100%),
            url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat; color: white;">
    <div class="container py-3">
        <div class="row align-items-center mb-4">
            <div class="col-lg-8 mx-auto text-center">
                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3 shadow-sm">
                    <i class="bi bi-stars me-1"></i> Dịch Vụ Xe Khách Miền Tây Chất Lượng Cao
                </span>
                <h1 class="display-6 fw-bold mb-3">Đặt Vé Xe Khách Nhanh Chóng & Dễ Dàng</h1>
                <p class="lead text-white-50 mb-0">
                    Chuyên tuyến Sài Gòn & các tỉnh Miền Tây. Chọn chỗ ngồi trực quan, giữ chỗ tức thì.
                </p>
            </div>
        </div>

        <!-- FORM TÌM CHUYẾN XE (GỌI SANG SEARCH.JSP) -->
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card border-0 shadow-lg rounded-4 p-4 p-md-4 text-dark bg-white">

                    <!-- CHỌN CHẾ ĐỘ: ĐI THẲNG HOẶC GHÉP CHUYẾN -->
                    <div class="d-flex align-items-center gap-4 mb-3 border-bottom pb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="searchMode" id="modeDirect" value="direct" 
                                   <c:if test="${param.mode != 'transfer'}">checked</c:if> onchange="updateMode()">
                            <label class="form-check-label fw-bold text-primary" for="modeDirect">
                                <i class="bi bi-arrow-right me-1"></i> Chuyến Đi Thẳng
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="searchMode" id="modeTransfer" value="transfer" 
                                   <c:if test="${param.mode == 'transfer'}">checked</c:if> onchange="updateMode()">
                            <label class="form-check-label fw-bold text-success" for="modeTransfer">
                                <i class="bi bi-arrow-left-right me-1"></i> Gợi Ý Ghép Chuyến (Nối Chuyến)
                            </label>
                        </div>
                    </div>

                    <!-- FORM TÌM KIẾM -->
                    <form id="homeSearchForm" action="${pageContext.request.contextPath}/search" method="GET">
                        <div class="row g-3 align-items-end">

                            <!-- ĐIỂM ĐI -->
                            <div class="col-md-3">
                                <label for="fromSelect" class="form-label small fw-bold text-secondary mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-1"></i>Điểm khởi hành
                                </label>
                                <select id="fromSelect" name="from" class="form-select py-2" required>
                                    <option value="">-- Chọn điểm đi --</option>
                                    <c:forEach var="loc" items="${locations}">
                                        <option value="${loc.name}">${loc.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- ĐIỂM ĐẾN & NÚT HOÁN ĐỔI -->
                            <div class="col-md-4">
                                <label for="toSelect" class="form-label small fw-bold text-secondary mb-1">
                                    <i class="bi bi-flag-fill text-success me-1"></i>Điểm đến
                                </label>
                                <div class="input-group">
                                    <select id="toSelect" name="to" class="form-select py-2" required>
                                        <option value="">-- Chọn điểm đến --</option>
                                        <c:forEach var="loc" items="${locations}">
                                            <option value="${loc.name}">${loc.name}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="button" class="btn btn-outline-secondary px-3" onclick="swapLocations()" title="Đổi chiều điểm đi / điểm đến">
                                        <i class="bi bi-arrow-left-right text-primary"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- NGÀY ĐI -->
                            <div class="col-md-3">
                                <label for="dateInput" class="form-label small fw-bold text-secondary mb-1">
                                    <i class="bi bi-calendar-event me-1"></i>Ngày đi
                                </label>
                                <input type="date" id="dateInput" name="date" class="form-control py-2" 
                                       min="${today}" value="${today}" required>
                            </div>

                            <!-- SỐ LƯỢNG VÉ -->
                            <div class="col-md-2">
                                <label for="guestsInput" class="form-label small fw-bold text-secondary mb-1">
                                    <i class="bi bi-people me-1"></i>Số khách
                                </label>
                                <input type="number" id="guestsInput" name="guests" class="form-control py-2" 
                                       min="1" max="10" value="1" required>
                            </div>

                            <!-- NÚT TÌM VÉ -->
                            <div class="col-12 mt-3 text-center">
                                <button type="submit" class="btn btn-warning btn-lg fw-bold px-5 py-2 text-dark shadow-sm">
                                    <i class="bi bi-search me-2"></i>Tìm Chuyến Xe Phù Hợp
                                </button>
                            </div>

                        </div>
                    </form>

                </div>
            </div>
        </div>

    </div>
</div>

<!-- CÁC TÍNH NĂNG TIỆN ÍCH -->
<div class="container py-5 my-3">
    <div class="text-center mb-5">
        <h3 class="fw-bold text-dark mb-2">Vì Sao Nên Chọn Vé Xe Miền Tây?</h3>
        <p class="text-muted">Trải nghiệm đặt vé tiện lợi, dịch vụ an toàn và luôn hỗ trợ bạn 24/7</p>
    </div>

    <div class="row g-4 text-center">
        <!-- TIỆN ÍCH 1 -->
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-circle mb-3 mx-auto" style="width: 64px; height: 64px;">
                    <i class="bi bi-grid-3x3-gap-fill fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">Chọn Chỗ Trực Quan</h5>
                <p class="text-muted small mb-0">
                    Sơ đồ ghế hiển thị trực quan theo thời gian thực. Bạn được tự do chọn vị trí tầng trên hay tầng dưới mình yêu thích.
                </p>
            </div>
        </div>

        <!-- TIỆN ÍCH 2 -->
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="d-inline-flex align-items-center justify-content-center bg-success-subtle text-success rounded-circle mb-3 mx-auto" style="width: 64px; height: 64px;">
                    <i class="bi bi-tags-fill fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">Giá Vé Minh Bạch</h5>
                <p class="text-muted small mb-0">
                    Giá niêm yết rõ ràng, không phụ phí ẩn. Luôn có mức giá tốt nhất cho các chuyến xe Miền Tây và Sài Gòn.
                </p>
            </div>
        </div>

        <!-- TIỆN ÍCH 3 -->
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="d-inline-flex align-items-center justify-content-center bg-warning-subtle text-dark rounded-circle mb-3 mx-auto" style="width: 64px; height: 64px;">
                    <i class="bi bi-sign-turn-right-fill fs-3 text-warning"></i>
                </div>
                <h5 class="fw-bold mb-2">Thông Minh Ghép Chuyến</h5>
                <p class="text-muted small mb-0">
                    Khi hết chuyến đi thẳng, hệ thống tự động tìm và gợi ý lộ trình nối chuyến hợp lý để bạn không bị lỡ kế hoạch.
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    // Đảo vị trí điểm đi và điểm đến
    function swapLocations() {
        var from = document.getElementById("fromSelect");
        var to = document.getElementById("toSelect");
        var temp = from.value;
        from.value = to.value;
        to.value = temp;
    }

    // Cập nhật chế độ tìm kiếm: Đi thẳng (/search) hoặc Ghép chuyến (/transfer)
    function updateMode() {
        var isTransfer = document.getElementById("modeTransfer").checked;
        var form = document.getElementById("homeSearchForm");
        if (isTransfer) {
            form.action = "${pageContext.request.contextPath}/transfer";
        } else {
            form.action = "${pageContext.request.contextPath}/search";
        }
    }

    document.addEventListener("DOMContentLoaded", updateMode);

    document.getElementById("homeSearchForm").addEventListener("submit", function(e) {
        updateMode();
        var from = document.getElementById("fromSelect").value;
        var to = document.getElementById("toSelect").value;
        if (from && to && from === to) {
            e.preventDefault();
            alert("Điểm đi và điểm đến không được trùng nhau! Vui lòng chọn lại.");
        }
    });
</script>

<%@ include file="/WEB-INF/common/footer.jsp" %>
