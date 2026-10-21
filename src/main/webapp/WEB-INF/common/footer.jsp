
<%@page pageEncoding="UTF-8"%>
<footer class="bg-primary text-white mt-5 py-5">
    <div class="container">
        <div class="row align-items-center text-center text-md-start gy-4">

            <!-- Thông tin hệ thống -->
            <div class="col-md-5">
                <h4 class="fw-bold mb-3">
                    <i class="bi bi-bus-front-fill me-2"></i>
                    BUS BOOKING
                </h4>
                <p class="mb-0">
                    Nền tảng đặt vé xe khách nhanh chóng,
                    tiện lợi và an toàn.
                </p>
            </div>

            <!-- Liên kết -->
            <div class="col-md-4">
                <h5 class="fw-bold mb-3">Liên kết nhanh</h5>

                <div class="d-flex flex-column gap-2">
                    <a href="<%=request.getContextPath()%>/home"
                       class="text-white text-decoration-none">
                        Trang chủ
                    </a>

                    <a href="<%=request.getContextPath()%>/search"
                       class="text-white text-decoration-none">
                        Tìm chuyến xe
                    </a>
                </div>
            </div>

            <!-- Giới thiệu -->
            <div class="col-md-3">
                <h5 class="fw-bold mb-3">Về chúng tôi</h5>
                <p class="mb-2">
                    <i class="bi bi-geo-alt-fill me-2"></i>
                    Việt Nam
                </p>
                <p class="mb-0">
                    <i class="bi bi-ticket-perforated-fill me-2"></i>
                    Đặt vé trực tuyến
                </p>
            </div>

        </div>

        <hr class="border-white opacity-50 my-4">

        <!-- Copyright -->
        <div class="text-center">
            <p class="mb-0 small">
                &copy; 2026 Bus Ticket Booking System
                | Nhóm Bus Ticket Booking
            </p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
