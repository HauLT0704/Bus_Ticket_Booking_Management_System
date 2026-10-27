
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%@include file="/WEB-INF/common/header.jsp" %>

<style>
    .report-title {
        color: #17365d;
    }

    .report-card {
        border: none;
        border-radius: 14px;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.06);
    }

    .report-icon {
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 12px;
        background: #e7f1ff;
        color: #0d6efd;
        font-size: 24px;
    }

    .table thead th {
        background: #17365d;
        color: white;
        white-space: nowrap;
        padding: 14px;
    }

    .table tbody td {
        padding: 14px;
        vertical-align: middle;
    }

    .revenue-value {
        color: #198754;
        font-weight: 700;
        white-space: nowrap;
    }

    .filter-label {
        font-weight: 600;
        margin-bottom: 8px;
    }

    @media print {
        .no-print,
        nav,
        footer {
            display: none !important;
        }

        body {
            background: white !important;
        }

        .report-card {
            box-shadow: none;
            border: 1px solid #ddd;
        }

        .container {
            max-width: 100% !important;
        }

        .table thead th {
            background: #ddd !important;
            color: black !important;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }
    }
</style>

<div class="container py-4 py-lg-5">

    <!-- Tieu de trang -->
    <div class="d-flex flex-wrap justify-content-between
                align-items-center gap-3 mb-4">

        <div>
            <h2 class="fw-bold report-title mb-2">
                <i class="bi bi-bar-chart-line-fill me-2"></i>
                Báo cáo doanh thu
            </h2>

            <p class="text-secondary mb-0">
                Thống kê doanh thu vé đã thanh toán theo từng tuyến xe.
            </p>
        </div>

        <button type="button"
                class="btn btn-success no-print"
                onclick="window.print()">
            <i class="bi bi-printer-fill me-2"></i>
            In báo cáo
        </button>
    </div>

    <!-- Thong bao loi -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <c:out value="${error}"/>
        </div>
    </c:if>

    <!-- Bo loc bao cao -->
    <div class="card report-card mb-4 no-print">
        <div class="card-body p-4">

            <h5 class="fw-bold mb-4">
                <i class="bi bi-funnel-fill text-primary me-2"></i>
                Điều kiện báo cáo
            </h5>

            <form action="${pageContext.request.contextPath}/report"
                  method="post">

                <div class="row g-3 align-items-end">

                    <!-- Loai bao cao -->
                    <div class="col-12 col-md-6 col-lg-3">
                        <label for="type" class="form-label filter-label">
                            Loại báo cáo
                        </label>

                        <select class="form-select" id="type" name="type"
                                onchange="toggleFields()">

                            <option value="month"
                                ${reportType eq 'month' ? 'selected' : ''}>
                                Theo tháng
                            </option>

                            <option value="quarter"
                                ${reportType eq 'quarter' ? 'selected' : ''}>
                                Theo quý
                            </option>

                            <option value="year"
                                ${reportType eq 'year' ? 'selected' : ''}>
                                Theo năm
                            </option>
                        </select>
                    </div>

                    <!-- Thang -->
                    <div class="col-12 col-md-6 col-lg-2" id="monthGroup">
                        <label for="month" class="form-label filter-label">
                            Tháng
                        </label>

                        <select class="form-select" id="month" name="month">
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}"
                                    ${month == m ? 'selected' : ''}>
                                    Tháng ${m}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Quy -->
                    <div class="col-12 col-md-6 col-lg-2" id="quarterGroup">
                        <label for="quarter" class="form-label filter-label">
                            Quý
                        </label>

                        <select class="form-select" id="quarter"
                                name="quarter">

                            <c:forEach var="q" begin="1" end="4">
                                <option value="${q}"
                                    ${quarter == q ? 'selected' : ''}>
                                    Quý ${q}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Nam -->
                    <div class="col-12 col-md-6 col-lg-2">
                        <label for="year" class="form-label filter-label">
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

                    <!-- Nut loc -->
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

    <!-- Bang doanh thu -->
    <div class="card report-card">
        <div class="card-body p-3 p-lg-4">

            <div class="d-flex flex-wrap justify-content-between
                        align-items-center gap-3 mb-4">

                <div class="d-flex align-items-center gap-3">
                    <div class="report-icon">
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
                    <thead>
                        <tr>
                            <th style="width: 70px;">STT</th>
                            <th>Tuyến xe</th>
                            <th class="text-end">Số vé thanh toán</th>
                            <th class="text-end">Doanh thu</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${not empty revenueList}">
                                <c:forEach var="item"
                                           items="${revenueList}"
                                           varStatus="status">

                                    <tr>
                                        <td>
                                            ${status.index + 1}
                                        </td>

                                        <td>
                                            <div class="fw-semibold">
                                                <c:out value="${item.fromLocation}"/>
                                                <i class="bi bi-arrow-right mx-2
                                                          text-primary"></i>
                                                <c:out value="${item.toLocation}"/>
                                            </div>
                                        </td>

                                        <td class="text-end">
                                            <span class="badge bg-info-subtle
                                                         text-info-emphasis">
                                                <fmt:formatNumber
                                                    value="${item.totalTickets}"
                                                    pattern="#,##0"/>
                                            </span>
                                        </td>

                                        <td class="text-end revenue-value">
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
                                        <i class="bi bi-inbox display-5
                                                  text-secondary"></i>

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

        document.getElementById("monthGroup").style.display =
            type === "month" ? "" : "none";

        document.getElementById("quarterGroup").style.display =
            type === "quarter" ? "" : "none";
    }

    document.addEventListener("DOMContentLoaded", toggleFields);
</script>

<%@include file="/WEB-INF/common/footer.jsp" %>
