<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - Vé Xe Miền Tây</title>

        <!-- Bootstrap 5.3 & Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    </head>
    <body class="d-flex align-items-center justify-content-center min-vh-100 p-3"
          style="background: linear-gradient(135deg, rgba(15, 23, 42, 0.78) 0%, rgba(13, 110, 253, 0.65) 100%), url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat fixed;">

        <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white w-100" style="max-width: 420px;">

            <div class="text-center mb-4">
                <div class="d-inline-flex align-items-center justify-content-center bg-primary text-white rounded-3 mb-3 shadow-sm" style="width: 48px; height: 48px;">
                    <i class="bi bi-bus-front-fill fs-4"></i>
                </div>
                <h3 class="fw-bold text-dark mb-1">Đăng Nhập</h3>
                <p class="text-secondary small mb-0">Hệ thống đặt vé xe khách trực tuyến</p>
            </div>

            <!-- THÔNG BÁO LỖI / THÀNH CÔNG -->
            <% if (request.getAttribute("errorMessage") != null) {%>
            <div class="alert alert-danger py-2 px-3 small border-0 rounded-3 mb-3 d-flex align-items-center">
                <i class="bi bi-exclamation-circle-fill me-2 fs-6"></i>
                <span><%= request.getAttribute("errorMessage")%></span>
            </div>
            <% } %>

            <% if (request.getAttribute("successMessage") != null) {%>
            <div class="alert alert-success py-2 px-3 small border-0 rounded-3 mb-3 d-flex align-items-center">
                <i class="bi bi-check-circle-fill me-2 fs-6"></i>
                <span><%= request.getAttribute("successMessage")%></span>
            </div>
            <% } %>

            <% if ("logged_out".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info py-2 px-3 small border-0 rounded-3 mb-3 d-flex align-items-center">
                <i class="bi bi-info-circle-fill me-2 fs-6"></i>
                <span>Đã đăng xuất khỏi hệ thống thành công.</span>
            </div>
            <% } %>

            <% if ("locked_violation".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-danger py-2 px-3 small border-0 rounded-3 mb-3 d-flex align-items-center">
                <i class="bi bi-exclamation-circle-fill me-2 fs-6"></i>
                <span>Tài khoản của bạn đã bị khóa do hủy vé từ 3 lần trở lên (vi phạm đặt vé)!</span>
            </div>
            <% }%>

            <!-- FORM NHẬP LIỆU -->
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="mb-3">
                    <label for="username" class="form-label small fw-semibold text-secondary">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" class="form-control py-2 rounded-3" 
                           value="<c:out value='${username}'/>" required autofocus placeholder="Nhập username">
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label small fw-semibold text-secondary">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control py-2 rounded-3" 
                           required placeholder="Nhập mật khẩu">
                </div>

                <div class="form-check mb-4">
                    <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe"
                           <c:if test="${rememberMe}">checked</c:if>>
                           <label class="form-check-label small text-secondary" for="rememberMe">
                               Ghi nhớ tên đăng nhập (Cookies)
                           </label>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold rounded-3 shadow-sm">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Đăng Nhập
                    </button>
                </form>

                <div class="text-center mt-4 pt-3 border-top small text-secondary">
                    Chưa có tài khoản? 
                    <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary text-decoration-none ms-1">
                    Đăng ký ngay
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
