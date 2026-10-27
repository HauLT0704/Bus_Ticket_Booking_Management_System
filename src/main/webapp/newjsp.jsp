
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/common/header.jsp"%>

<div class="container py-5">

    <!-- BEGIN: DASHBOARD HEADER -->
    <div class="mb-4">
        <h1 class="fw-bold">
            <i class="bi bi-speedometer2 text-primary me-2"></i>
            Dashboard
        </h1>

        <p class="text-muted">
            Overview of the Bus Ticket Booking Management System
        </p>
    </div>
    <!-- END: DASHBOARD HEADER -->


    <!-- =====================================================
         BEGIN: DASHBOARD STATISTICS

         TODO DATABASE (TV6):
         Connect DashboardController to the database.

         Required attributes:
         - totalTrips
         - totalTickets
         - todayRevenue

         TODO:
         Retrieve total trips from Trips.
         Retrieve total booked tickets from Tickets.
         Calculate today's revenue from paid tickets.

         NOTE:
         Do not use hardcoded statistics.
    ====================================================== -->

    <div class="row g-4 mb-5">

        <!-- BEGIN: TOTAL TRIPS -->
        <div class="col-md-4">
            <div class="card bg-primary text-white border-0 shadow-sm h-100">
                <div class="card-body p-4">

                    <i class="bi bi-bus-front-fill fs-1"></i>

                    <h2 class="fw-bold mt-3">
                        ${empty totalTrips ? '—' : totalTrips}
                    </h2>

                    <p class="mb-0">Total Trips</p>
                </div>
            </div>
        </div>
        <!-- END: TOTAL TRIPS -->


        <!-- BEGIN: TOTAL TICKETS -->
        <div class="col-md-4">
            <div class="card bg-info text-dark border-0 shadow-sm h-100">
                <div class="card-body p-4">

                    <i class="bi bi-ticket-perforated-fill fs-1"></i>

                    <h2 class="fw-bold mt-3">
                        ${empty totalTickets ? '—' : totalTickets}
                    </h2>

                    <p class="mb-0">Total Booked Tickets</p>
                </div>
            </div>
        </div>
        <!-- END: TOTAL TICKETS -->


        <!-- BEGIN: TODAY REVENUE -->
        <div class="col-md-4">
            <div class="card bg-success text-white border-0 shadow-sm h-100">
                <div class="card-body p-4">

                    <i class="bi bi-cash-stack fs-1"></i>

                    <h2 class="fw-bold mt-3">
                        ${empty todayRevenue ? '—' : todayRevenue}
                    </h2>

                    <p class="mb-0">Today's Revenue (VND)</p>
                </div>
            </div>
        </div>
        <!-- END: TODAY REVENUE -->

    </div>

    <!-- END: DASHBOARD STATISTICS -->


    <!-- =====================================================
         BEGIN: QUICK MANAGEMENT

         TODO INTEGRATION (TV2):
         Connect Trip Management to TripController.

         TODO INTEGRATION (TV3):
         Connect Customer Management to CustomerController.

         NOTE:
         Keep these cards unchanged until the
         corresponding modules are ready.
    ====================================================== -->

    <h3 class="fw-bold mb-4">Quick Management</h3>

    <div class="row g-3">

        <!-- BEGIN: TRIP MANAGEMENT -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-bus-front text-primary me-2"></i>
                        Trip Management
                    </h5>

                    <p class="text-muted mb-0">
                        Monitor and manage bus trips.
                    </p>

                </div>
            </div>
        </div>
        <!-- END: TRIP MANAGEMENT -->


        <!-- BEGIN: CUSTOMER MANAGEMENT -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">

                    <h5>
                        <i class="bi bi-people text-primary me-2"></i>
                        Customer Management
                    </h5>

                    <p class="text-muted mb-0">
                        Manage customer information.
                    </p>

                </div>
            </div>
        </div>
        <!-- END: CUSTOMER MANAGEMENT -->

    </div>

    <!-- END: QUICK MANAGEMENT -->

</div>

<%@include file="/WEB-INF/common/footer.jsp"%>
