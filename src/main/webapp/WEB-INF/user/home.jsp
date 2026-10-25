
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/common/header.jsp" %>

<div class="container mt-5">

    <h1 class="fw-bold mb-3">Bus Ticket Booking</h1>
    <p class="text-muted">
        Search and book bus tickets quickly and easily
    </p>

    <!-- =====================================================
         BEGIN: SEARCH FORM

         TODO DATABASE (TV1):
         Replace hardcoded locations with LocationDAO data.
         Render location options using JSTL and EL.

         TODO INTEGRATION (TV4):
         Connect the search form to the search Controller.

         Keep IDs: searchForm, from, to, date.
         END: SEARCH FORM NOTES
    ====================================================== -->

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Search Bus Trips</h5>
        </div>

        <div class="card-body">
            <form id="searchForm">
                <div class="row g-3 align-items-end">

                    <!-- BEGIN: DEPARTURE -->
                    <div class="col-md-3">
                        <label for="from" class="form-label">
                            Departure
                        </label>

                        <select id="from" class="form-select">
                            <option value="">All</option>
                            <option>Can Tho</option>
                            <option>Ho Chi Minh City</option>
                            <option>Da Lat</option>
                            <option>Nha Trang</option>
                        </select>
                    </div>
                    <!-- END: DEPARTURE -->

                    <!-- BEGIN: DESTINATION AND SWAP -->
                    <div class="col-md-3">
                        <label for="to" class="form-label">
                            Destination
                        </label>

                        <div class="input-group">
                            <select id="to" class="form-select">
                                <option value="">All</option>
                                <option>Can Tho</option>
                                <option>Ho Chi Minh City</option>
                                <option>Da Lat</option>
                                <option>Nha Trang</option>
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
                    <!-- END: DESTINATION AND SWAP -->

                    <!-- BEGIN: DEPARTURE DATE -->
                    <div class="col-md-3">
                        <label for="date" class="form-label">
                            Departure Date
                        </label>

                        <input type="date"
                               id="date"
                               class="form-control">
                    </div>
                    <!-- END: DEPARTURE DATE -->

                    <!-- BEGIN: SEARCH AND RESET BUTTONS -->
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
                    <!-- END: SEARCH AND RESET BUTTONS -->

                </div>

                <!-- BEGIN: VALIDATION MESSAGE -->
                <div id="searchError"
                     class="alert alert-danger mt-3 mb-0 d-none"
                     role="alert"></div>
                <!-- END: VALIDATION MESSAGE -->

            </form>
        </div>
    </div>

    <!-- END: SEARCH FORM -->

    <!-- =====================================================
         BEGIN: TRIP LIST - DEMO DATA

         TODO DATABASE (TV2):
         1. Replace hardcoded rows with TripDAO results.
         2. Render trip data using JSTL and EL.
         3. Use real availableSeats values.
         4. Preserve the existing 8-column Bootstrap table.

         TODO DATABASE (TV2):
         TripDAO.searchTrips(from, to, date, guests)
         will be used by the search functionality.

         TODO PAGINATION (TV5):
         Integrate pagination when TV5 finishes.

         TODO INTEGRATION (TV4):
         Connect the selected trip to the booking flow.

         SEAT STATUS RULES:
         0 seats   = Sold Out (red)
         1-5 seats = Few Seats Left (yellow)
         >5 seats  = Available (green)
    ====================================================== -->

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

                <!-- BEGIN: DEMO TRIP 1 -->
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
                <!-- END: DEMO TRIP 1 -->

                <!-- BEGIN: DEMO TRIP 2 -->
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
                <!-- END: DEMO TRIP 2 -->

                <!-- BEGIN: DEMO TRIP 3 -->
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
                <!-- END: DEMO TRIP 3 -->

                <!-- BEGIN: DEMO TRIP 4 -->
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
                <!-- END: DEMO TRIP 4 -->

            </tbody>
        </table>
    </div>

    <!-- END: TRIP LIST - DEMO DATA -->

    <!-- BEGIN: SEARCH RESULT MESSAGE -->
    <p id="resultMessage" class="text-muted"></p>
    <!-- END: SEARCH RESULT MESSAGE -->

</div>

<script>
    // =====================================================
    // BEGIN: SEARCH FORM ELEMENTS
    // =====================================================

    const searchForm = document.getElementById("searchForm");
    const fromSelect = document.getElementById("from");
    const toSelect = document.getElementById("to");
    const dateInput = document.getElementById("date");
    const searchError = document.getElementById("searchError");
    const resultMessage = document.getElementById("resultMessage");
    const tripRows = document.querySelectorAll("#tripTable tr");

    // END: SEARCH FORM ELEMENTS


    // =====================================================
    // BEGIN: DATE VALIDATION
    //
    // TODO INTEGRATION (TV4):
    // Validate the departure date again on the server.
    // Client-side validation alone is not sufficient.
    // =====================================================

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

    updateMinimumDate();

    // END: DATE VALIDATION


    // =====================================================
    // BEGIN: VALIDATION MESSAGES
    // =====================================================

    function showError(message) {
        searchError.textContent = message;
        searchError.classList.remove("d-none");
    }

    function clearError() {
        searchError.textContent = "";
        searchError.classList.add("d-none");
    }

    // END: VALIDATION MESSAGES


    // =====================================================
    // BEGIN: SWAP DEPARTURE AND DESTINATION
    //
    // Keep this functionality when integrating database.
    // =====================================================

    document.getElementById("swapButton").addEventListener(
        "click", function() {

            const temp = fromSelect.value;

            fromSelect.value = toSelect.value;
            toSelect.value = temp;

            clearError();
        }
    );

    // END: SWAP DEPARTURE AND DESTINATION


    // =====================================================
    // BEGIN: CLIENT-SIDE TRIP SEARCH
    //
    // TODO DATABASE (TV2):
    // Replace hardcoded trip data with TripDAO results.
    //
    // TODO INTEGRATION (TV4):
    // Connect the search form to the search Controller.
    // Do not keep filtering only HTML rows after
    // server-side search is implemented.
    //
    // KEEP:
    // - Date validation
    // - Departure / Destination validation
    // - Swap functionality
    // - Reset functionality
    // =====================================================

    searchForm.addEventListener("submit", function(e) {
        e.preventDefault();

        updateMinimumDate();
        clearError();

        const from = fromSelect.value;
        const to = toSelect.value;
        const date = dateInput.value;

        // Check duplicate locations
        if (from && to && from === to) {
            showError(
                "Departure and destination must be different."
            );
            return;
        }

        // Check past dates
        if (date && date < getToday()) {
            showError(
                "Departure date cannot be in the past."
            );
            return;
        }

        let count = 0;

        tripRows.forEach(function(row) {
            const cells = row.querySelectorAll("td");

            const matchFrom =
                !from || cells[1].innerText.trim() === from;

            const matchTo =
                !to || cells[2].innerText.trim() === to;

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

    // END: CLIENT-SIDE TRIP SEARCH


    // =====================================================
    // BEGIN: RESET SEARCH
    //
    // TODO INTEGRATION (TV4):
    // When server-side search is implemented,
    // make Reset restore the default trip list.
    // =====================================================

    document.getElementById("resetButton").addEventListener(
        "click", function() {

            searchForm.reset();
            clearError();
            updateMinimumDate();

            tripRows.forEach(function(row) {
                row.style.display = "";
            });

            resultMessage.innerText =
                "Found " + tripRows.length + " bus trips.";
        }
    );

    // END: RESET SEARCH


    // =====================================================
    // BEGIN: BOOKING AND DETAILS - DEMO
    //
    // TODO INTEGRATION (TV4):
    // Connect Book Ticket to BookingController.
    // Pass the selected trip ID to the booking process.
    //
    // TODO INTEGRATION:
    // Connect Details to the appropriate trip detail page.
    //
    // Keep these demo functions until integration.
    // =====================================================

    function bookTicket(id) {
        alert("Demo booking for trip ID: " + id);
    }

    function viewDetail(id) {
        alert("Demo trip details for trip ID: " + id);
    }

    // END: BOOKING AND DETAILS - DEMO


    // =====================================================
    // BEGIN: INITIAL RESULT COUNT
    // =====================================================

    resultMessage.innerText =
        "Found " + tripRows.length + " bus trips.";

    // END: INITIAL RESULT COUNT
</script>

<%@include file="/WEB-INF/common/footer.jsp" %>
