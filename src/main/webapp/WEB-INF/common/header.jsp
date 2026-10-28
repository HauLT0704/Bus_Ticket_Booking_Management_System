
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Bus Ticket Booking</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        .navbar .nav-link {
            border-radius: 8px;
            padding: 8px 12px !important;
            transition: background-color 0.25s ease;
        }

        .navbar .nav-link:hover,
        .navbar .nav-link.active {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .navbar .nav-link:focus-visible {
            outline: 2px solid white;
            outline-offset: 2px;
        }

        .navbar .dropdown-item {
            padding: 10px 15px;
        }

        .navbar .dropdown-item:hover,
        .navbar .dropdown-item.active {
            background-color: #e7f1ff;
            color: #0d6efd;
        }

        @media (prefers-reduced-motion: reduce) {
            .navbar .nav-link {
                transition: none;
            }
        }
    </style>
</head>

<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary py-2 shadow-sm">

    <div class="container-fluid px-4">

        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center gap-2"
           href="${pageContext.request.contextPath}/home">

            <i class="bi bi-bus-front-fill fs-3"></i>
            BUS BOOKING

        </a>

        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarMenu"
                aria-controls="navbarMenu"
                aria-expanded="false"
                aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>

        </button>

        <div class="collapse navbar-collapse" id="navbarMenu">

            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 gap-lg-1">

                <c:choose>

                    <c:when test="${not empty sessionScope.currentUser and sessionScope.currentUser.admin}">

                        <li class="nav-item">

                            <a class="nav-link text-white
                               ${pageContext.request.requestURI.endsWith('/dashboard') ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/admin/dashboard">

                                <i class="bi bi-speedometer2 me-1"></i>
                                Dashboard

                            </a>

                        </li>

                        <li class="nav-item dropdown">

                            <a class="nav-link dropdown-toggle text-white"
                               href="#"
                               role="button"
                               data-bs-toggle="dropdown"
                               aria-expanded="false">

                                <i class="bi bi-grid me-1"></i>
                                Management

                            </a>

                            <ul class="dropdown-menu shadow">

                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/admin/trip">

                                        <i class="bi bi-bus-front me-2"></i>
                                        Trip Management

                                    </a>
                                </li>

                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/customer">

                                        <i class="bi bi-people me-2"></i>
                                        Customer Management

                                    </a>
                                </li>

                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/vehicle">

                                        <i class="bi bi-truck-front me-2"></i>
                                        Vehicle Management

                                    </a>
                                </li>

                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/admin/location">

                                        <i class="bi bi-geo-alt me-2"></i>
                                        Location Management

                                    </a>
                                </li>

                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/admin/route">

                                        <i class="bi bi-signpost-split me-2"></i>
                                        Route Management

                                    </a>
                                </li>

                                <li>
                                    <hr class="dropdown-divider">
                                </li>

                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/admin/report">

                                        <i class="bi bi-bar-chart-line me-2"></i>
                                        Revenue Report

                                    </a>
                                </li>

                            </ul>

                        </li>

                    </c:when>

                    <c:otherwise>

                        <li class="nav-item">

                            <a class="nav-link text-white
                               ${pageContext.request.requestURI.endsWith('/home') and param.mode != 'transfer' ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/home">

                                <i class="bi bi-house-door me-1"></i>
                                Home

                            </a>

                        </li>

                        <li class="nav-item">

                            <a class="nav-link text-white
                               ${pageContext.request.requestURI.endsWith('/search') ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/search">

                                <i class="bi bi-search me-1"></i>
                                Search Tickets

                            </a>

                        </li>

                        <li class="nav-item">

                            <a class="nav-link text-white
                               ${(pageContext.request.requestURI.endsWith('/home') and param.mode == 'transfer') or pageContext.request.requestURI.endsWith('/transfer') ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/home?mode=transfer">

                                <i class="bi bi-arrow-left-right me-1"></i>
                                Transfer Trips

                            </a>

                        </li>

                    </c:otherwise>

                </c:choose>

            </ul>

            <div class="d-flex align-items-center gap-2">

                <c:choose>

                    <c:when test="${not empty sessionScope.currentUser}">

                        <span class="badge bg-white text-primary px-3 py-2 rounded-pill">

                            <i class="bi bi-person-circle me-1"></i>
                            Hello

                            <c:choose>

                                <c:when test="${not empty sessionScope.currentUser.fullName}">
                                    <c:out value="${sessionScope.currentUser.fullName}"/>
                                </c:when>

                                <c:otherwise>
                                    <c:out value="${sessionScope.currentUser.username}"/>
                                </c:otherwise>

                            </c:choose>

                        </span>

                        <a href="${pageContext.request.contextPath}/logout"
                           class="btn btn-outline-light btn-sm fw-bold">

                            <i class="bi bi-box-arrow-right me-1"></i>
                            Logout

                        </a>

                    </c:when>

                    <c:otherwise>

                        <a href="${pageContext.request.contextPath}/login"
                           class="btn btn-light btn-sm text-primary fw-bold">

                            <i class="bi bi-box-arrow-in-right me-1"></i>
                            Login

                        </a>

                    </c:otherwise>

                </c:choose>

            </div>

        </div>

    </div>

</nav>
