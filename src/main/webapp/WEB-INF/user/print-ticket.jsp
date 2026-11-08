<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@include file="/WEB-INF/common/header.jsp" %>

<div class="container py-4">
    <div class="card border-2 border-primary rounded-4 p-4 mx-auto my-3 bg-white shadow-sm" style="max-width: 750px;">
        <div class="text-center mb-4">
            <h3 class="text-primary fw-bold">
                <i class="bi bi-bus-front"></i>
                VÉ XE KHÁCH
            </h3>
            <p class="text-muted mb-0">BUS TICKET BOOKING</p>
        </div>

        <hr>

        <c:choose>
            <c:when test="${not empty ticket}">
                <div class="row g-3">
                    <div class="col-6">
                        <strong>Mã vé:</strong>
                        <p>${ticket.id}</p>
                    </div>

                    <div class="col-6">
                        <strong>Hành khách:</strong>
                        <p><c:out value="${ticket.customerName}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Số điện thoại:</strong>
                        <p><c:out value="${ticket.phone}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Số ghế:</strong>
                        <p><c:out value="${ticket.seatNumber}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Điểm đi:</strong>
                        <p><c:out value="${ticket.fromLocation}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Điểm đến:</strong>
                        <p><c:out value="${ticket.toLocation}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Giờ khởi hành:</strong>
                        <p><c:out value="${ticket.departureTime}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Biển số xe:</strong>
                        <p><c:out value="${ticket.licensePlate}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Ngày đặt vé:</strong>
                        <p><c:out value="${ticket.bookingTime}"/></p>
                    </div>

                    <div class="col-6">
                        <strong>Trạng thái:</strong>
                        <p><c:out value="${ticket.status}"/></p>
                    </div>

                    <div class="col-12">
                        <strong>Tổng tiền:</strong>
                        <fmt:setLocale value="de_DE" />

                        <h4 class="text-danger fw-bold">
                            <fmt:formatNumber
                                value="${ticket.totalPrice}"
                                pattern="#,##0"
                                groupingUsed="true" /> VNĐ
                        </h4>
                    </div>
                </div>

                <hr>

                <p class="text-center text-muted mb-0">
                    Vui lòng có mặt trước giờ khởi hành.
                    Chúc quý khách thượng lộ bình an!
                </p>
            </c:when>

            <c:otherwise>
                <div class="alert alert-warning">
                    Không tìm thấy thông tin vé.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="text-center d-print-none mt-3">
        <button class="btn btn-primary"
                onclick="window.print()">
            <i class="bi bi-printer"></i> In vé
        </button>

        <button class="btn btn-secondary"
                onclick="history.back()">
            Quay lại
        </button>
    </div>
</div>

<%@include file="/WEB-INF/common/footer.jsp" %>
