
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@include file="/WEB-INF/common/header.jsp" %>

<div class="container mt-5 mb-5">

    <h1 class="fw-bold mb-3">Bus Ticket Booking</h1>

    <p class="text-muted">
        Search and book bus tickets quickly and easily.
    </p>

    <div class="card shadow-sm mb-4">

        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Search Bus Trips</h5>
        </div>

        <div class="card-body">

            <form id="searchForm"
                  action="${pageContext.request.contextPath}/transfer"
                  method="GET">

                <div class="d-flex flex-wrap gap-4 mb-4">

                    <div class="form-check">
                        <input type="radio"
                               class="form-check-input"
                               id="directMode"
                               name="searchMode"
                               value="direct"
                               <c:if test="${param.mode != 'transfer'}">checked</c:if>>

                        <label class="form-check-label" for="directMode">
                            Direct Trips
                        </label>
                    </div>

                    <div class="form-check">
                        <input type="radio"
                               class="form-check-input"
                               id="transferMode"
                               name="searchMode"
                               value="transfer"
                               <c:if test="${param.mode == 'transfer'}">checked</c:if>>

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
                                name="fromId"
                                class="form-select"
                                required>

                            <option value="">Select departure</option>

                            <c:forEach var="location" items="${locations}">
                                <option value="${location.id}">
                                    <c:out value="${location.name}"/>
                                </option>
                            </c:forEach>

                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="to" class="form-label">
                            Destination
                        </label>

                        <div class="input-group">
                            <select id="to"
                                    name="toId"
                                    class="form-select"
                                    required>

                                <option value="">Select destination</option>

                                <c:forEach var="location" items="${locations}">
                                    <option value="${location.id}">
                                        <c:out value="${location.name}"/>
                                    </option>
                                </c:forEach>

                            </select>

                            <button type="button"
                                    class="btn btn-outline-primary"
                                    onclick="swapLocations()"
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
                               name="date"
                               class="form-control"
                               min="${today}"
                               required>
                    </div>

                    <div class="col-md-1">
                        <label for="guests" class="form-label">
                            Guests
                        </label>

                        <input type="number"
                               id="guests"
                               name="guests"
                               class="form-control"
                               min="1"
                               max="10"
                               value="1"
                               required>
                    </div>

                    <div class="col-md-3">
                        <div class="d-flex gap-2">

                            <button type="submit"
                                    class="btn btn-warning flex-grow-1"
                                    onclick="return prepareSearch()">

                                <i class="bi bi-search me-1"></i>
                                Search Trips
                            </button>

                            <button type="reset"
                                    class="btn btn-outline-secondary"
                                    title="Reset search"
                                    aria-label="Reset search">

                                <i class="bi bi-arrow-clockwise"></i>
                            </button>

                        </div>
                    </div>

                </div>

                <input type="hidden"
                       id="directFrom"
                       name="from"
                       disabled>

                <input type="hidden"
                       id="directTo"
                       name="to"
                       disabled>

            </form>
        </div>
    </div>
</div>

<script>
    function swapLocations() {
        var from = document.getElementById("from");
        var to = document.getElementById("to");

        var temp = from.value;

        from.value = to.value;
        to.value = temp;
    }

    function prepareSearch() {
        var form = document.getElementById("searchForm");
        var from = document.getElementById("from");
        var to = document.getElementById("to");
        var date = document.getElementById("date");
        var guests = document.getElementById("guests");

        if (!form.checkValidity()) {
            form.reportValidity();
            return false;
        }

        if (from.value === to.value) {
            alert("Departure and destination must be different.");
            return false;
        }

        if (date.value < date.min) {
            alert("Departure date cannot be in the past.");
            return false;
        }

        var directFrom = document.getElementById("directFrom");
        var directTo = document.getElementById("directTo");

        if (document.getElementById("transferMode").checked) {
            form.action = "${pageContext.request.contextPath}/transfer";

            from.name = "fromId";
            to.name = "toId";

            directFrom.disabled = true;
            directTo.disabled = true;
        } else {
            form.action = "${pageContext.request.contextPath}/search";

            directFrom.value = from.options[from.selectedIndex].text;
            directTo.value = to.options[to.selectedIndex].text;

            directFrom.disabled = false;
            directTo.disabled = false;

            from.removeAttribute("name");
            to.removeAttribute("name");
        }

        return true;
    }
</script>

<%@include file="/WEB-INF/common/footer.jsp" %>
