<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ include file="/WEB-INF/common/header.jsp"%>

<div class="container py-4">

    <!-- TIÊU ĐỀ TRANG TỔNG QUAN -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <h3 class="fw-bold text-dark mb-1">
                <i class="bi bi-speedometer2 text-primary me-2"></i>Bảng Điều Khiển Quản Trị
            </h3>
            <p class="text-secondary small mb-0">Giám sát hoạt động vận hành, chuyến xe, vé đặt và doanh thu thời gian thực</p>
        </div>

        <div class="d-flex align-items-center gap-2">
            <span class="badge bg-white text-secondary border px-3 py-2 rounded-pill small">
                <i class="bi bi-clock-history me-1 text-primary"></i> Hôm nay: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy" />
            </span>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm px-3 rounded-pill" title="Làm mới dữ liệu">
                <i class="bi bi-arrow-clockwise me-1"></i> Làm mới
            </a>
        </div>
    </div>

    <!-- 3 THẺ SỐ LIỆU CHÍNH (BOOTSTRAP 5 CARDS) -->
    <div class="row g-3 mb-4">

        <!-- THẺ 1: TỔNG CHUYẾN XE -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="text-uppercase text-secondary small fw-semibold mb-1">Tổng số chuyến xe</div>
                        <div class="fs-2 fw-bold text-dark">${totalTrips}</div>
                        <small class="text-muted d-block mt-1">Lịch trình đang được quản lý</small>
                    </div>
                    <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-3 p-3 fs-4">
                        <i class="bi bi-bus-front-fill"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- THẺ 2: VÉ ĐÃ THANH TOÁN -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="text-uppercase text-secondary small fw-semibold mb-1">Vé đã thanh toán</div>
                        <div class="fs-2 fw-bold text-primary">${totalTickets}</div>
                        <small class="text-muted d-block mt-1">Giao dịch thành công</small>
                    </div>
                    <div class="d-inline-flex align-items-center justify-content-center bg-info-subtle text-info rounded-3 p-3 fs-4">
                        <i class="bi bi-ticket-perforated-fill"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- THẺ 3: DOANH THU HÔM NAY -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <div class="text-uppercase text-secondary small fw-semibold mb-1">Doanh thu hôm nay</div>
                        <div class="fs-2 fw-bold text-success">
                            <fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/> <small class="fs-6 fw-bold">VNĐ</small>
                        </div>
                        <small class="text-muted d-block mt-1">Tính theo ngày hiện tại</small>
                    </div>
                    <div class="d-inline-flex align-items-center justify-content-center bg-success-subtle text-success rounded-3 p-3 fs-4">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- KHU VỰC ĐIỀU HÀNH HỆ THỐNG -->
    <div class="row g-4">

        <!-- CỘT TRÁI: 6 CHỨC NĂNG QUẢN LÝ -->
        <div class="col-lg-8">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-dark mb-0">Danh Mục Quản Lý Dữ Liệu</h5>
                <span class="text-muted small">6 phân hệ quản trị</span>
            </div>

            <div class="row g-3">

                <!-- 1. Quản lý chuyến xe -->
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/admin/trip" class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100 text-decoration-none text-dark">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-3 mb-3" style="width: 44px; height: 44px;">
                            <i class="bi bi-calendar-check-fill fs-5"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-2">Quản lý Chuyến xe</h6>
                        <p class="text-secondary small mb-3 flex-grow-1">Cấu hình lịch trình khởi hành, giờ đến, điều chỉnh giá vé và xem danh sách khách theo chuyến.</p>
                        <div class="small fw-semibold text-primary">
                            Truy cập chuyến xe <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <!-- 2. Quản lý tuyến đường -->
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/admin/route" class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100 text-decoration-none text-dark">
                        <div class="d-inline-flex align-items-center justify-content-center bg-success-subtle text-success rounded-3 mb-3" style="width: 44px; height: 44px;">
                            <i class="bi bi-signpost-split-fill fs-5"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-2">Quản lý Tuyến đường</h6>
                        <p class="text-secondary small mb-3 flex-grow-1">Quản lý các cung đường nối tỉnh, khoảng cách số km và thời gian di chuyển ước tính.</p>
                        <div class="small fw-semibold text-success">
                            Truy cập tuyến đường <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <!-- 3. Quản lý xe khách -->
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/admin/vehicle" class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100 text-decoration-none text-dark">
                        <div class="d-inline-flex align-items-center justify-content-center bg-warning-subtle text-warning rounded-3 mb-3" style="width: 44px; height: 44px;">
                            <i class="bi bi-truck-front-fill fs-5"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-2">Quản lý Xe khách</h6>
                        <p class="text-secondary small mb-3 flex-grow-1">Theo dõi biển số xe, loại phương tiện (Giường nằm, Limousine VIP, Ghế ngồi) và số chỗ.</p>
                        <div class="small fw-semibold text-warning">
                            Truy cập đội xe <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <!-- 4. Quản lý địa điểm -->
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/admin/location" class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100 text-decoration-none text-dark">
                        <div class="d-inline-flex align-items-center justify-content-center bg-danger-subtle text-danger rounded-3 mb-3" style="width: 44px; height: 44px;">
                            <i class="bi bi-geo-alt-fill fs-5"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-2">Quản lý Địa điểm</h6>
                        <p class="text-secondary small mb-3 flex-grow-1">Cập nhật danh sách các Tỉnh / Thành phố điểm đi và điểm đến phục vụ tuyến xe.</p>
                        <div class="small fw-semibold text-danger">
                            Truy cập địa điểm <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <!-- 5. Quản lý khách hàng -->
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/admin/customer" class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100 text-decoration-none text-dark">
                        <div class="d-inline-flex align-items-center justify-content-center bg-info-subtle text-info rounded-3 mb-3" style="width: 44px; height: 44px;">
                            <i class="bi bi-people-fill fs-5"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-2">Quản lý Khách hàng</h6>
                        <p class="text-secondary small mb-3 flex-grow-1">Tìm kiếm thông tin hành khách theo tên hoặc số điện thoại, quản lý CCCD và email.</p>
                        <div class="small fw-semibold text-info">
                            Truy cập khách hàng <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

                <!-- 6. Báo cáo doanh thu -->
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/admin/report" class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100 text-decoration-none text-dark">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-3 mb-3" style="width: 44px; height: 44px;">
                            <i class="bi bi-bar-chart-line-fill fs-5"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-2">Báo cáo Doanh thu</h6>
                        <p class="text-secondary small mb-3 flex-grow-1">Thống kê doanh số bán vé đã thanh toán theo từng tuyến xe theo Tháng, Quý hoặc Năm.</p>
                        <div class="small fw-semibold text-primary">
                            Xem báo cáo <i class="bi bi-arrow-right ms-1"></i>
                        </div>
                    </a>
                </div>

            </div>
        </div>

        <!-- CỘT PHẢI: THÔNG TIN HỆ THỐNG & PHÍM TẮT -->
        <div class="col-lg-4">
            <h5 class="fw-bold text-dark mb-3">Vận Hành Hệ Thống</h5>

            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-3">
                <h6 class="fw-bold text-dark mb-3">
                    <i class="bi bi-shield-check text-success me-2"></i>Trạng Thái Kỹ Thuật
                </h6>
                <div class="d-flex justify-content-between align-items-center py-2 border-bottom small">
                    <span class="text-muted">Máy chủ ứng dụng:</span>
                    <span class="badge bg-success-subtle text-success border border-success-subtle">Jakarta EE 10</span>
                </div>
                <div class="d-flex justify-content-between align-items-center py-2 border-bottom small">
                    <span class="text-muted">Cơ sở dữ liệu:</span>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">SQL Server</span>
                </div>
                <div class="d-flex justify-content-between align-items-center py-2 border-bottom small">
                    <span class="text-muted">Kết nối CSDL:</span>
                    <span class="text-success fw-bold"><i class="bi bi-circle-fill me-1 small"></i>Đang hoạt động</span>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-2 small">
                    <span class="text-muted">Tài khoản quản trị:</span>
                    <strong class="text-dark"><c:out value="${sessionScope.currentUser.username}"/></strong>
                </div>
            </div>

            <!-- PHÍM TẮT THAO TÁC NHANH -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <h6 class="fw-bold text-dark mb-3">
                    <i class="bi bi-lightning-charge-fill text-warning me-2"></i>Thao Tác Thêm Nhanh
                </h6>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/admin/trip?action=add" class="btn btn-outline-primary btn-sm text-start py-2">
                        <i class="bi bi-plus-circle me-2"></i> Thêm chuyến xe mới
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/route?action=add" class="btn btn-outline-success btn-sm text-start py-2">
                        <i class="bi bi-plus-circle me-2"></i> Thêm tuyến đường mới
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/vehicle?action=add" class="btn btn-outline-warning btn-sm text-start py-2 text-dark">
                        <i class="bi bi-plus-circle me-2"></i> Thêm phương tiện mới
                    </a>
                </div>
            </div>
        </div>

    </div>

</div>

<%@include file="/WEB-INF/common/footer.jsp"%>
