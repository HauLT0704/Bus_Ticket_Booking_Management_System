<%-- 
    Document   : register
    Created on : Oct 16, 2026, 10:01:25 PM
    Author     : Nam
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light d-flex align-items-center vh-100">
        <div class="container" style="max-width: 480px;">
            <div class="card shadow-sm p-4 border-0 rounded-4">
                <h3 class="text-center fw-bold text-primary mb-3">Sign up</h3>
                <%
                    if (request.getAttribute("errorMessage") != null) {%>
                <div class="aler aler-danger py-2 small"><%= request.getAttribute("errorMessage")%></div>
                <%}
                %>

                <form action="${pageContext.request.contextPath}/register" method="POST">
                    <div class="mb-2">
                        <label class="form-label small fw-bold">Username *</label>
                        <input type="text" name="username" class="form-control" placeholder="username" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label small fw-bold">FullName *</label>
                        <input type="text" name="fullName" class="form-control" placeholder="Lam Trung Hau" required> 
                    </div>

                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <label class="form-label small fw-bold">Phone *</label>
                            <input type="tel" name="phone" class="form-control" placeholder="0901234567" required> 
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">Email</label>
                        <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold">Password *</label>
                            <input type="password" name="password" class="form-control">
                        </div>
                    </div>

                    <div class="col-6 mb-3">
                        <label class="form-label small fw-bold">Confirm Password *</label>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                        Submit form
                    </button>

                </form>

                <div class="text-center mt-3 small">
                    Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a>
                </div>

            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    </body>
</html>
