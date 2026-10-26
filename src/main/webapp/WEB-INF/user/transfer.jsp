
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@include file="/WEB-INF/common/header.jsp"%>

<div class="container py-5">

    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h2 class="fw-bold mb-1">
                <i class="bi bi-arrow-left-right text-primary me-2"></i>
                Transfer Trips
            </h2>
            <p class="text-muted mb-0">
                Available connecting bus trips
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/home"
           class="btn btn-outline-primary">
            <i class="bi bi-arrow-left me-1"></i>
            Back to Home
        </a>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-3 text-center">
                <div class="col-md-3">
                    <div class="text-muted small">Departure ID</div>
                    <div class="fw-bold">${fromId}</div>
                </div>

                <div class="col-md-3">
                    <div class="text-muted small">Destination ID</div>
                    <div class="fw-bold">${toId}</div>
                </div>

                <div class="col-md-3">
                    <div class="text-muted small">Departure Date</div>
                    <div class="fw-bold">${selectedDate}</div>
                </div>

                <div class="col-md-3">
                    <div class="text-muted small">Passengers</div>
                    <div class="fw-bold">${guests}</div>
                </div>
            </div>
        </div>
    </div>

    <c:choose>

        <c:when test="${not empty transferOptions}">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold mb-0">
                    Available Transfers
                </h4>

                <span class="badge bg-primary">
                    ${transferOptions.size()} options
                </span>
            </div>

            <c:forEach var="option" items="${transferOptions}">

                <div class="card shadow-sm mb-4">
                    <div class="card-body p-4">

                        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0">
                                <i class="bi bi-bus-front text-primary me-2"></i>
                                Connecting Journey
                            </h5>

                            <span class="badge bg-info text-dark">
                                2 Trips
                            </span>
                        </div>

                        <div class="row g-3">

                            <div class="col-md-5">
                                <div class="border rounded p-3 h-100">

                                    <span class="badge bg-primary mb-3">
                                        First Trip
                                    </span>

                                    <h5 class="fw-bold">
                                        Trip #${option.firstTrip.id}
                                    </h5>

                                    <p class="mb-2">
                                        <i class="bi bi-clock me-1"></i>
                                        Departure:
                                        <strong>
                                            <fmt:formatDate
                                                value="${option.firstTrip.departureTime}"
                                                pattern="dd/MM/yyyy HH:mm"/>
                                        </strong>
                                    </p>

                                    <p class="mb-2">
                                        Arrival:
                                        <strong>
                                            <fmt:formatDate
                                                value="${option.firstTrip.arrivalTime}"
                                                pattern="dd/MM/yyyy HH:mm"/>
                                        </strong>
                                    </p>

                                    <p class="mb-2">
                                        Available Seats:
                                        <span class="badge bg-success">
                                            ${option.firstTrip.availableSeats}
                                        </span>
                                    </p>

                                    <p class="mb-0">
                                        Price:
                                        <strong class="text-danger">
                                            <fmt:formatNumber
                                                value="${option.firstTrip.price}"
                                                pattern="#,##0"/> VND
                                        </strong>
                                    </p>

                                </div>
                            </div>

                            <div class="col-md-2 d-flex align-items-center justify-content-center">
                                <div class="text-center">
                                    <i class="bi bi-arrow-left-right text-primary fs-3"></i>

                                    <div class="small fw-bold mt-2">
                                        Transfer
                                    </div>

                                    <div class="small text-muted">
                                        Location #${option.transferLocationId}
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-5">
                                <div class="border rounded p-3 h-100">

                                    <span class="badge bg-success mb-3">
                                        Second Trip
                                    </span>

                                    <h5 class="fw-bold">
                                        Trip #${option.secondTrip.id}
                                    </h5>

                                    <p class="mb-2">
                                        <i class="bi bi-clock me-1"></i>
                                        Departure:
                                        <strong>
                                            <fmt:formatDate
                                                value="${option.secondTrip.departureTime}"
                                                pattern="dd/MM/yyyy HH:mm"/>
                                        </strong>
                                    </p>

                                    <p class="mb-2">
                                        Arrival:
                                        <strong>
                                            <fmt:formatDate
                                                value="${option.secondTrip.arrivalTime}"
                                                pattern="dd/MM/yyyy HH:mm"/>
                                        </strong>
                                    </p>

                                    <p class="mb-2">
                                        Available Seats:
                                        <span class="badge bg-success">
                                            ${option.secondTrip.availableSeats}
                                        </span>
                                    </p>

                                    <p class="mb-0">
                                        Price:
                                        <strong class="text-danger">
                                            <fmt:formatNumber
                                                value="${option.secondTrip.price}"
                                                pattern="#,##0"/> VND
                                        </strong>
                                    </p>

                                </div>
                            </div>

                        </div>

                        <hr>

                        <div class="row align-items-center g-3">
                            <div class="col-md-6">
                                <div class="text-muted small">
                                    Total Price / Passenger
                                </div>

                                <h4 class="fw-bold text-danger mb-1">
                                    <fmt:formatNumber
                                        value="${option.firstTrip.price + option.secondTrip.price}"
                                        pattern="#,##0"/> VND
                                </h4>

                                <div class="text-muted small">
                                    Total for ${guests} passengers:
                                    <strong>
                                        <fmt:formatNumber
                                            value="${(option.firstTrip.price + option.secondTrip.price) * guests}"
                                            pattern="#,##0"/> VND
                                    </strong>
                                </div>
                            </div>

                            <div class="col-md-6 text-md-end">
                                <span class="badge bg-light text-dark border p-2">
                                    Transfer waiting time: 15–75 minutes
                                </span>
                            </div>
                        </div>

                    </div>
                </div>

            </c:forEach>

        </c:when>

        <c:otherwise>

            <div class="card shadow-sm border-0">
                <div class="card-body text-center py-5">

                    <i class="bi bi-calendar-x display-3 text-warning"></i>

                    <h4 class="fw-bold mt-3">
                        No Transfer Trips Found
                    </h4>

                    <p class="text-muted">
                        No connecting trips match your selected
                        route, date and passenger count.
                    </p>

                    <a href="${pageContext.request.contextPath}/home"
                       class="btn btn-primary">
                        Search Again
                    </a>

                </div>
            </div>

        </c:otherwise>

    </c:choose>

</div>

<%@include file="/WEB-INF/common/footer.jsp"%>
