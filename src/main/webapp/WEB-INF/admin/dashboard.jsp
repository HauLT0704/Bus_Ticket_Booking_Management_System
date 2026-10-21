
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/common/header.jsp"%>

<div class="container py-5">

    <div class="mb-4">
        <h1 class="fw-bold">
            <i class="bi bi-speedometer2 text-primary me-2"></i>
            Dashboard
        </h1>
        <p class="text-muted">
            Tổng quan hệ thống quản lý đặt vé xe khách
        </p>
    </div>

    <div class="row g-4 mb-5">

        <!-- Tổng chuyến xe -->
        <div class="col-md-4">
            <div class="card bg-primary text-white border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <i class="bi bi-bus-front-fill fs-1"></i>
                    <h2 class="fw-bold mt-3">${totalTrips}</h2>
                    <p class="mb-0">Tổng số chuyến xe</p>
                </div>
            </div>
        </div>

        <!-- Tổng số vé -->
        <div class="col-md-4">
            <div class="card bg-info text-dark border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <i class="bi bi-ticket-perforated-fill fs-1"></i>
                    <h2 class="fw-bold mt-3">${totalTickets}</h2>
                    <p class="mb-0">Tổng số vé đã đặt</p>
                </div>
            </div>
        </div>

        <!-- Doanh thu -->
        <div class="col-md-4">
            <div class="card bg-success text-white border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <i class="bi bi-cash-stack fs-1"></i>
                    <h2 class="fw-bold mt-3">${todayRevenue}</h2>
                    <p class="mb-0">Doanh thu hôm nay (VNĐ)</p>
                </div>
            </div>
        </div>

    </div>

    <h3 class="fw-bold mb-4">Quản lý nhanh</h3>

    <div class="row g-3">

        <div class="col-md-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">
                    <h5>
                        <i class="bi bi-bus-front text-primary me-2"></i>
                        Quản lý chuyến xe
                    </h5>
                    <p class="text-muted mb-0">
                        Theo dõi và quản lý các chuyến xe.
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">
                    <h5>
                        <i class="bi bi-people text-primary me-2"></i>
                        Quản lý khách hàng
                    </h5>
                    <p class="text-muted mb-0">
                        Quản lý thông tin khách hàng.
                    </p>
                </div>
            </div>
        </div>

    </div>
</div>

<%@include file="/WEB-INF/common/footer.jsp"%>
