<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tuyến Đường - Vé Xe Miền Tây</title>
    <!-- Bootstrap 5.3 & Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <jsp:include page="../common/header.jsp" />

    <div class="container my-5" style="max-width: 620px;">
        <div class="card border-0 shadow-sm rounded-4 bg-white p-4 p-md-5">

            <div class="text-center mb-4">
                <c:choose>
                    <c:when test="${isDelete}">
                        <div class="fs-1 text-danger mb-2">
                            <i class="bi bi-trash3-fill"></i>
                        </div>
                        <h4 class="fw-bold text-danger mb-1">Xác Nhận Xóa Tuyến Đường</h4>
                        <p class="text-secondary small mb-0">Xem lại thông tin tuyến đường trước khi xác nhận xóa vĩnh viễn</p>
                    </c:when>
                    <c:when test="${route != null && route.id != 0}">
                        <div class="fs-1 text-warning mb-2">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">Cập Nhật Tuyến Đường</h4>
                        <p class="text-secondary small mb-0">Điền thông tin chi tiết và cự ly chuẩn cho tuyến đường di chuyển</p>
                    </c:when>
                    <c:otherwise>
                        <div class="fs-1 text-primary mb-2">
                            <i class="bi bi-signpost-split-fill"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">Thêm Tuyến Đường Mới</h4>
                        <p class="text-secondary small mb-0">Điền thông tin chi tiết và cự ly chuẩn cho tuyến đường di chuyển</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- CẢNH BÁO NẾU ĐANG Ở CHẾ ĐỘ XÓA -->
            <c:if test="${isDelete}">
                <div class="alert alert-warning border-warning d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-3 text-warning me-3"></i>
                    <div class="small">
                        <strong>Cảnh báo quan trọng:</strong> Hành động này sẽ xóa hoàn toàn tuyến đường khỏi hệ thống. Nếu tuyến đường đã có chuyến xe hoặc vé được đặt, hệ thống sẽ từ chối xóa để bảo toàn dữ liệu.
                    </div>
                </div>
            </c:if>

            <!-- THÔNG BÁO LỖI -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- FORM NHẬP LIỆU / XÁC NHẬN XÓA -->
            <form id="routeForm" action="${pageContext.request.contextPath}/admin/route" method="POST" novalidate>
                <c:choose>
                    <c:when test="${isDelete}">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${route.id}">
                    </c:when>
                    <c:when test="${route != null && route.id != 0}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${route.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="insert">
                    </c:otherwise>
                </c:choose>

                <!-- ĐIỂM ĐI -->
                <div class="mb-3">
                    <label for="fromLocationId" class="form-label fw-semibold text-secondary small">
                        ĐIỂM ĐI: <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                    </label>
                    <select class="form-select py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                            id="fromLocationId" name="fromLocationId" required <c:if test="${isDelete}">disabled</c:if>>
                        <option value="">-- Chọn điểm đi --</option>
                        <c:forEach var="loc" items="${locationList}">
                            <option value="${loc.id}" data-name="${loc.name}" <c:if test="${route != null && route.fromLocation != null && route.fromLocation.id == loc.id}">selected</c:if>>
                                ${loc.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- ĐIỂM ĐẾN -->
                <div class="mb-3">
                    <label for="toLocationId" class="form-label fw-semibold text-secondary small">
                        ĐIỂM ĐẾN: <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                    </label>
                    <select class="form-select py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                            id="toLocationId" name="toLocationId" required <c:if test="${isDelete}">disabled</c:if>>
                        <option value="">-- Chọn điểm đến --</option>
                        <c:forEach var="loc" items="${locationList}">
                            <option value="${loc.id}" data-name="${loc.name}" <c:if test="${route != null && route.toLocation != null && route.toLocation.id == loc.id}">selected</c:if>>
                                ${loc.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- KHUNG GỢI Ý / CỐ ĐỊNH CỰ LY CHUẨN THỰC TẾ (CHỈ HIỆN KHI THÊM / SỬA) -->
                <c:if test="${!isDelete}">
                    <div id="standardBox" class="card border border-primary-subtle bg-primary-subtle bg-opacity-10 p-3 mb-3 rounded-3 d-none">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <span class="badge bg-primary mb-1">
                                    <i class="bi bi-geo-alt-fill me-1"></i> Cự ly chuẩn thực tế
                                </span>
                                <div class="fw-semibold text-dark small" id="standardRouteTitle"></div>
                                <div class="text-muted small" id="standardRouteDetail"></div>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-primary" id="btnApplyStandard" title="Khôi phục số liệu chuẩn">
                                <i class="bi bi-arrow-clockwise me-1"></i> Áp dụng chuẩn
                            </button>
                        </div>
                    </div>
                </c:if>

                <!-- KHOẢNG CÁCH -->
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label for="distance" class="form-label fw-semibold text-secondary small mb-0">
                            KHOẢNG CÁCH (KM): <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                        </label>
                        <c:if test="${!isDelete}">
                            <span class="badge bg-light text-secondary border small">Tối thiểu: 20.0 km</span>
                        </c:if>
                    </div>
                    <div class="input-group">
                        <input type="number" step="0.1" min="20" max="1000" 
                               class="form-control py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                               id="distance" name="distance" 
                               value="<c:out value='${route.distance}'/>" required 
                               placeholder="Ví dụ: 62.0" <c:if test="${isDelete}">readonly</c:if>>
                        <span class="input-group-text bg-light text-secondary">km</span>
                    </div>
                    <c:if test="${!isDelete}">
                        <div class="form-text text-muted small mt-1">
                            Khoảng cách tuyến đường liên tỉnh thực tế (20.0 km - 1,000.0 km).
                        </div>
                    </c:if>
                </div>

                <!-- THỜI GIAN DỰ KIẾN -->
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label for="duration" class="form-label fw-semibold text-secondary small mb-0">
                            THỜI GIAN DỰ KIẾN (PHÚT): <c:if test="${!isDelete}"><span class="text-danger">*</span></c:if>
                        </label>
                        <span id="durationHoursText" class="badge bg-light text-secondary border small"></span>
                    </div>
                    <div class="input-group">
                        <input type="number" min="30" max="1440" 
                               class="form-control py-2 <c:if test='${isDelete}'>bg-light text-muted</c:if>" 
                               id="duration" name="duration" 
                               value="<c:out value='${route.duration}'/>" required 
                               placeholder="Ví dụ: 90 (1 giờ 30 phút)" <c:if test="${isDelete}">readonly</c:if>>
                        <span class="input-group-text bg-light text-secondary">phút</span>
                    </div>
                    <c:if test="${!isDelete}">
                        <div class="form-text text-muted small mt-1">
                            Thời gian di chuyển dự kiến (tối thiểu 30 phút, tối đa 24 giờ).
                        </div>
                    </c:if>
                </div>

                <!-- THÔNG BÁO VẬN TỐC TRUNG BÌNH & KIỂM TRA LOGIC -->
                <div id="logicFeedback" class="mb-4 d-none">
                    <div class="alert py-2 px-3 small mb-0" id="logicAlert">
                        <i id="logicIcon" class="bi me-1"></i>
                        <span id="logicMessage"></span>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/route" class="btn btn-outline-secondary px-4 py-2">
                        <i class="bi bi-arrow-left me-1"></i> <c:choose><c:when test="${isDelete}">Hủy Bỏ</c:when><c:otherwise>Quay Lại</c:otherwise></c:choose>
                    </a>
                    <c:choose>
                        <c:when test="${isDelete}">
                            <button type="submit" class="btn btn-danger px-4 py-2 fw-semibold" id="btnSubmit">
                                <i class="bi bi-trash3-fill me-1"></i> Xác Nhận Xóa
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold" id="btnSubmit">
                                <i class="bi bi-check2-circle me-1"></i> Lưu Tuyến Đường
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <!-- JAVASCRIPT TỰ ĐỘNG CỐ ĐỊNH & KIỂM SOÁT LOGIC TUYẾN ĐƯỜNG -->
    <script>
    (function() {
        const isDeleteMode = ${isDelete ? 'true' : 'false'};

        // Bảng cự ly chuẩn giữa 14 tỉnh thành (km, phút)
        const standardRoutes = {
            "1-2": { dist: 165.0, dur: 180 }, "1-3": { dist: 250.0, dur: 300 }, "1-4": { dist: 240.0, dur: 330 },
            "1-5": { dist: 350.0, dur: 450 }, "1-6": { dist: 280.0, dur: 360 }, "1-7": { dist: 230.0, dur: 300 },
            "1-8": { dist: 150.0, dur: 180 }, "1-9": { dist: 85.0, dur: 120 }, "1-10": { dist: 135.0, dur: 150 },
            "1-11": { dist: 70.0, dur: 90 }, "1-12": { dist: 130.0, dur: 180 }, "1-13": { dist: 200.0, dur: 240 },
            "1-14": { dist: 45.0, dur: 60 },
            "2-3": { dist: 110.0, dur: 150 }, "2-4": { dist: 65.0, dur: 90 }, "2-5": { dist: 180.0, dur: 240 },
            "2-6": { dist: 110.0, dur: 150 }, "2-7": { dist: 62.0, dur: 90 }, "2-8": { dist: 80.0, dur: 100 },
            "2-9": { dist: 115.0, dur: 150 }, "2-10": { dist: 35.0, dur: 45 }, "2-11": { dist: 105.0, dur: 130 },
            "2-12": { dist: 75.0, dur: 100 }, "2-13": { dist: 45.0, dur: 60 }, "2-14": { dist: 135.0, dur: 160 },
            "3-4": { dist: 75.0, dur: 100 }, "3-5": { dist: 130.0, dur: 180 }, "3-6": { dist: 130.0, dur: 170 },
            "3-7": { dist: 140.0, dur: 190 }, "3-8": { dist: 145.0, dur: 200 }, "3-9": { dist: 190.0, dur: 260 },
            "3-10": { dist: 130.0, dur: 180 }, "3-11": { dist: 190.0, dur: 250 }, "3-12": { dist: 170.0, dur: 230 },
            "3-13": { dist: 75.0, dur: 100 }, "3-14": { dist: 215.0, dur: 270 },
            "4-5": { dist: 230.0, dur: 310 }, "4-6": { dist: 170.0, dur: 230 }, "4-7": { dist: 120.0, dur: 160 },
            "4-8": { dist: 50.0, dur: 70 }, "4-9": { dist: 165.0, dur: 220 }, "4-10": { dist: 90.0, dur: 120 },
            "4-11": { dist: 160.0, dur: 210 }, "4-12": { dist: 135.0, dur: 180 }, "4-13": { dist: 95.0, dur: 130 },
            "4-14": { dist: 195.0, dur: 250 },
            "5-6": { dist: 70.0, dur: 90 }, "5-7": { dist: 120.0, dur: 150 }, "5-8": { dist: 240.0, dur: 320 },
            "5-9": { dist: 260.0, dur: 350 }, "5-10": { dist: 210.0, dur: 280 }, "5-11": { dist: 275.0, dur: 360 },
            "5-12": { dist: 210.0, dur: 280 }, "5-13": { dist: 140.0, dur: 190 }, "5-14": { dist: 310.0, dur: 400 },
            "6-7": { dist: 50.0, dur: 65 }, "6-8": { dist: 180.0, dur: 240 }, "6-9": { dist: 200.0, dur: 270 },
            "6-10": { dist: 145.0, dur: 190 }, "6-11": { dist: 210.0, dur: 280 }, "6-12": { dist: 150.0, dur: 200 },
            "6-13": { dist: 85.0, dur: 110 }, "6-14": { dist: 245.0, dur: 320 },
            "7-8": { dist: 135.0, dur: 180 }, "7-9": { dist: 150.0, dur: 200 }, "7-10": { dist: 95.0, dur: 125 },
            "7-11": { dist: 165.0, dur: 210 }, "7-12": { dist: 60.0, dur: 80 }, "7-13": { dist: 65.0, dur: 85 },
            "7-14": { dist: 195.0, dur: 250 },
            "8-9": { dist: 105.0, dur: 140 }, "8-10": { dist: 45.0, dur: 60 }, "8-11": { dist: 85.0, dur: 110 },
            "8-12": { dist: 95.0, dur: 130 }, "8-13": { dist: 105.0, dur: 140 }, "8-14": { dist: 115.0, dur: 150 },
            "9-10": { dist: 55.0, dur: 75 }, "9-11": { dist: 20.0, dur: 30 }, "9-12": { dist: 55.0, dur: 75 },
            "9-13": { dist: 140.0, dur: 180 }, "9-14": { dist: 60.0, dur: 80 },
            "10-11": { dist: 65.0, dur: 80 }, "10-12": { dist: 55.0, dur: 75 }, "10-13": { dist: 75.0, dur: 95 },
            "10-14": { dist: 100.0, dur: 130 },
            "11-12": { dist: 70.0, dur: 95 }, "11-13": { dist: 140.0, dur: 180 }, "11-14": { dist: 35.0, dur: 45 },
            "12-13": { dist: 110.0, dur: 145 }, "12-14": { dist: 115.0, dur: 155 },
            "13-14": { dist: 170.0, dur: 220 }
        };

        const fromSelect = document.getElementById('fromLocationId');
        const toSelect = document.getElementById('toLocationId');
        const distanceInput = document.getElementById('distance');
        const durationInput = document.getElementById('duration');
        const standardBox = document.getElementById('standardBox');
        const standardTitle = document.getElementById('standardRouteTitle');
        const standardDetail = document.getElementById('standardRouteDetail');
        const btnApplyStandard = document.getElementById('btnApplyStandard');
        const durationHoursText = document.getElementById('durationHoursText');
        const logicFeedback = document.getElementById('logicFeedback');
        const logicAlert = document.getElementById('logicAlert');
        const logicIcon = document.getElementById('logicIcon');
        const logicMessage = document.getElementById('logicMessage');
        const routeForm = document.getElementById('routeForm');
        const btnSubmit = document.getElementById('btnSubmit');

        let currentStandard = null;

        function getStandard(id1, id2) {
            if (!id1 || !id2 || id1 === id2) return null;
            const key = Math.min(id1, id2) + '-' + Math.max(id1, id2);
            return standardRoutes[key] || null;
        }

        function formatDuration(minutes) {
            if (!minutes || minutes <= 0) return '';
            const h = Math.floor(minutes / 60);
            const m = minutes % 60;
            if (h === 0) return m + ' phút';
            if (m === 0) return h + ' giờ';
            return h + ' giờ ' + m + ' phút';
        }

        function updateStandardInfo(autoFillIfEmptyOrAdd) {
            if (isDeleteMode) {
                const dur = parseInt(durationInput.value);
                if (!isNaN(dur) && dur > 0) durationHoursText.textContent = '~ ' + formatDuration(dur);
                return;
            }

            const fromId = parseInt(fromSelect.value);
            const toId = parseInt(toSelect.value);

            if (!fromId || !toId) {
                if (standardBox) standardBox.classList.add('d-none');
                currentStandard = null;
                validateLogic();
                return;
            }

            if (fromId === toId) {
                if (standardBox) standardBox.classList.add('d-none');
                currentStandard = null;
                showLogicFeedback('danger', 'bi-x-circle-fill', 'Điểm đi và điểm đến không được trùng nhau!');
                return;
            }

            const fromName = fromSelect.options[fromSelect.selectedIndex].text.trim();
            const toName = toSelect.options[toSelect.selectedIndex].text.trim();
            const std = getStandard(fromId, toId);
            currentStandard = std;

            if (std && standardBox) {
                standardBox.classList.remove('d-none');
                standardTitle.textContent = fromName + ' ⇄ ' + toName;
                standardDetail.textContent = 'Cự ly: ' + std.dist.toFixed(1) + ' km | Thời gian dự kiến: ' + std.dur + ' phút (~ ' + formatDuration(std.dur) + ')';

                const currentDist = parseFloat(distanceInput.value);
                const currentDur = parseInt(durationInput.value);
                if (autoFillIfEmptyOrAdd || isNaN(currentDist) || currentDist < 20 || isNaN(currentDur) || currentDur < 30) {
                    distanceInput.value = std.dist;
                    durationInput.value = std.dur;
                }
            } else if (standardBox) {
                standardBox.classList.add('d-none');
            }

            validateLogic();
        }

        function validateLogic() {
            if (isDeleteMode) return true;

            const fromId = parseInt(fromSelect.value);
            const toId = parseInt(toSelect.value);

            if (fromId && toId && fromId === toId) {
                showLogicFeedback('danger', 'bi-x-circle-fill', 'Điểm đi và điểm đến không được trùng nhau!');
                btnSubmit.disabled = true;
                return false;
            }

            const dist = parseFloat(distanceInput.value);
            const dur = parseInt(durationInput.value);

            if (!isNaN(dur) && dur > 0) {
                durationHoursText.textContent = '~ ' + formatDuration(dur);
            } else {
                durationHoursText.textContent = '';
            }

            if (isNaN(dist) && isNaN(dur)) {
                logicFeedback.classList.add('d-none');
                btnSubmit.disabled = false;
                return true;
            }

            if (isNaN(dist) || dist < 20.0) {
                showLogicFeedback('danger', 'bi-exclamation-octagon-fill', 'Khoảng cách tuyến đường liên tỉnh không hợp lệ! Khoảng cách tối thiểu phải từ 20.0 km trở lên.');
                btnSubmit.disabled = true;
                return false;
            }

            if (dist > 1000.0) {
                showLogicFeedback('danger', 'bi-exclamation-octagon-fill', 'Khoảng cách quá lớn (tối đa 1,000 km)!');
                btnSubmit.disabled = true;
                return false;
            }

            if (isNaN(dur) || dur < 30) {
                showLogicFeedback('danger', 'bi-exclamation-octagon-fill', 'Thời gian di chuyển dự kiến không hợp lệ! Thời gian tối thiểu phải từ 30 phút trở lên.');
                btnSubmit.disabled = true;
                return false;
            }

            if (dur > 1440) {
                showLogicFeedback('danger', 'bi-exclamation-octagon-fill', 'Thời gian di chuyển dự kiến quá dài (tối đa 24 giờ / 1,440 phút)!');
                btnSubmit.disabled = true;
                return false;
            }

            const speed = dist / (dur / 60.0);
            if (speed < 25.0) {
                showLogicFeedback('warning', 'bi-speedometer2', 'Tốc độ trung bình quá chậm (' + speed.toFixed(1) + ' km/h)! Xe khách liên tỉnh phải di chuyển từ 25.0 km/h đến 100.0 km/h.');
                btnSubmit.disabled = true;
                return false;
            }

            if (speed > 100.0) {
                showLogicFeedback('danger', 'bi-speedometer2', 'Tốc độ trung bình quá nhanh (' + speed.toFixed(1) + ' km/h)! Giới hạn tốc độ an toàn cho xe khách tối đa là 100.0 km/h.');
                btnSubmit.disabled = true;
                return false;
            }

            if (currentStandard) {
                const diffRatio = Math.abs(dist - currentStandard.dist) / currentStandard.dist;
                if (diffRatio > 0.35) {
                    showLogicFeedback('warning', 'bi-exclamation-triangle-fill', 
                        'Khoảng cách ' + dist.toFixed(1) + ' km lệch quá nhiều so với thực tế (chuẩn ~ ' + currentStandard.dist.toFixed(1) + ' km). Vui lòng kiểm tra lại!');
                    btnSubmit.disabled = true;
                    return false;
                }
            }

            showLogicFeedback('success', 'bi-check-circle-fill', 
                'Thông số hợp lý! Vận tốc trung bình dự kiến: ~ ' + speed.toFixed(1) + ' km/h (' + formatDuration(dur) + ').');
            btnSubmit.disabled = false;
            return true;
        }

        function showLogicFeedback(type, iconClass, msg) {
            logicFeedback.classList.remove('d-none');
            logicAlert.className = 'alert py-2 px-3 small mb-0 alert-' + type;
            logicIcon.className = 'bi ' + iconClass + ' me-1';
            logicMessage.textContent = msg;
        }

        if (!isDeleteMode) {
            fromSelect.addEventListener('change', function() { updateStandardInfo(true); });
            toSelect.addEventListener('change', function() { updateStandardInfo(true); });
            if (btnApplyStandard) {
                btnApplyStandard.addEventListener('click', function() {
                    if (currentStandard) {
                        distanceInput.value = currentStandard.dist;
                        durationInput.value = currentStandard.dur;
                        validateLogic();
                    }
                });
            }
            distanceInput.addEventListener('input', validateLogic);
            durationInput.addEventListener('input', validateLogic);
            routeForm.addEventListener('submit', function(e) {
                if (!validateLogic()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
            });
        }

        updateStandardInfo(false);
    })();
    </script>

</body>
</html>
