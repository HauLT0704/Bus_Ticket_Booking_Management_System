
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/header.jsp" %>

<div class="container mt-5">

    <h1 class="fw-bold mb-3">Bus Ticket Booking</h1>
    <p class="text-muted">Tìm kiếm và đặt vé xe khách nhanh chóng</p>

    <!-- FORM TIM KIEM -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Tìm chuyến xe</h5>
        </div>

        <div class="card-body">
            <form id="searchForm">
                <div class="row g-3">

                    <div class="col-md-3">
                        <label class="form-label">Điểm đi</label>
                        <select id="from" class="form-select">
                            <option value="">Tất cả</option>
                            <option>Cần Thơ</option>
                            <option>TP.HCM</option>
                            <option>Đà Lạt</option>
                            <option>Nha Trang</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Điểm đến</label>
                        <select id="to" class="form-select">
                            <option value="">Tất cả</option>
                            <option>Cần Thơ</option>
                            <option>TP.HCM</option>
                            <option>Đà Lạt</option>
                            <option>Nha Trang</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Ngày đi</label>
                        <input type="date" id="date" class="form-control">
                    </div>

                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-warning w-100">
                            Tìm chuyến xe
                        </button>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <!-- DANH SACH CHUYEN XE -->
    <h2 class="mb-3">Danh sách chuyến xe</h2>

    <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Điểm đi</th>
                    <th>Điểm đến</th>
                    <th>Ngày đi</th>
                    <th>Giờ đi</th>
                    <th>Giá vé</th>
                    <th>Ghế trống</th>
                    <th>Hành động</th>
                </tr>
            </thead>

            <tbody id="tripTable">
                <tr>
                    <td>1</td>
                    <td>Cần Thơ</td>
                    <td>TP.HCM</td>
                    <td>2026-10-20</td>
                    <td>08:00</td>
                    <td>150.000đ</td>
                    <td>20</td>
                    <td>
                        <button class="btn btn-primary btn-sm"
                                onclick="bookTicket(1)">
                            Đặt vé
                        </button>
                        <button class="btn btn-secondary btn-sm"
                                onclick="viewDetail(1)">
                            Chi tiết
                        </button>
                    </td>
                </tr>

                <tr>
                    <td>2</td>
                    <td>TP.HCM</td>
                    <td>Đà Lạt</td>
                    <td>2026-10-20</td>
                    <td>22:00</td>
                    <td>280.000đ</td>
                    <td>12</td>
                    <td>
                        <button class="btn btn-primary btn-sm"
                                onclick="bookTicket(2)">
                            Đặt vé
                        </button>
                        <button class="btn btn-secondary btn-sm"
                                onclick="viewDetail(2)">
                            Chi tiết
                        </button>
                    </td>
                </tr>

                <tr>
                    <td>3</td>
                    <td>TP.HCM</td>
                    <td>Nha Trang</td>
                    <td>2026-10-21</td>
                    <td>21:30</td>
                    <td>320.000đ</td>
                    <td>5</td>
                    <td>
                        <button class="btn btn-primary btn-sm"
                                onclick="bookTicket(3)">
                            Đặt vé
                        </button>
                        <button class="btn btn-secondary btn-sm"
                                onclick="viewDetail(3)">
                            Chi tiết
                        </button>
                    </td>
                </tr>

                <tr>
                    <td>4</td>
                    <td>Đà Lạt</td>
                    <td>TP.HCM</td>
                    <td>2026-10-21</td>
                    <td>09:00</td>
                    <td>280.000đ</td>
                    <td>0</td>
                    <td>
                        <button class="btn btn-danger btn-sm" disabled>
                            Hết vé
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <p id="resultMessage" class="text-muted"></p>

</div>

<script>
    document.getElementById("searchForm").addEventListener("submit", function(e) {
        e.preventDefault();

        let from = document.getElementById("from").value;
        let to = document.getElementById("to").value;
        let date = document.getElementById("date").value;

        let rows = document.querySelectorAll("#tripTable tr");
        let count = 0;

        rows.forEach(function(row) {
            let cells = row.querySelectorAll("td");

            let matchFrom = !from || cells[1].innerText.trim() === from;
            let matchTo = !to || cells[2].innerText.trim() === to;
            let matchDate = !date || cells[3].innerText.trim() === date;

            if (matchFrom && matchTo && matchDate) {
                row.style.display = "";
                count++;
            } else {
                row.style.display = "none";
            }
        });

        document.getElementById("resultMessage").innerText =
            "Tìm thấy " + count + " chuyến xe.";
    });

    function bookTicket(id) {
        alert("Demo đặt vé cho chuyến xe ID: " + id);
    }

    function viewDetail(id) {
        alert("Demo xem chi tiết chuyến xe ID: " + id);
    }
</script>

<%@include file="/WEB-INF/include/footer.jsp" %>
