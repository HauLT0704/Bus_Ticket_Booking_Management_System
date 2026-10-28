
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<%@include file="/WEB-INF/common/header.jsp" %>

<div class="container mt-5 mb-5">

    <h1 class="fw-bold mb-3">Bus Ticket Booking</h1>

    <p class="text-muted">
        Search and book bus tickets quickly and easily.
    </p>

    <!-- SEARCH FORM -->
    <div class="card shadow-sm mb-4">

        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Search Bus Trips</h5>
        </div>

        <div class="card-body">

            <form id="searchForm" method="GET">

                <!-- SEARCH MODE -->
                <div class="d-flex flex-wrap gap-4 mb-4">

                    <div class="form-check">
                        <input type="radio"
                               class="form-check-input"
                               id="directMode"
                               name="searchMode"
                               value="direct"
                               checked>

                        <label class="form-check-label"
                               for="directMode">
                            Direct Trips
                        </label>
                    </div>

                    <div class="form-check">
                        <input type="radio"
                               class="form-check-input"
                               id="transferMode"
                               name="searchMode"
                               value="transfer">

                        <label class="form-check-label"
                               for="transferMode">
                            Transfer Trips (Ghép chuyến)
                        </label>
                    </div>

                </div>

                <!-- SEARCH FIELDS -->
                <div class="row g-3 align-items-end">

                    <!-- DEPARTURE -->
                    <div class="col-md-3">

                        <label for="from" class="form-label">
                            Departure
                        </label>

                        <select id="from"
                                class="form-select"
                                required>

                            <option value="">
                                Select departure
                            </option>

                            <c:forEach var="location"
                                       items="${locations}">

                                <option value="${location.id}"
                                        data-search="${location.name}">
                                    <c:out value="${location.name}"/>
                                </option>

                            </c:forEach>

                        </select>
                    </div>

                    <!-- DESTINATION -->
                    <div class="col-md-3">

                        <label for="to" class="form-label">
                            Destination
                        </label>

                        <div class="input-group">

                            <select id="to"
                                    class="form-select"
                                    required>

                                <option value="">
                                    Select destination
                                </option>

                                <c:forEach var="location"
                                           items="${locations}">

                                    <option value="${location.id}"
                                            data-search="${location.name}">
                                        <c:out value="${location.name}"/>
                                    </option>

                                </c:forEach>

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

                    <!-- DEPARTURE DATE -->
                    <div class="col-md-2">

                        <label for="date" class="form-label">
                            Departure Date
                        </label>

                        <input type="date"
                               id="date"
                               class="form-control"
                               required>
                    </div>

                    <!-- PASSENGERS -->
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

                    <!-- BUTTONS -->
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

                <!-- ERROR MESSAGE -->
                <div id="searchError"
                     class="alert alert-danger mt-3 mb-0 d-none"
                     role="alert">
                </div>

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

    const contextPath = "${pageContext.request.contextPath}";

    // GET TODAY IN LOCAL TIME
    function getToday() {
        const now = new Date();

        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, "0");
        const day = String(now.getDate()).padStart(2, "0");

        return year + "-" + month + "-" + day;
    }

    // SHOW ERROR
    function showError(message) {
        searchError.textContent = message;
        searchError.classList.remove("d-none");
    }

    // CLEAR ERROR
    function clearError() {
        searchError.textContent = "";
        searchError.classList.add("d-none");
    }

    // DISABLE PAST DATES
    dateInput.min = getToday();

    // SWAP DEPARTURE AND DESTINATION
    document.getElementById("swapButton")
            .addEventListener("click", function () {

                const temp = fromSelect.value;
                fromSelect.value = toSelect.value;
                toSelect.value = temp;

                clearError();
            });

    // RESET SEARCH FORM
    document.getElementById("resetButton")
            .addEventListener("click", function () {

                searchForm.reset();

                dateInput.min = getToday();

                clearError();
            });

    // SEARCH SUBMIT
    searchForm.addEventListener("submit", function (e) {

        e.preventDefault();

        clearError();

        const from = fromSelect.value;
        const to = toSelect.value;
        const date = dateInput.value;
        const guests = Number(guestsInput.value);

        // VALIDATE REQUIRED FIELDS
        if (!from || !to || !date) {
            showError("Please enter all search information.");
            return;
        }

        // VALIDATE LOCATIONS
        if (from === to) {
            showError("Departure and destination must be different.");
            return;
        }

        // VALIDATE DATE
        if (date < getToday()) {
            showError("Departure date cannot be in the past.");
            return;
        }

        // VALIDATE PASSENGERS
        if (!Number.isInteger(guests)
                || guests < 1
                || guests > 10) {

            showError("Guests must be between 1 and 10.");
            return;
        }

        const transfer =
                document.getElementById("transferMode").checked;

        const params = new URLSearchParams();

        if (transfer) {

            // TRANSFER CONTROLLER: Location IDs
            params.set("fromId", from);
            params.set("toId", to);

        } else {

            // BOOKING CONTROLLER: Location names
            params.set(
                    "from",
                    fromSelect.selectedOptions[0].text.trim()
            );

            params.set(
                    "to",
                    toSelect.selectedOptions[0].text.trim()
            );
        }

        // COMMON PARAMETERS
        params.set("date", date);
        params.set("guests", String(guests));

        // ROUTE TO EXISTING SERVLET
        const path = transfer ? "/transfer" : "/search";

        window.location.href =
                contextPath + path + "?" + params.toString();
    });
</script>

<%@include file="/WEB-INF/common/footer.jsp" %>
