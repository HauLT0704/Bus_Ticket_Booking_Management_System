
<%@page pageEncoding="UTF-8"%>

<footer class="bg-primary text-white mt-5 py-5 shadow-sm">
    <div class="container">
        <div class="row align-items-center text-center text-md-start gy-4">

            <div class="col-md-5">
                <h4 class="fw-bold mb-3">
                    <i class="bi bi-bus-front-fill me-2"></i>
                    BUS BOOKING
                </h4>

                <p class="mb-0 text-white-50">
                    A fast, convenient, and secure online
                    bus ticket booking platform.
                </p>
            </div>

            <div class="col-md-4">
                <h5 class="fw-bold mb-3">Quick Links</h5>

                <div class="d-flex flex-column gap-2">
                    <a href="${pageContext.request.contextPath}/home"
                       class="text-white text-decoration-none">
                        <i class="bi bi-house-door me-2"></i>
                        Home
                    </a>

                    <a href="${pageContext.request.contextPath}/search"
                       class="text-white text-decoration-none">
                        <i class="bi bi-search me-2"></i>
                        Search Tickets
                    </a>

                    <a href="${pageContext.request.contextPath}/home?mode=transfer"
                       class="text-white text-decoration-none">
                        <i class="bi bi-arrow-left-right me-2"></i>
                        Transfer Trips
                    </a>
                </div>
            </div>

            <div class="col-md-3">
                <h5 class="fw-bold mb-3">About Us</h5>

                <p class="mb-2">
                    <i class="bi bi-geo-alt-fill me-2"></i>
                    Vietnam
                </p>

                <p class="mb-0">
                    <i class="bi bi-ticket-perforated-fill me-2"></i>
                    Online Ticket Booking
                </p>
            </div>

        </div>

        <hr class="border-white opacity-50 my-4">

        <div class="text-center">
            <p class="mb-0 small text-white-50">
                &copy; 2026 Bus Ticket Booking System
                | Bus Ticket Booking Team
            </p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
