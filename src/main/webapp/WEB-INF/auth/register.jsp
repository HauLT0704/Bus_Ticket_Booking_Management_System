<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký Tài Khoản - Vé Xe Miền Tây</title>

        <!-- Bootstrap 5.3 & Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    </head>
    <body class="d-flex align-items-center justify-content-center min-vh-100 p-3"
          style="background: linear-gradient(135deg, rgba(15, 23, 42, 0.78) 0%, rgba(13, 110, 253, 0.65) 100%), url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat fixed;">

        <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white w-100" style="max-width: 480px;">

            <div class="text-center mb-4">
                <div class="d-inline-flex align-items-center justify-content-center bg-primary text-white rounded-3 mb-3 shadow-sm" style="width: 48px; height: 48px;">
                    <i class="bi bi-bus-front-fill fs-4"></i>
                </div>
                <h3 class="fw-bold text-dark mb-1">Tạo Tài Khoản</h3>
                <p class="text-secondary small mb-0">Đăng ký để đặt vé nhanh chóng và tiện lợi</p>
            </div>

            <!-- THÔNG BÁO LỖI -->
            <% if (request.getAttribute("errorMessage") != null) {%>
            <div class="alert alert-danger py-2 px-3 small border-0 rounded-3 mb-3 d-flex align-items-center">
                <i class="bi bi-exclamation-circle-fill me-2 fs-6"></i>
                <span><%= request.getAttribute("errorMessage")%></span>
            </div>
            <% }%>

            <!-- FORM NHẬP LIỆU -->
            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-secondary">Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" name="username" class="form-control py-2 rounded-3" placeholder="Ví dụ: nguyenvana" required autofocus>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-secondary">Họ và tên <span class="text-danger">*</span></label>
                    <input type="text" name="fullName" class="form-control py-2 rounded-3" placeholder="Ví dụ: Nguyễn Văn A" required> 
                </div>

                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-secondary">Số điện thoại <span class="text-danger">*</span></label>
                        <input type="tel" name="phone" class="form-control py-2 rounded-3" placeholder="0901234567" required> 
                    </div>
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-secondary">Email</label>
                        <input type="email" name="email" class="form-control py-2 rounded-3" placeholder="a@gmail.com"> 
                    </div>
                </div>

                <div class="row g-2 mb-4">
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-secondary">Mật khẩu <span class="text-danger">*</span></label>
                        <input type="password" name="password" class="form-control py-2 rounded-3" placeholder="Tối thiểu 6 ký tự" required> 
                    </div>
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-secondary">Xác nhận MK <span class="text-danger">*</span></label>
                        <input type="password" name="confirmPassword" class="form-control py-2 rounded-3" placeholder="Nhập lại MK" required> 
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold rounded-3 shadow-sm">
                    Đăng Ký Tài Khoản
                </button>
            </form>

            <div class="text-center mt-4 pt-3 border-top small text-secondary">
                Đã có tài khoản? 
                <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary text-decoration-none ms-1">
                    Đăng nhập
                </a>
                <div class="mt-2">
                    <a href="${pageContext.request.contextPath}/home" class="text-muted text-decoration-none">
                        <i class="bi bi-arrow-left me-1"></i>Về trang chủ
                    </a>
                </div>
            </div>

        </div>

    </body>
</html>
