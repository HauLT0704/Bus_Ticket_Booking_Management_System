
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bus Ticket Booking</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary py-3 shadow-sm">
    <div class="container-fluid px-4">

        <!-- Logo -->
        <a class="navbar-brand fw-bold fs-3 d-flex align-items-center gap-2"
           href="<%=request.getContextPath()%>/home">
            <i class="bi bi-bus-front-fill fs-2"></i>
            BUS BOOKING
        </a>

        <!-- Nút menu trên điện thoại -->
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarMenu"
                aria-controls="navbarMenu"
                aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMenu">

            <!-- Menu chính -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4 gap-lg-3">

                <li class="nav-item">
                    <a class="nav-link text-white fs-5"
                       href="<%=request.getContextPath()%>/home">
                        Trang chủ
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link text-white fs-5"
                       href="<%=request.getContextPath()%>/search">
                        Tìm vé
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link text-white fs-5" href="#">
                        Lịch trình
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link text-white fs-5" href="#">
                        Liên hệ
                    </a>
                </li>
            </ul>

            <!-- Tài khoản -->
            <span class="badge bg-white text-primary fs-6 px-3 py-2 rounded-pill">
                <i class="bi bi-person-circle me-2"></i>
                Hello admin
            </span>

        </div>
    </div>
</nav>
