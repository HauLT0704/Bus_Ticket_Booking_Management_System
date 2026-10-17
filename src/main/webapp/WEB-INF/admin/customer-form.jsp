<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${customer != null ? "Cập Nhật Khách Hàng" : "Thêm Khách Hàng Mới"}</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; padding: 40px 20px; }
        .card { max-width: 550px; margin: auto; background: white; padding: 35px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); }
        h2 { color: #2c3e50; text-align: center; margin-top: 0; margin-bottom: 25px; font-size: 22px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-weight: 600; color: #495057; margin-bottom: 6px; font-size: 14px; }
        input[type="text"], input[type="email"] { width: 100%; padding: 10px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; box-sizing: border-box; transition: border-color 0.2s; }
        input[type="text"]:focus, input[type="email"]:focus { border-color: #0d6efd; outline: none; }
        .btn-group { display: flex; justify-content: space-between; align-items: center; margin-top: 25px; }
        .btn-submit { background-color: #0d6efd; color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 14px; transition: background-color 0.2s; }
        .btn-submit:hover { background-color: #0b5ed7; }
        .btn-back { background-color: #6c757d; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; font-weight: 600; font-size: 14px; transition: background-color 0.2s; }
        .btn-back:hover { background-color: #5c636a; }
    </style>
</head>
<body>
    <div class="card">
        <h2>${customer != null ? "Cập Nhật Thông Tin Khách Hàng" : "Thêm Khách Hàng Mới"}</h2>
        
        <form action="customer" method="POST">
            <input type="hidden" name="action" value="${customer != null ? 'update' : 'insert'}">
            <c:if test="${customer != null}">
                <input type="hidden" name="id" value="${customer.id}">
            </c:if>

            <div class="form-group">
                <label>Họ và Tên:</label>
                <input type="text" name="fullName" value="${customer != null ? customer.fullName : ''}" required placeholder="Nhập họ và tên...">
            </div>

            <div class="form-group">
                <label>Số Điện Thoại:</label>
                <input type="text" name="phone" value="${customer != null ? customer.phone : ''}" required placeholder="Nhập số điện thoại...">
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" value="${customer != null ? customer.email : ''}" placeholder="Nhập địa chỉ email...">
            </div>

            <div class="form-group">
                <label>CCCD / ID Card:</label>
                <input type="text" name="idCard" value="${customer != null ? customer.idCard : ''}" placeholder="Nhập số CCCD/CMND...">
            </div>

            <div class="btn-group">
                <a href="customer" class="btn-back">Quay lại</a>
                <button type="submit" class="btn-submit">Lưu Thông Tin</button>
            </div>
        </form>
    </div>
</body>
</html>