<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
    Component Phân trang dùng chung cho tất cả các bảng danh sách
    Phân công: Hứa Hạo Danh (TV5)
    Tham số truyền vào:
    - pagination: đối tượng PaginationUtil
    - baseUrl: đường dẫn gốc (ví dụ: "customer?" hoặc "admin/trip?")
--%>
<c:if test="${not empty pagination and pagination.totalPages > 1}">
    <div class="d-flex flex-wrap justify-content-between align-items-center mt-3 pt-3 border-top">
        <div class="text-muted small mb-2 mb-md-0">
            Hiển thị <b>${pagination.startIndex + 1}</b> - <b>${pagination.endIndex}</b> 
            trên tổng số <b>${pagination.totalRecords}</b> bản ghi
        </div>
        <nav aria-label="Page navigation">
            <ul class="pagination pagination-sm mb-0">
                <%-- Nút Trang trước --%>
                <li class="page-item <c:if test='${!pagination.hasPrevious}'>disabled</c:if>">
                    <a class="page-link" href="${baseUrl}&page=${pagination.currentPage - 1}" aria-label="Previous">
                        <i class="bi bi-chevron-left"></i> Trước
                    </a>
                </li>

                <%-- Các số trang --%>
                <c:forEach var="p" begin="1" end="${pagination.totalPages}">
                    <li class="page-item <c:if test='${p == pagination.currentPage}'>active</c:if>">
                        <a class="page-link" href="${baseUrl}&page=${p}">${p}</a>
                    </li>
                </c:forEach>

                <%-- Nút Trang kế tiếp --%>
                <li class="page-item <c:if test='${!pagination.hasNext}'>disabled</c:if>">
                    <a class="page-link" href="${baseUrl}&page=${pagination.currentPage + 1}" aria-label="Next">
                        Sau <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</c:if>
