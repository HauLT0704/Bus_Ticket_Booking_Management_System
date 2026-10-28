
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
                border-radius: 10px;
                padding: 10px 16px !important;
                transition: background-color 0.25s ease,
                    transform 0.25s ease;
            }

            .navbar .nav-link:hover {
                background-color: rgba(255, 255, 255, 0.18);
                transform: translateY(-2px);
            }

            .navbar .nav-link:focus-visible {
                outline: 2px solid white;
                outline-offset: 2px;
            }

            .navbar .nav-link.active {
                background-color: rgba(255, 255, 255, 0.25);
                font-weight: 600;
            }

            @media (prefers-reduced-motion: reduce) {
                .navbar .nav-link {
                    transition: none;
                }

                .navbar .nav-link:hover {
                    transform: none;
                }
                .navbar .nav-link.active {
                    background-color: rgba(255, 255, 255, 0.25);
                    font-weight: 600;
                }
            }
        </style>
    </head>

    <body class="bg-light">

        <nav class="navbar navbar-expand-lg navbar-dark bg-primary py-3 shadow-sm">
            <div class="container-fluid px-4">

                <a class="navbar-brand fw-bold fs-3 d-flex align-items-center gap-2"
                   href="${pageContext.request.contextPath}/home">
                    <i class="bi bi-bus-front-fill fs-2"></i>
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


                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4 gap-lg-3">

                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/home"
                               class="nav-link text-white fs-5
                               ${pageContext.request.requestURI.endsWith('/home') && param.mode != 'transfer' ? 'active' : ''}">
                                <i class="bi bi-house-door me-1"></i>
                                Home
                            </a>
                        </li>

                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/search"
                               class="nav-link text-white fs-5
                               ${pageContext.request.requestURI.endsWith('/search') ? 'active' : ''}">
                                <i class="bi bi-search me-1"></i>
                                Search Tickets
                            </a>
                        </li>

                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/home?mode=transfer"
                               class="nav-link text-white fs-5
                               ${(pageContext.request.requestURI.endsWith('/home') && param.mode == 'transfer')
                                 || pageContext.request.requestURI.endsWith('/transfer') ? 'active' : ''}">
                                <i class="bi bi-arrow-left-right me-1"></i>
                                Transfer Trips
                            </a>
                        </li>

                    </ul>

                    <div class="d-flex flex-wrap align-items-center gap-3">

                        <c:if test="${not empty sessionScope.currentUser}">

                            <span class="badge bg-white text-primary fs-6 px-3 py-2 rounded-pill">

                                <i class="bi bi-person-circle me-2"></i>

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
                               class="btn btn-outline-light fw-bold">

                                <i class="bi bi-box-arrow-right me-1"></i>
                                Logout

                            </a>

                        </c:if>

                        <c:if test="${empty sessionScope.currentUser}">

                            <a href="${pageContext.request.contextPath}/login"
                               class="btn btn-light text-primary fw-bold">

                                <i class="bi bi-box-arrow-in-right me-1"></i>
                                Login

                            </a>

                        </c:if>

                    </div>

                </div>
            </div>
        </nav>
