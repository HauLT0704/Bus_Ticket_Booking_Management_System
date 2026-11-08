<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%@include file="/WEB-INF/common/header.jsp" %>

<div class="container py-4 py-lg-5">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">

        <div>
            <h2 class="fw-bold text-primary mb-2">
                <i class="bi bi-bar-chart-line-fill me-2"></i>
                Báo cáo doanh thu
            </h2>

            <p class="text-secondary mb-0">
                Thống kê doanh thu vé đã thanh toán theo từng tuyến xe.
            </p>
        </div>

        <button type="button"
                class="btn btn-success d-print-none"
                onclick="window.print()">
            <i class="bi bi-printer-fill me-2"></i>
            In báo cáo
        </button>
    </div>

    <!-- Thông báo lỗi -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <c:out value="${error}"/>
        </div>
    </c:if>

    <!-- Bộ lọc báo cáo -->
    <div class="card border-0 shadow-sm rounded-4 mb-4 d-print-none">
        <div class="card-body p-4">

            <h5 class="fw-bold mb-4">
                <i class="bi bi-funnel-fill text-primary me-2"></i>
                Điều kiện báo cáo
            </h5>

            <form action="${pageContext.request.contextPath}/report"
                  method="post">

                <div class="row g-3 align-items-end">

                    <!-- Loại báo cáo -->
                    <div class="col-12 col-md-6 col-lg-3">
                        <label for="type" class="form-label fw-semibold mb-2">
                            Loại báo cáo
                        </label>

                        <select class="form-select" id="type" name="type"
                                onchange="toggleFields()">

                            <option value="month" <c:if test="${reportType eq 'month'}">selected</c:if>>
                                Theo tháng
                            </option>

                            <option value="quarter" <c:if test="${reportType eq 'quarter'}">selected</c:if>>
                                Theo quý
                            </option>

                            <option value="year" <c:if test="${reportType eq 'year'}">selected</c:if>>
                                Theo năm
                            </option>
                        </select>
                    </div>

                    <!-- Tháng -->
                    <div class="col-12 col-md-6 col-lg-2" id="monthGroup">
                        <label for="month" class="form-label fw-semibold mb-2">
                            Tháng
                        </label>

                        <select class="form-select" id="month" name="month">
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}" <c:if test="${month == m}">selected</c:if>>
                                    Tháng ${m}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Quý -->
                    <div class="col-12 col-md-6 col-lg-2" id="quarterGroup">
                        <label for="quarter" class="form-label fw-semibold mb-2">
                            Quý
                        </label>

                        <select class="form-select" id="quarter"
                                name="quarter">

                            <c:forEach var="q" begin="1" end="4">
                                <option value="${q}" <c:if test="${quarter == q}">selected</c:if>>
                                    Quý ${q}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Năm -->
                    <div class="col-12 col-md-6 col-lg-2">
                        <label for="year" class="form-label fw-semibold mb-2">
                            Năm
                        </label>

                        <input type="number"
                               class="form-control"
                               id="year"
                               name="year"
                               min="1"
                               max="9999"
                               value="${year}"
                               required>
                    </div>

                    <!-- Nút lọc -->
                    <div class="col-12 col-lg-3">
                        <button type="submit"
                                class="btn btn-primary w-100">
                            <i class="bi bi-search me-2"></i>
                            Xem báo cáo
                        </button>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <!-- Bảng doanh thu -->
    <div class="card border-0 shadow-sm rounded-4">
        <div class="card-body p-3 p-lg-4">

            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">

                <div class="d-flex align-items-center gap-3">
                    <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-3 p-3 fs-4">
                        <i class="bi bi-cash-stack"></i>
                    </div>

                    <div>
                        <h5 class="fw-bold mb-1">Chi tiết doanh thu</h5>

                        <div class="text-secondary small">
                            <c:choose>
                                <c:when test="${reportType eq 'month'}">
                                    Tháng ${month}/${year}
                                </c:when>

                                <c:when test="${reportType eq 'quarter'}">
                                    Quý ${quarter}/${year}
                                </c:when>

                                <c:otherwise>
                                    Năm ${year}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <span class="badge bg-primary-subtle text-primary fs-6">
                    <c:choose>
                        <c:when test="${not empty revenueList}">
                            ${revenueList.size()} tuyến
                        </c:when>
                        <c:otherwise>
                            0 tuyến
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th class="py-3" style="width: 70px;">STT</th>
                            <th class="py-3">Tuyến xe</th>
                            <th class="py-3 text-end">Số vé thanh toán</th>
                            <th class="py-3 text-end">Doanh thu</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${not empty revenueList}">
                                <c:forEach var="item"
                                           items="${revenueList}"
                                           varStatus="status">

                                    <tr>
                                        <td class="py-3">
                                            ${status.index + 1}
                                        </td>

                                        <td class="py-3">
                                            <div class="fw-semibold">
                                                <c:out value="${item.fromLocation}"/>
                                                <i class="bi bi-arrow-right mx-2 text-primary"></i>
                                                <c:out value="${item.toLocation}"/>
                                            </div>
                                        </td>

                                        <td class="py-3 text-end">
                                            <span class="badge bg-info-subtle text-info-emphasis">
                                                <fmt:formatNumber
                                                    value="${item.totalTickets}"
                                                    pattern="#,##0"/>
                                            </span>
                                        </td>

                                        <td class="py-3 text-end text-success fw-bold text-nowrap">
                                            <fmt:formatNumber
                                                value="${item.revenue}"
                                                pattern="#,##0"/> đ
                                        </td>
                                    </tr>

                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="text-center py-5">
                                        <i class="bi bi-inbox display-5 text-secondary"></i>

                                        <p class="text-secondary mt-3 mb-0">
                                            Không có dữ liệu doanh thu trong kỳ này.
                                        </p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="text-secondary small mt-3">
                <i class="bi bi-info-circle me-1"></i>
                Doanh thu chỉ tính các vé có trạng thái đã thanh toán.
            </div>

        </div>
    </div>

</div>

<script>
    function toggleFields() {
        var type = document.getElementById("type").value;

        if (type === "month") {
            document.getElementById("monthGroup").style.display = "";
        } else {
            document.getElementById("monthGroup").style.display = "none";
        }

        if (type === "quarter") {
            document.getElementById("quarterGroup").style.display = "";
        } else {
            document.getElementById("quarterGroup").style.display = "none";
        }
    }

    document.addEventListener("DOMContentLoaded", toggleFields);
</script>

<%@include file="/WEB-INF/common/footer.jsp" %>
