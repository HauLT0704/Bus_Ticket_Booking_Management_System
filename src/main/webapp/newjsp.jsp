
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/common/header.jsp" %>

<div class="container mt-5">

    <h1 class="fw-bold mb-3">Bus Ticket Booking</h1>
    <p class="text-muted">
        Search and book bus tickets quickly and easily
    </p>

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Search Bus Trips</h5>
        </div>

        <div class="card-body">
            <form id="searchForm">

                <div class="d-flex gap-4 mb-3">
                    <div class="form-check">
                        <input class="form-check-input"
                               type="radio"
                               name="searchMode"
                               id="directMode"
                               value="direct"
                               checked>
                        <label class="form-check-label" for="directMode">
                            Direct Trips
                        </label>
                    </div>

                    <div class="form-check">
                        <input class="form-check-input"
                               type="radio"
                               name="searchMode"
                               id="transferMode"
                               value="transfer">
                        <label class="form-check-label" for="transferMode">
                            Transfer Trips (Ghép chuyến)
                        </label>
                    </div>
                </div>

                <div class="row g-3 align-items-end">

                    <div class="col-md-3">
                        <label for="from" class="form-label">
                            Departure
                        </label>

                        <select id="from" class="form-select">
                            <option value="">All</option>
                            <option value="1">TP. Hồ Chí Minh</option>
                            <option value="2">Cần Thơ</option>
                            <option value="3">Kiên Giang</option>
                            <option value="4">An Giang</option>
                            <option value="5">Cà Mau</option>
                            <option value="6">Bạc Liêu</option>
                            <option value="7">Sóc Trăng</option>
                            <option value="8">Đồng Tháp</option>
                            <option value="9">Bến Tre</option>
                            <option value="10">Vĩnh Long</option>
                            <option value="11">Tiền Giang</option>
                            <option value="12">Trà Vinh</option>
                            <option value="13">Hậu Giang</option>
                            <option value="14">Long An</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="to" class="form-label">
                            Destination
                        </label>

                        <div class="input-group">
                            <select id="to" class="form-select">
                                <option value="">All</option>
                                <option value="1">TP. Hồ Chí Minh</option>
                                <option value="2">Cần Thơ</option>
                                <option value="3">Kiên Giang</option>
                                <option value="4">An Giang</option>
                                <option value="5">Cà Mau</option>
                                <option value="6">Bạc Liêu</option>
                                <option value="7">Sóc Trăng</option>
                                <option value="8">Đồng Tháp</option>
                                <option value="9">Bến Tre</option>
                                <option value="10">Vĩnh Long</option>
                                <option value="11">Tiền Giang</option>
                                <option value="12">Trà Vinh</option>
                                <option value="13">Hậu Giang</option>
                                <option value="14">Long An</option>
                            </select>

                            <button type="button"
                                    id="swapButton"
                                    class="btn btn-outline-primary"
                                    title="Swap departure and destination"
                                    aria-label="Swap departure and destination">
                                <i class="bi bi-arrow-left-right"></i>
                            </button>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label for="date" class="form-label">
                            Departure Date
                        </label>

                        <input type="date"
                               id="date"
                               class="form-control">
                    </div>

                    <div class="col-md-3">
                        <div class="d-flex gap-2">
                            <button type="submit"
                                    class="btn btn-warning flex-grow-1">
                                <i class="bi bi-search me-1"></i>
                                Search Trips
                            </button>

                            <button type="button"
                                    id="resetButton"
                                    class="btn btn-outline-secondary"
                                    title="Reset search"
                                    aria-label="Reset search">
                                <i class="bi bi-arrow-clockwise"></i>
                            </button>
                        </div>
                    </div>

                </div>

                <div id="searchError"
                     class="alert alert-danger mt-3 mb-0 d-none"
                     role="alert"></div>

            </form>
        </div>
    </div>

    <h2 class="mb-3">Available Bus Trips</h2>

    <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Departure</th>
                    <th>Destination</th>
                    <th>Departure Date</th>
                    <th>Departure Time</th>
                    <th>Ticket Price</th>
                    <th>Available Seats</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody id="tripTable">

                <tr>
                    <td>1</td>
                    <td>Can Tho</td>
                    <td>Ho Chi Minh City</td>
                    <td>2026-10-20</td>
                    <td>08:00</td>
                    <td>150.000 VND</td>
                    <td>
                        <span class="badge bg-success">
                            20 Available
                        </span>
                    </td>
                    <td>
                        <div class="d-flex flex-wrap gap-1">
                            <button type="button"
                                    class="btn btn-primary btn-sm"
                                    onclick="bookTicket(1)">
                                Book Ticket
                            </button>

                            <button type="button"
                                    class="btn btn-secondary btn-sm"
                                    onclick="viewDetail(1)">
                                Details
                            </button>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>2</td>
                    <td>Ho Chi Minh City</td>
                    <td>Da Lat</td>
                    <td>2026-10-20</td>
                    <td>22:00</td>
                    <td>280.000 VND</td>
                    <td>
                        <span class="badge bg-success">
                            12 Available
                        </span>
                    </td>
                    <td>
                        <div class="d-flex flex-wrap gap-1">
                            <button type="button"
                                    class="btn btn-primary btn-sm"
                                    onclick="bookTicket(2)">
                                Book Ticket
                            </button>

                            <button type="button"
                                    class="btn btn-secondary btn-sm"
                                    onclick="viewDetail(2)">
                                Details
                            </button>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>3</td>
                    <td>Ho Chi Minh City</td>
                    <td>Nha Trang</td>
                    <td>2026-10-21</td>
                    <td>21:30</td>
                    <td>320.000 VND</td>
                    <td>
                        <span class="badge bg-warning text-dark">
                            5 Left
                        </span>
                    </td>
                    <td>
                        <div class="d-flex flex-wrap gap-1">
                            <button type="button"
                                    class="btn btn-primary btn-sm"
                                    onclick="bookTicket(3)">
                                Book Ticket
                            </button>

                            <button type="button"
                                    class="btn btn-secondary btn-sm"
                                    onclick="viewDetail(3)">
                                Details
                            </button>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>4</td>
                    <td>Da Lat</td>
                    <td>Ho Chi Minh City</td>
                    <td>2026-10-21</td>
                    <td>09:00</td>
                    <td>280.000 VND</td>
                    <td>
                        <span class="badge bg-danger">
                            Sold Out
                        </span>
                    </td>
                    <td>
                        <button type="button"
                                class="btn btn-danger btn-sm"
                                disabled>
                            Sold Out
                        </button>
                    </td>
                </tr>

            </tbody>
        </table>
    </div>

    <p id="resultMessage" class="text-muted"></p>

</div>

<script>
    const searchForm = document.getElementById("searchForm");
    const fromSelect = document.getElementById("from");
    const toSelect = document.getElementById("to");
    const dateInput = document.getElementById("date");
    const searchError = document.getElementById("searchError");
    const resultMessage = document.getElementById("resultMessage");
    const tripRows = document.querySelectorAll("#tripTable tr");

    function getToday() {
        const now = new Date();

        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, "0");
        const day = String(now.getDate()).padStart(2, "0");

        return year + "-" + month + "-" + day;
    }

    function updateMinimumDate() {
        dateInput.min = getToday();
    }

    function showError(message) {
        searchError.textContent = message;
        searchError.classList.remove("d-none");
    }

    function clearError() {
        searchError.textContent = "";
        searchError.classList.add("d-none");
    }

    document.getElementById("swapButton").addEventListener(
            "click", function () {

                const temp = fromSelect.value;

                fromSelect.value = toSelect.value;
                toSelect.value = temp;

                clearError();
            }
    );

    searchForm.addEventListener("submit", function (e) {
        e.preventDefault();

        updateMinimumDate();
        clearError();

        const from = fromSelect.value;
        const to = toSelect.value;
        const date = dateInput.value;

        if (from && to && from === to) {
            showError(
                    "Departure and destination must be different."
                    );
            return;
        }

        if (date && date < getToday()) {
            showError(
                    "Departure date cannot be in the past."
                    );
            return;
        }

        if (document.getElementById("transferMode").checked) {
            if (!from || !to || !date) {
                showError(
                        "Please select departure, destination and departure date."
                        );
                return;
            }

            window.location.href =
                    "${pageContext.request.contextPath}/transfer"
                    + "?fromId=" + encodeURIComponent(from)
                    + "&toId=" + encodeURIComponent(to)
                    + "&date=" + encodeURIComponent(date);

            return;
        }

        let count = 0;

        tripRows.forEach(function (row) {
            const cells = row.querySelectorAll("td");

            const selectedFrom = fromSelect.options[
                    fromSelect.selectedIndex
            ].text;

            const selectedTo = toSelect.options[
                    toSelect.selectedIndex
            ].text;

            const fromName = selectedFrom === "Cần Thơ"
                    ? "Can Tho"
                    : selectedFrom === "TP. Hồ Chí Minh"
                    ? "Ho Chi Minh City"
                    : selectedFrom;

            const toName = selectedTo === "Cần Thơ"
                    ? "Can Tho"
                    : selectedTo === "TP. Hồ Chí Minh"
                    ? "Ho Chi Minh City"
                    : selectedTo;

            const matchFrom =
                    !from || cells[1].innerText.trim() === fromName;

            const matchTo =
                    !to || cells[2].innerText.trim() === toName;

            const matchDate =
                    !date || cells[3].innerText.trim() === date;

            const isMatch =
                    matchFrom && matchTo && matchDate;

            row.style.display = isMatch ? "" : "none";

            if (isMatch) {
                count++;
            }
        });

        resultMessage.innerText =
                "Found " + count + " bus trips.";
    });

    document.getElementById("resetButton").addEventListener(
            "click", function () {

                searchForm.reset();
                clearError();
                updateMinimumDate();

                tripRows.forEach(function (row) {
                    row.style.display = "";
                });

                resultMessage.innerText =
                        "Found " + tripRows.length + " bus trips.";
            }
    );

    function bookTicket(id) {
        alert("Demo booking for trip ID: " + id);
    }

    function viewDetail(id) {
        alert("Demo trip details for trip ID: " + id);
    }

    updateMinimumDate();

    resultMessage.innerText =
            "Found " + tripRows.length + " bus trips.";
</script>

<%@include file="/WEB-INF/common/footer.jsp" %>
