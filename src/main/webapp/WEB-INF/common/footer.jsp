<%@page pageEncoding="UTF-8"%>

<footer class="bg-dark text-white mt-5 pt-5 pb-4 border-top d-print-none">
    <div class="container">
        <div class="row g-4 justify-content-between">

            <!-- THƯƠNG HIỆU -->
            <div class="col-lg-4 col-md-6">
                <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                    <span class="d-inline-flex align-items-center justify-content-center bg-primary text-white rounded-3 p-1" style="width: 28px; height: 28px;">
                        <i class="bi bi-bus-front-fill fs-6"></i>
                    </span>
                    <span>VÉ XE MIỀN TÂY</span>
                </h5>
                <p class="text-white-50 mb-3 small" style="line-height: 1.7;">
                    Hệ thống đặt vé xe khách trực tuyến chuyên tuyến Sài Gòn & các tỉnh Đồng Bằng Sông Cửu Long. Cam kết chuyến xe an toàn, đúng giờ và dịch vụ tận tâm.
                </p>
                <div class="d-flex gap-2">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2">
                        <i class="bi bi-shield-check me-1"></i> Đặt vé an toàn
                    </span>
                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">
                        <i class="bi bi-clock-history me-1"></i> Đúng giờ
                    </span>
                </div>
            </div>

            <!-- LIÊN KẾT NHANH -->
            <div class="col-lg-3 col-md-6">
                <h6 class="fw-bold text-uppercase text-light mb-3 small">Liên Kết Nhanh</h6>
                <ul class="list-unstyled d-flex flex-column gap-2 small">
                    <li>
                        <a href="${pageContext.request.contextPath}/home" class="text-white-50 text-decoration-none">
                            <i class="bi bi-chevron-right me-1 text-primary"></i> Trang chủ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/search" class="text-white-50 text-decoration-none">
                            <i class="bi bi-chevron-right me-1 text-primary"></i> Tìm kiếm chuyến xe
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/home?mode=transfer" class="text-white-50 text-decoration-none">
                            <i class="bi bi-chevron-right me-1 text-primary"></i> Gợi ý ghép chuyến
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/login" class="text-white-50 text-decoration-none">
                            <i class="bi bi-chevron-right me-1 text-primary"></i> Đăng nhập hệ thống
                        </a>
                    </li>
                </ul>
            </div>

            <!-- THÔNG TIN HỖ TRỢ -->
            <div class="col-lg-4 col-md-6">
                <h6 class="fw-bold text-uppercase text-light mb-3 small">Hỗ Trợ & Liên Hệ</h6>
                <div class="d-flex flex-column gap-2 small text-white-50">
                    <p class="mb-1">
                        <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                        Bến xe Miền Tây, TP. Hồ Chí Minh & Bến xe Cần Thơ
                    </p>
                    <p class="mb-1">
                        <i class="bi bi-telephone-fill text-success me-2"></i>
                        Hotline đặt vé: <b>1900 6067</b> (24/7)
                    </p>
                    <p class="mb-1">
                        <i class="bi bi-envelope-fill text-warning me-2"></i>
                        Email: support@vexemientay.vn
                    </p>
                </div>
            </div>

        </div>

        <hr class="border-secondary opacity-25 my-4">

        <div class="text-center text-white-50 small">
            <p class="mb-0">
                &copy; 2026 <b>VÉ XE MIỀN TÂY</b> - Hệ Thống Quản Lý & Đặt Vé Xe Khách Trực Tuyến.
            </p>
        </div>
    </div>
</footer>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
