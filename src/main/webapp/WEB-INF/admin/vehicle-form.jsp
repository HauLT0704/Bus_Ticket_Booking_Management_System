<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${vehicle != null ? "Cập Nhật Xe Khách" : "Thêm Xe Mới"}</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; padding: 40px 20px; }
        .card { max-width: 550px; margin: auto; background: white; padding: 35px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); }
        h2 { color: #2c3e50; text-align: center; margin-top: 0; margin-bottom: 25px; font-size: 22px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-weight: 600; color: #495057; margin-bottom: 6px; font-size: 14px; }
        input[type="text"], input[type="number"], select { width: 100%; padding: 10px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; box-sizing: border-box; transition: border-color 0.2s; }
        input[type="text"]:focus, input[type="number"]:focus, select:focus { border-color: #0d6efd; outline: none; }
        .btn-group { display: flex; justify-content: space-between; align-items: center; margin-top: 25px; }
        .btn-submit { background-color: #0d6efd; color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 14px; transition: background-color 0.2s; }
        .btn-submit:hover { background-color: #0b5ed7; }
        .btn-back { background-color: #6c757d; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; font-weight: 600; font-size: 14px; transition: background-color 0.2s; }
        .btn-back:hover { background-color: #5c636a; }
    </style>
</head>
<body>
    <div class="card">
        <h2>${vehicle != null ? "Cập Nhật Thông Tin Xe" : "Thêm Xe Khách Mới"}</h2>
        
        <form action="vehicle" method="POST">
            <input type="hidden" name="action" value="${vehicle != null ? 'update' : 'insert'}">
            <c:if test="${vehicle != null}">
                <input type="hidden" name="id" value="${vehicle.id}">
            </c:if>

            <div class="form-group">
                <label>Biển Số Xe:</label>
                <input type="text" name="licensePlate" value="${vehicle != null ? vehicle.licensePlate : ''}" required placeholder="Ví dụ: 51B-123.45">
            </div>

            <div class="form-group">
                <label>Số Ghế:</label>
                <input type="number" name="totalSeats" value="${vehicle != null ? vehicle.totalSeats : '40'}" required>
            </div>

            <div class="form-group">
                <label>Loại Xe:</label>
                <select name="type">
                    <option value="Giường nằm" ${vehicle != null && vehicle.type == 'Giường nằm' ? 'selected' : ''}>Giường nằm</option>
                    <option value="Limousine VIP" ${vehicle != null && vehicle.type == 'Limousine VIP' ? 'selected' : ''}>Limousine VIP</option>
                    <option value="Ghế ngồi" ${vehicle != null && vehicle.type == 'Ghế ngồi' ? 'selected' : ''}>Ghế ngồi</option>
                </select>
            </div>

            <div class="form-group">
                <label>Trạng Thái:</label>
                <select name="status">
                    <option value="Hoạt động" ${vehicle != null && vehicle.status == 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
                    <option value="Bảo dưỡng" ${vehicle != null && vehicle.status == 'Bảo dưỡng' ? 'selected' : ''}>Bảo dưỡng</option>
                    <option value="Tạm ngưng" ${vehicle != null && vehicle.status == 'Tạm ngưng' ? 'selected' : ''}>Tạm ngưng</option>
                </select>
            </div>

            <div class="btn-group">
                <a href="vehicle" class="btn-back">Quay lại</a>
                <button type="submit" class="btn-submit">Lưu Thông Tin</button>
            </div>
        </form>
    </div>
</body>
</html>