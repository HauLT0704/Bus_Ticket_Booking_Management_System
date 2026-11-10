<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vé Xe Miền Tây - Hệ Thống Đặt Vé Trực Tuyến</title>

    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<c:set var="navThemeClass" value="bg-primary" />
<c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
    <c:set var="navThemeClass" value="bg-dark" />
</c:if>

<nav class="navbar navbar-expand-lg navbar-dark ${navThemeClass} shadow-sm py-2 sticky-top d-print-none" style="z-index: 1030;">
    <div class="container-fluid px-lg-4">

        <!-- LOGO THƯƠNG HIỆU -->
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2 text-white text-decoration-none"
           href="${pageContext.request.contextPath}/home">
            <span class="d-inline-flex align-items-center justify-content-center bg-white text-primary rounded-3 p-1" style="width: 32px; height: 32px;">
                <i class="bi bi-bus-front-fill fs-5"></i>
            </span>
            <span>VÉ XE MIỀN TÂY</span>
        </a>

        <!-- NÚT MOBILE TOGGLER -->
        <button class="navbar-toggler border-0"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarMenu"
                aria-controls="navbarMenu"
                aria-expanded="false"
                aria-label="Chuyển đổi menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMenu">

            <!-- DANH MỤC ĐIỀU HƯỚNG -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 gap-lg-1">

                <c:choose>
                    <%-- DÀNH CHO ADMIN QUẢN TRỊ VIÊN --%>
                    <c:when test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">
                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.endsWith("/dashboard")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="bi bi-speedometer2 me-1"></i>
                                Bảng điều khiển
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.contains("/trip")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/trip">
                                <i class="bi bi-calendar-check me-1"></i>
                                Chuyến xe
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.contains("/ticket")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/tickets">
                                <i class="bi bi-ticket-perforated me-1"></i>
                                Quản lý vé
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.contains("/route")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/route">
                                <i class="bi bi-signpost-split me-1"></i>
                                Tuyến đường
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.contains("/vehicle")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/vehicle">
                                <i class="bi bi-truck-front me-1"></i>
                                Xe khách
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.contains("/location")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/location">
                                <i class="bi bi-geo-alt me-1"></i>
                                Địa điểm
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.contains("/customer")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/customer">
                                <i class="bi bi-people me-1"></i>
                                Khách hàng
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.contains("/report")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/admin/report">
                                <i class="bi bi-bar-chart-line me-1"></i>
                                Báo cáo
                            </a>
                        </li>
                    </c:when>

                    <%-- DÀNH CHO HÀNH KHÁCH & USER --%>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.endsWith("/home") and param.mode != "transfer"}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/home">
                                <i class="bi bi-house-door me-1"></i>
                                Trang chủ
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${pageContext.request.requestURI.endsWith("/search")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/search">
                                <i class="bi bi-search me-1"></i>
                                Tìm chuyến xe
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link px-3 rounded-3 <c:if test='${(pageContext.request.requestURI.endsWith("/home") and param.mode == "transfer") or pageContext.request.requestURI.endsWith("/transfer")}'>active fw-semibold bg-white bg-opacity-10</c:if>"
                               href="${pageContext.request.contextPath}/home?mode=transfer">
                                <i class="bi bi-arrow-left-right me-1"></i>
                                Gợi ý ghép chuyến
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>

            </ul>

            <!-- KHỐI ĐĂNG NHẬP / NGƯỜI DÙNG -->
            <div class="d-flex align-items-center gap-2 mt-3 mt-lg-0">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge bg-white bg-opacity-10 text-white border border-light border-opacity-25 rounded-pill px-3 py-2 fw-normal d-flex align-items-center gap-2">
                                <i class="bi bi-person-circle"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.currentUser.fullName}">
                                            <c:out value="${sessionScope.currentUser.fullName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${sessionScope.currentUser.username}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <c:if test="${sessionScope.currentUser.admin}">
                                    <span class="badge bg-warning text-dark ms-1">Quản trị viên</span>
                                </c:if>
                            </span>

                            <a href="${pageContext.request.contextPath}/logout"
                               class="btn btn-outline-light btn-sm px-3" title="Đăng xuất khỏi hệ thống">
                                <i class="bi bi-box-arrow-right me-1"></i>
                                Đăng xuất
                            </a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login"
                           class="btn btn-light btn-sm text-primary fw-semibold px-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i>
                            Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register"
                           class="btn btn-outline-light btn-sm px-3">
                            Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</nav>
