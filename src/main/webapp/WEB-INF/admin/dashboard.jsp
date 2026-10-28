
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@include file="/WEB-INF/common/header.jsp"%>

<div class="container py-5">

    <div class="mb-4">
        <h1 class="fw-bold">
            <i class="bi bi-speedometer2 text-primary me-2"></i>
            Dashboard
        </h1>

        <p class="text-muted">
            Overview of the Bus Ticket Booking Management System
        </p>
    </div>

    <div class="row g-4 mb-5">

        <div class="col-md-4">
            <div class="card bg-primary text-white border-0 shadow-sm h-100">
                <div class="card-body p-4">

                    <i class="bi bi-bus-front-fill fs-1"></i>

                    <h2 class="fw-bold mt-3">
                        ${totalTrips}
                    </h2>

                    <p class="mb-0">Total Trips</p>

                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card bg-info text-dark border-0 shadow-sm h-100">
                <div class="card-body p-4">

                    <i class="bi bi-ticket-perforated-fill fs-1"></i>

                    <h2 class="fw-bold mt-3">
                        ${totalTickets}
                    </h2>

                    <p class="mb-0">Total Booked Tickets</p>

                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card bg-success text-white border-0 shadow-sm h-100">
                <div class="card-body p-4">

                    <i class="bi bi-cash-stack fs-1"></i>

                    <h2 class="fw-bold mt-3">
                        <fmt:formatNumber value="${todayRevenue}"
                                          pattern="#,##0"/> VND
                    </h2>

                    <p class="mb-0">Today's Revenue (VND)</p>

                </div>
            </div>
        </div>

    </div>

    <h3 class="fw-bold mb-4">Quick Management</h3>


    <div class="row g-3">

        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-bus-front text-primary me-2"></i>
                        Trip Management
                    </h5>

                    <p class="text-muted">
                        Monitor and manage bus trips.
                    </p>

                    <a href="${pageContext.request.contextPath}/admin/trip"
                       class="btn btn-outline-primary">
                        Manage Trips
                    </a>

                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-people text-primary me-2"></i>
                        Customer Management
                    </h5>

                    <p class="text-muted">
                        Manage customer information.
                    </p>

                    <a href="${pageContext.request.contextPath}/customer"
                       class="btn btn-outline-primary">
                        Manage Customers
                    </a>

                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-truck-front text-primary me-2"></i>
                        Vehicle Management
                    </h5>

                    <p class="text-muted">
                        Manage vehicles and their information.
                    </p>

                    <a href="${pageContext.request.contextPath}/vehicle"
                       class="btn btn-outline-primary">
                        Manage Vehicles
                    </a>

                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-geo-alt text-primary me-2"></i>
                        Location Management
                    </h5>

                    <p class="text-muted">
                        Manage provinces and cities.
                    </p>

                    <a href="${pageContext.request.contextPath}/admin/location"
                       class="btn btn-outline-primary">
                        Manage Locations
                    </a>

                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-signpost-split text-primary me-2"></i>
                        Route Management
                    </h5>

                    <p class="text-muted">
                        Manage bus routes and distances.
                    </p>

                    <a href="${pageContext.request.contextPath}/admin/route"
                       class="btn btn-outline-primary">
                        Manage Routes
                    </a>

                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-bar-chart-line text-primary me-2"></i>
                        Revenue Report
                    </h5>

                    <p class="text-muted">
                        View ticket sales and revenue reports.
                    </p>

                    <a href="${pageContext.request.contextPath}/admin/report"
                       class="btn btn-outline-primary">
                        View Reports
                    </a>

                </div>
            </div>
        </div>
    </div>


</div>

<%@include file="/WEB-INF/common/footer.jsp"%>
