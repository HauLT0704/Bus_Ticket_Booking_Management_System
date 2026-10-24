<%-- 
    Document   : login
    Created on : Oct 16, 2026, 10:01:03 PM
    Author     : Lâm Trung Hậu 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light d-flex align-items-center vh-100">
        <div class="container" style="max-width: 400px;">
            <div class="card shadow-sm p-4 border-0 rounded-4">
                <h3 class="text-center fw-bold text-primary mb-3">Login</h3>

                <% if (request.getAttribute("errorMessage") != null) {%>
                <div class="alert alert-danger py-2 small"><%= request.getAttribute("errorMessage")%>    
                </div>
                <% }
                %>

                <% if (request.getAttribute("successMessage") != null) {%>
                <div class="aler aler-success py-2 small"><%= request.getAttribute("successMessage")%></div>
                <%}
                %>

                <% if ("logged_out".equals(request.getParameter("msg"))) {%>
                <div class="alert aler-info py-2 small">Log out Success</div>
                <%}
                %>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">UserName</label>
                        <input type="text" id="username" name="username" class="form-control" required autofocus>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">PassWord</label>
                        <input type="password" id="password" name="password" class="form-control" required=>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                        Login
                    </button>
                </form>

                <div class="text-center mt-3 small">
                    Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign up now</a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    </body>
</html>
