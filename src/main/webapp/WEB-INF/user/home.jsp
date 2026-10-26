
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/common/header.jsp" %>

<div class="container mt-5 mb-5">

    <h1 class="fw-bold mb-3">Bus Ticket Booking</h1>
    <p class="text-muted">
        Search and book bus tickets quickly and easily
    </p>

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Search Bus Trips</h5>
        </div>

        <div class="card-body">

            <form id="searchForm" method="GET">

                <div class="d-flex flex-wrap gap-4 mb-4">

                    <div class="form-check">
                        <input type="radio"
                               class="form-check-input"
                               id="directMode"
                               name="searchMode"
                               value="direct"
                               checked>

                        <label class="form-check-label" for="directMode">
                            Direct Trips
                        </label>
                    </div>

                    <div class="form-check">
                        <input type="radio"
                               class="form-check-input"
                               id="transferMode"
                               name="searchMode"
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

                        <select id="from"
                                class="form-select"
                                required>
                            <option value="">Select departure</option>
                            <option value="1" data-search="TP.HCM">TP. Hồ Chí Minh</option>
                            <option value="2" data-search="Cần Thơ">Cần Thơ</option>
                            <option value="3" data-search="Kiên Giang">Kiên Giang</option>
                            <option value="4" data-search="An Giang">An Giang</option>
                            <option value="5" data-search="Cà Mau">Cà Mau</option>
                            <option value="6" data-search="Bạc Liêu">Bạc Liêu</option>
                            <option value="7" data-search="Sóc Trăng">Sóc Trăng</option>
                            <option value="8" data-search="Đồng Tháp">Đồng Tháp</option>
                            <option value="9" data-search="Bến Tre">Bến Tre</option>
                            <option value="10" data-search="Vĩnh Long">Vĩnh Long</option>
                            <option value="11" data-search="Tiền Giang">Tiền Giang</option>
                            <option value="12" data-search="Trà Vinh">Trà Vinh</option>
                            <option value="13" data-search="Hậu Giang">Hậu Giang</option>
                            <option value="14" data-search="Long An">Long An</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="to" class="form-label">
                            Destination
                        </label>

                        <div class="input-group">

                            <select id="to"
                                    class="form-select"
                                    required>
                                <option value="">Select destination</option>
                                <option value="1" data-search="TP.HCM">TP. Hồ Chí Minh</option>
                                <option value="2" data-search="Cần Thơ">Cần Thơ</option>
                                <option value="3" data-search="Kiên Giang">Kiên Giang</option>
                                <option value="4" data-search="An Giang">An Giang</option>
                                <option value="5" data-search="Cà Mau">Cà Mau</option>
                                <option value="6" data-search="Bạc Liêu">Bạc Liêu</option>
                                <option value="7" data-search="Sóc Trăng">Sóc Trăng</option>
                                <option value="8" data-search="Đồng Tháp">Đồng Tháp</option>
                                <option value="9" data-search="Bến Tre">Bến Tre</option>
                                <option value="10" data-search="Vĩnh Long">Vĩnh Long</option>
                                <option value="11" data-search="Tiền Giang">Tiền Giang</option>
                                <option value="12" data-search="Trà Vinh">Trà Vinh</option>
                                <option value="13" data-search="Hậu Giang">Hậu Giang</option>
                                <option value="14" data-search="Long An">Long An</option>
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

                    <div class="col-md-2">
                        <label for="date" class="form-label">
                            Departure Date
                        </label>

                        <input type="date"
                               id="date"
                               class="form-control"
                               required>
                    </div>

                    <div class="col-md-1">
                        <label for="guests" class="form-label">
                            Guests
                        </label>

                        <input type="number"
                               id="guests"
                               class="form-control"
                               min="1"
                               max="10"
                               value="1"
                               required>
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

</div>


<script>
    const searchForm = document.getElementById("searchForm");
    const fromSelect = document.getElementById("from");
    const toSelect = document.getElementById("to");
    const dateInput = document.getElementById("date");
    const guestsInput = document.getElementById("guests");
    const searchError = document.getElementById("searchError");

    function getToday() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, "0");
        const day = String(now.getDate()).padStart(2, "0");

        return year + "-" + month + "-" + day;
    }

    function showError(message) {
        searchError.textContent = message;
        searchError.classList.remove("d-none");
    }

    function clearError() {
        searchError.textContent = "";
        searchError.classList.add("d-none");
    }

    dateInput.min = getToday();

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
        clearError();

        const from = fromSelect.value;
        const to = toSelect.value;
        const date = dateInput.value;
        const guests = Number(guestsInput.value);

        if (!from || !to || !date) {
            showError("Please enter all search information.");
            return;
        }

        if (from === to) {
            showError("Departure and destination must be different.");
            return;
        }

        if (date < getToday()) {
            showError("Departure date cannot be in the past.");
            return;
        }

        if (!Number.isInteger(guests) || guests < 1 || guests > 10) {
            showError("Guests must be between 1 and 10.");
            return;
        }

        const transfer =
                document.getElementById("transferMode").checked;

        const params = new URLSearchParams();

        if (transfer) {
            params.set("fromId", from);
            params.set("toId", to);
        } else {
            params.set(
                    "from",
                    fromSelect.selectedOptions[0].dataset.search
                    );
            params.set(
                    "to",
                    toSelect.selectedOptions[0].dataset.search
                    );
        }

        params.set("date", date);
        params.set("guests", guests);

        const path = transfer ? "/transfer" : "/search";

        window.location.href =
                "${pageContext.request.contextPath}"
                + path + "?" + params.toString();
    });

    document.getElementById("resetButton").addEventListener(
            "click", function () {
                searchForm.reset();
                clearError();
                dateInput.min = getToday();
            }
    );
</script>

<%@include file="/WEB-INF/common/footer.jsp" %>
