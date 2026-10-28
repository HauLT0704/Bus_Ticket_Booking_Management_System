# 📚 Giải thích toàn bộ Project Bus Ticket Booking

## MỤC LỤC
1. [Lý thuyết nền tảng](#lý-thuyết-nền-tảng)
2. [Kiến trúc MVC](#kiến-trúc-mvc)
3. [Cấu trúc thư mục](#cấu-trúc-thư-mục)
4. [Tầng Model](#tầng-model)
5. [Tầng DB](#tầng-db)
6. [Tầng DAO](#tầng-dao)
7. [Tầng Controller (Servlet)](#tầng-controller-servlet)
8. [Tầng View (JSP)](#tầng-view-jsp)
9. [Luồng chạy chi tiết từng chức năng](#luồng-chạy-chi-tiết)
10. [Phân tích code TV4](#phân-tích-code-tv4)

---

## Lý thuyết nền tảng

### Web Application hoạt động thế nào?

Khi bạn gõ `http://localhost:8080/BusTicket/home` lên trình duyệt:

```
Trình duyệt (Chrome)               Server (Tomcat)
       |                                   |
       |  -- GET /home ----------------→  |
       |                                   |  Tomcat tìm Servlet xử lý /home
       |                                   |  → Chạy code Java
       |                                   |  → Tạo HTML
       |  ←-- HTML page ---------------   |
       |                                   |
Trình duyệt vẽ trang web
```

**HTTP Request** gồm:
- **Method**: `GET` (lấy dữ liệu/mở trang) hoặc `POST` (gửi form)
- **URL**: đường dẫn cụ thể
- **Parameters**: giá trị kèm theo (vd: `?from=CầnThơ&to=HCM`)

---

### Servlet là gì?

**Servlet** = class Java chạy trên server, nhận HTTP Request → xử lý → trả về HTTP Response.

> **Ví dụ**: Nhấn "Tìm chuyến" → Browser gửi `GET /search?from=CầnThơ&to=HCM` → `BookingController.java` nhận và xử lý.

Mỗi Servlet kế thừa `HttpServlet` và override 2 phương thức:
- **`doGet()`** — khi người dùng truy cập URL trực tiếp / nhấn link
- **`doPost()`** — khi người dùng submit form

```java
// Khai báo URL nào sẽ đến Servlet này:
@WebServlet(urlPatterns = {"/search", "/booking", "/booking/seats", "/booking/confirm"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        // Xử lý GET request
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // Xử lý POST (khi form submit)
    }
}
```

---

### JSP là gì?

**JSP (JavaServer Pages)** = file HTML có thể nhúng code Java. Tomcat dịch JSP thành Servlet, chạy Java, rồi trả về HTML thuần cho trình duyệt.

```jsp
<!-- search.jsp -->
<c:forEach items="${trips}" var="trip">
    <div>${trip.fromLocationName} → ${trip.toLocationName}</div>
    <div>Giá: <fmt:formatNumber value="${trip.price}" currencySymbol="₫"/></div>
</c:forEach>
```

`${trips}` là biến Servlet "gửi" sang JSP qua `request.setAttribute("trips", trips)`. JSP đọc ra và hiển thị HTML.

**Nguyên tắc**: Servlet không viết HTML. JSP không có logic phức tạp. → Đây là **MVC**.

---

### DAO là gì?

**DAO (Data Access Object)** = tầng chuyên viết SQL giao tiếp với database.

> **Tại sao tách riêng?** Nếu sau này đổi từ SQL Server sang MySQL, chỉ cần sửa DAO, không đụng Controller/JSP.

---

### Session là gì?

HTTP là "stateless" — server không nhớ bạn là ai giữa các request. **Session** giải quyết điều này:

```java
// Sau đăng nhập thành công → lưu user vào session:
HttpSession session = request.getSession();
session.setAttribute("currentUser", user);

// Ở trang khác → đọc ra:
User currentUser = (User) session.getAttribute("currentUser");
```

> Giống như khi đăng nhập Facebook, bạn không cần đăng nhập lại mỗi lần chuyển trang.

---

## Kiến trúc MVC

```
BROWSER (Chrome/Firefox)
    │ HTTP Request
    ▼
CONTROLLER (Servlet)
    ├── Nhận request từ browser
    ├── Gọi DAO để lấy/lưu dữ liệu
    ├── request.setAttribute() → truyền dữ liệu sang JSP
    └── forward → JSP  |  sendRedirect → URL mới
         │                       │
         ▼                       ▼
    VIEW (JSP)           BROWSER gửi request mới
    Hiển thị HTML
         │
         ▼
    DAO (SQL)
    Giao tiếp Database
         │
         ▼
    DATABASE (SQL Server - BusTicketDB)
    Users │ Locations │ Vehicles │ Routes │ Trips │ Tickets
```

**Quy tắc vàng**:
| Tầng | Được làm | Không được làm |
|---|---|---|
| Model | Lưu dữ liệu, getter/setter | SQL, HTML, logic nghiệp vụ |
| DAO | Viết SQL, CRUD database | HTML, điều hướng |
| Controller | Nhận request, gọi DAO, gọi JSP | Viết SQL, viết HTML |
| JSP | Hiển thị dữ liệu bằng EL/JSTL | Logic phức tạp, SQL |

---

## Cấu trúc thư mục

```
Bus_Ticket_Booking_Management_System/
├── src/main/java/
│   ├── Controller/                    ← Servlet
│   │   ├── AuthController.java        (TV1: Login/Register/Logout)
│   │   ├── HomeController.java        (TV6: Trang chủ)
│   │   ├── BookingController.java     (TV4: Tìm chuyến + Đặt vé)
│   │   ├── TripController.java        (TV2: Quản lý chuyến - Admin)
│   │   ├── VehicleController.java     (TV3: Quản lý xe - Admin)
│   │   ├── LocationController.java    (TV1: Quản lý địa điểm - Admin)
│   │   ├── RouteController.java       (TV2: Quản lý tuyến - Admin)
│   │   ├── TransferController.java    (TV6: Ghép chuyến)
│   │   ├── CustomerController.java    (TV5: Quản lý KH - Admin)
│   │   └── ReportController.java      (TV5: Báo cáo - Admin)
│   │
│   ├── dao/                           ← Data Access Object (chứa SQL)
│   │   ├── BookingDAO.java            (TV4: SQL đặt vé, tìm chuyến)
│   │   ├── UserDAO.java               (TV1: SQL Users)
│   │   ├── TripDAO.java               (TV2: SQL Trips)
│   │   ├── LocationDAO.java           (TV1: SQL Locations)
│   │   └── ...
│   │
│   ├── model/                         ← POJO (tương ứng bảng DB)
│   │   ├── User.java       → Bảng Users
│   │   ├── Location.java   → Bảng Locations
│   │   ├── Vehicle.java    → Bảng Vehicles
│   │   ├── Route.java      → Bảng Routes
│   │   ├── Trip.java       → Bảng Trips
│   │   ├── Customer.java   → Bảng Customers
│   │   ├── Ticket.java     → Bảng Tickets
│   │   └── TransferOption.java  → Object ghép chuyến (không có bảng)
│   │
│   └── db/
│       └── DBContext.java             ← Quản lý kết nối DB
│
└── src/main/webapp/WEB-INF/
    ├── user/
    │   ├── home.jsp        (Form tìm kiếm - TV6)
    │   ├── search.jsp      (Kết quả tìm chuyến - TV4)
    │   ├── seat-map.jsp    (Chọn ghế - TV4)
    │   ├── booking.jsp     (Xác nhận đặt vé - TV4)
    │   └── transfer.jsp    (Ghép chuyến - TV6)
    ├── admin/              (Các trang quản trị)
    └── common/
        ├── header.jsp      (Navbar dùng chung)
        └── footer.jsp
```

---

## Tầng Model

Model = POJO class, mỗi class = một bảng trong database.

### User.java

```java
public class User {
    // Thuộc tính = Cột trong bảng Users
    private int id;
    private String username;
    private String password;   // Đã băm MD5, không lưu plaintext
    private String role;       // "admin" hoặc "user"
    private String fullName;
    private String status;     // "Hoạt động" hoặc "Bị khóa"

    // Constructor để tạo object từ ResultSet
    public User(int id, String username, ...) { ... }

    // Getter/Setter: truy cập thuộc tính từ bên ngoài
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    // Method tiện ích
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }
}
```

### Trip.java — Model lồng nhau (Nested Object)

```java
public class Trip {
    private int id;
    private Timestamp departureTime;
    private int availableSeats;
    private double price;

    // Lồng object thay vì chỉ lưu ID số:
    private Route route;     // Thay vì "private int routeId;"
    private Vehicle vehicle; // Thay vì "private int vehicleId;"
}
```

> **Tại sao lồng object?** JSP có thể gọi `${trip.route.fromLocation.name}`. Dữ liệu đầy đủ được nạp vào object từ DAO, không cần query thêm.

---

## Tầng DB

### DBContext.java — "Cầu nối" đến SQL Server

```java
public class DBContext {
    private Connection conn;
    private final String DB_URL  = "jdbc:sqlserver://127.0.0.1:1433;databaseName=BusTicketDB;...";
    private final String DB_USER = "sa";
    private final String DB_PWD  = "123456";

    public DBContext() {
        // 1. Load driver JDBC của SQL Server
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        // 2. Mở kết nối thực sự đến DB
        this.conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
    }

    public Connection getConnection() {
        return conn; // Trả về connection đã mở
    }
}
```

Tất cả DAO đều **extends DBContext** để dùng `getConnection()`:

```java
public class UserDAO extends DBContext {    // Kế thừa DBContext
    public User checkLogin(...) {
        PreparedStatement ps = getConnection().prepareStatement(sql); // Dùng kết nối từ cha
    }
}
```

> **Tại sao dùng `PreparedStatement` thay vì `Statement`?**
> - **Bảo mật**: Ngăn SQL Injection. Nếu hacker nhập `username = "' OR '1'='1"`, PreparedStatement xử lý như chuỗi literal, không cho thực thi SQL độc.
> - **Hiệu năng**: SQL compile trước, chỉ thay tham số khi chạy.

---

## Tầng DAO

### UserDAO.java — Đăng nhập với mã hóa MD5

```java
public User checkLogin(String username, String password) {
    String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";

    PreparedStatement ps = getConnection().prepareStatement(sql);
    ps.setString(1, username);           // ? thứ nhất = username
    ps.setString(2, hashMd5(password));  // ? thứ hai = password đã băm MD5

    ResultSet rs = ps.executeQuery();    // Chạy SQL
    if (rs.next()) {                     // Nếu tìm thấy hàng kết quả
        return new User(
            rs.getInt("Id"),
            rs.getString("Username"),
            ...
        );
    }
    return null; // Không tìm thấy → login sai
}

private String hashMd5(String raw) {
    MessageDigest md = MessageDigest.getInstance("MD5");
    byte[] bytes = md.digest(raw.getBytes());  // Băm chuỗi → 128-bit
    StringBuilder sb = new StringBuilder();
    for (byte b : bytes) {
        sb.append(String.format("%02x", b));   // Đổi sang hex string
    }
    return sb.toString(); // "123456" → "e10adc3949ba59abbe56e057f20f883e"
}
```

> **Tại sao MD5?** Mật khẩu lưu trong DB phải được **băm** (không thể đọc ngược). Khi login: băm mật khẩu vừa nhập → so sánh với bản băm trong DB. MD5 đủ dùng cho học phần (thực tế nên dùng BCrypt).

---

### BookingDAO.java — Dynamic SQL khi tìm chuyến

```java
public List<Map<String, Object>> searchTrips(String from, String to, String date, int guests) {

    // Xây dựng SQL động (thêm điều kiện WHERE tùy input)
    StringBuilder sql = new StringBuilder(
        "SELECT t.Id, t.Price, t.DepartureTime, ... " +
        "FROM Trips t " +
        "JOIN Routes r ON t.RouteId = r.Id " +
        "JOIN Locations fl ON r.FromLocationId = fl.Id " +
        "JOIN Locations tl ON r.ToLocationId = tl.Id " +
        "JOIN Vehicles v ON t.VehicleId = v.Id " +
        "WHERE 1=1 "   // ← "1=1" luôn đúng, để dễ thêm AND phía sau
    );

    List<Object> params = new ArrayList<>();

    if (from != null && !from.isEmpty()) {
        sql.append(" AND fl.Name LIKE ? ");  // Tìm gần đúng bằng LIKE
        params.add("%" + from + "%");        // %Cần Thơ% = chứa chuỗi "Cần Thơ"
    }
    if (to != null && !to.isEmpty()) {
        sql.append(" AND tl.Name LIKE ? ");
        params.add("%" + to + "%");
    }
    if (date != null && !date.isEmpty()) {
        sql.append(" AND CONVERT(VARCHAR(10), t.DepartureTime, 120) = ? ");
        // CONVERT(120) đổi DATETIME về dạng "yyyy-MM-dd" để so sánh với "2026-10-28"
        params.add(date);
    }
    if (guests > 0) {
        sql.append(" AND t.AvailableSeats >= ? ");
        params.add(guests);
    }

    PreparedStatement ps = getConnection().prepareStatement(sql.toString());
    for (int i = 0; i < params.size(); i++) {
        ps.setObject(i + 1, params.get(i)); // Gán từng tham số ?
    }

    ResultSet rs = ps.executeQuery();

    // Chuyển ResultSet → List<Map> để JSP đọc
    List<Map<String, Object>> list = new ArrayList<>();
    while (rs.next()) {
        Map<String, Object> map = new HashMap<>();
        map.put("id",               rs.getInt("Id"));
        map.put("price",            rs.getDouble("Price"));
        map.put("departureTime",    rs.getTimestamp("DepartureTime"));
        map.put("fromLocationName", rs.getString("FromName"));
        map.put("toLocationName",   rs.getString("ToName"));
        map.put("vehiclePlate",     rs.getString("LicensePlate"));
        list.add(map);
    }
    return list;
}
```

> **Tại sao dùng `Map<String, Object>` thay vì tạo class riêng?** SQL JOIN nhiều bảng trả về nhiều cột khác nhau. Map linh hoạt hơn: JSP đọc bằng `${trip.price}`, `${trip.fromLocationName}`.

---

## Tầng Controller (Servlet)

### AuthController.java — Đăng nhập / Đăng xuất

```java
@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    private UserDAO userDao = new UserDAO(); // Tạo DAO 1 lần, dùng mãi

    // GET: Hiển thị trang login
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        String path = req.getServletPath(); // "/login" hoặc "/logout"

        if ("/login".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(req, resp);

        } else if ("/logout".equals(path)) {
            req.getSession().invalidate(); // Xóa toàn bộ session
            resp.sendRedirect("/login?msg=logged_out");
        }
    }

    // POST: Xử lý khi form đăng nhập submit
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        String username = req.getParameter("username"); // Lấy từ <input name="username">
        String password = req.getParameter("password");

        User user = userDao.checkLogin(username, password); // Hỏi DB

        if (user != null) {
            if ("Bị khóa".equals(user.getStatus())) {
                req.setAttribute("errorMessage", "Tài khoản bị khóa!");
                req.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(req, resp);
                return; // Dừng lại, không chạy tiếp
            }
            // Đăng nhập thành công → lưu vào Session
            req.getSession().setAttribute("currentUser", user);
            // Điều hướng theo role
            resp.sendRedirect(user.isAdmin() ? "/admin/location" : "/home");

        } else {
            req.setAttribute("errorMessage", "Sai tên đăng nhập hoặc mật khẩu!");
            req.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(req, resp);
        }
    }
}
```

### `forward` vs `sendRedirect` — Khác nhau quan trọng!

| `forward(req, resp)` | `sendRedirect(url)` |
|---|---|
| Server chuyển tiếp nội bộ | Server bảo browser "gọi URL mới" |
| URL trên browser **không đổi** | URL trên browser **thay đổi** |
| Dùng khi muốn truyền dữ liệu sang JSP | Dùng sau POST để tránh submit lại |
| Giữ nguyên `request` gốc | Tạo `request` mới hoàn toàn |

---

## Tầng View (JSP)

### Cú pháp JSP quan trọng

```jsp
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"  %>
<%@ include file="/WEB-INF/common/header.jsp" %>

<!-- EL (Expression Language): đọc biến từ Servlet -->
<p>${selectedFrom}</p>                          <!-- = request.getAttribute("selectedFrom") -->
<p>${sessionScope.currentUser.fullName}</p>    <!-- = session.getAttribute("currentUser").getFullName() -->

<!-- JSTL: vòng lặp -->
<c:forEach items="${trips}" var="trip">
    <p>${trip.fromLocationName} → ${trip.toLocationName}</p>
    <p><fmt:formatNumber value="${trip.price}" type="currency" currencySymbol="₫"/></p>
</c:forEach>

<!-- JSTL: điều kiện -->
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger">${errorMessage}</div>
</c:if>

<c:choose>
    <c:when test="${trip.availableSeats > 0}">
        <a href="/booking/seats?tripId=${trip.id}">Đặt vé</a>
    </c:when>
    <c:otherwise>
        <button disabled>Hết vé</button>
    </c:otherwise>
</c:choose>
```

> **Tại sao `contentType="text/html"` (không có `; charset=UTF-8`)?** Vì `header.jsp` khai báo `contentType="text/html"`. Khi JSP dùng `<%@ include %>` (include tĩnh), hai file gộp làm một — nếu `contentType` khác nhau (vd: `text/html` vs `text/html; charset=UTF-8`) → Tomcat báo lỗi 500. Phải đồng bộ giá trị.

---

## Luồng chạy chi tiết

### Luồng 1: Đăng nhập

```
1. Browser: GET /login
   └─→ AuthController.doGet() → forward login.jsp

2. Nhập tài khoản → Submit
   Browser: POST /login (body: username=hau&password=123456)

3. AuthController.doPost():
   a. getParameter("username") → "hau"
   b. getParameter("password") → "123456"
   c. userDao.checkLogin("hau", "123456")

4. UserDAO.checkLogin():
   a. hashMd5("123456") → "e10adc3949ba59abbe56e057f20f883e"
   b. SQL: SELECT * FROM Users WHERE Username='hau' AND Password='e10adc...'
   c. rs.next() có kết quả → tạo object User, trả về
   d. Không có kết quả → return null

5. Quay lại AuthController:
   ├── user == null → setAttribute("errorMessage") + forward login.jsp
   ├── "Bị khóa" → forward login.jsp với thông báo
   └── Thành công:
       session.setAttribute("currentUser", user)
       ├── admin → sendRedirect("/admin/location")
       └── user  → sendRedirect("/home")
```

---

### Luồng 2: Trang chủ (/home)

```
1. Browser: GET /home

2. HomeController.doGet():
   a. getSession(false) → không tạo session mới nếu chưa có
   b. session == null hoặc "currentUser" == null → sendRedirect("/login")
   c. user.isAdmin() → sendRedirect("/admin/location")
   d. User bình thường:
      - locationDAO.getAll() → List<Location> 14 tỉnh
      - setAttribute("locations", list)
      - forward home.jsp

3. home.jsp:
   - Dropdown điểm đi/đến từ ${locations}
   - Người dùng chọn Bạc Liêu → An Giang, ngày 28/10
   - Nhấn "Search Trips" → JS tạo URL: GET /search?from=Bạc+Liêu&to=An+Giang&date=2026-10-28&guests=1
```

---

### Luồng 3: Tìm kiếm chuyến (/search) — Phần của TV4

```
1. Browser: GET /search?from=Bạc+Liêu&to=An+Giang&date=2026-10-28&guests=1

2. BookingController.doGet():
   - path = "/search" → gọi handleSearchTrips()

3. handleSearchTrips():
   a. from = "Bạc Liêu", to = "An Giang", date = "2026-10-28", guests = 1

   b. locationDAO.getAll() → lấy 14 tỉnh
      normalizeLocation("Bạc Liêu", list) → "Bạc Liêu" (giữ nguyên)
      normalizeLocation("An Giang", list)  → "An Giang"

   c. findLocationId("Bạc Liêu") → ID = 6
      findLocationId("An Giang")  → ID = 4

   d. TripDAO.searchTrips(6, 4, "2026-10-28", 1):
      SQL: SELECT t.*, v.LicensePlate, fl.Name AS FromName, tl.Name AS ToName
           FROM Trips t
           JOIN Vehicles v ON t.VehicleId = v.Id
           JOIN Routes r ON t.RouteId = r.Id
           JOIN Locations fl ON r.FromLocationId = fl.Id
           JOIN Locations tl ON r.ToLocationId = tl.Id
           WHERE r.FromLocationId = 6 AND r.ToLocationId = 4
             AND CAST(t.DepartureTime AS DATE) = '2026-10-28'
             AND t.AvailableSeats >= 1
             AND t.Status = 'Active'
      → Trả về List<Trip> (nested Route, Vehicle)
      → Chuyển sang List<Map> cho JSP

   e. Nếu danh sách rỗng → BookingDAO.searchTrips("Bạc Liêu", "An Giang", ...)
      (dùng LIKE để tìm linh hoạt hơn, bỏ điều kiện Status)

   f. Vẫn rỗng → searchTransferTrips():
      Tìm cặp chuyến: Bạc Liêu → Điểm X, và Điểm X → An Giang
      Điều kiện: chờ 30 phút đến 8 tiếng giữa 2 chặng

   g. setAttribute("trips", trips)
      setAttribute("selectedFrom", "Bạc Liêu")  ← Để form giữ lại giá trị đã chọn
      setAttribute("selectedDate", "2026-10-28")
      forward search.jsp

4. search.jsp:
   - Hiển thị lại form (với giá trị đã chọn từ ${selectedFrom}, ${selectedTo}...)
   - <c:forEach items="${trips}" var="trip"> → vòng lặp từng chuyến
   - Nút "Chọn Chuyến" → href="/booking/seats?tripId=${trip.id}"
   - Nếu trips rỗng nhưng transferTrips không rỗng → hiển thị gợi ý ghép chuyến
```

---

### Luồng 4: Chọn ghế và đặt vé — Phần của TV4

```
Step 1: GET /booking/seats?tripId=5
   BookingController → handleSeatMap():
   - bookingDAO.getTripDetails(5) → Map {id, price, departureTime, fromLocationName, ...}
   - bookingDAO.getBookedSeats(5) → ["A01", "A02", "B05"] (ghế đã bị đặt)
   - setAttribute("trip", trip)
   - setAttribute("bookedSeats", bookedSeats)
   - forward seat-map.jsp

Step 2: seat-map.jsp hiển thị:
   - Sơ đồ ghế 2 tầng (A01-A18, B01-B18):
     <c:forEach var="i" begin="1" end="18">
         <c:set var="seatCode" value="${i < 10 ? 'A0' : 'A'}${i}"/>
         <c:set var="isBooked" value="${bookedSeats.contains(seatCode)}"/>
         <div class="${isBooked ? 'seat-booked' : 'seat-available'}" onclick="toggleSeat(this)">
             ${seatCode}
         </div>
     </c:forEach>
   - JavaScript tính tổng tiền realtime: seats.length × price
   - Form nhập: fullName (bắt buộc), phone (bắt buộc), email, idCard
   - Submit → POST /booking/confirm

Step 3: POST /booking/confirm
   Browser gửi body: tripId=5&selectedSeats=A01,A03&fullName=Nguyễn Văn A&phone=0912345678

   BookingController → handleBookingConfirm():
   a. setCharacterEncoding("UTF-8") ← PHẢI trước getParameter() để tiếng Việt không bị vỡ
   b. Validate: tripId, selectedSeats, fullName, phone không được null/rỗng
   c. getTripDetails(5) → lấy price
   d. Tách "A01,A03" → ["A01", "A03"]
   e. getBookedSeats(5) → kiểm tra ghế chưa bị người khác đặt cùng lúc
   f. getOrCreateCustomer("Nguyễn Văn A", "0912345678", email, idCard):
      SELECT Id FROM Customers WHERE Phone = '0912345678'
      - Tìm thấy → trả về customerId cũ (tránh tạo khách hàng trùng)
      - Không thấy → INSERT INTO Customers ... → trả về ID mới (GENERATED_KEYS)
   g. Với mỗi ghế trong ["A01", "A03"]:
      Ticket t = new Ticket(tripId=5, customerId=10, "A01", "Đã thanh toán", 230000.0)
      bookingDAO.insert(t) → INSERT INTO Tickets ...
                           → lấy GENERATED_KEYS → t.setId(101)
      ticketIds.add("101")
   h. updateAvailableSeats(5, 2):
      UPDATE Trips SET AvailableSeats = AvailableSeats - 2
      WHERE Id = 5 AND AvailableSeats >= 2  ← Điều kiện an toàn tránh âm
   i. sendRedirect("/booking?action=success&tripId=5&customerId=10&tickets=101,102")
      ← REDIRECT để F5 không submit lại form!

Step 4: GET /booking?action=success&tripId=5&customerId=10&tickets=101,102
   handleBookingSuccess():
   - Tách "101,102" → [101, 102]
   - bookingDAO.getById(101) → Ticket object
   - bookingDAO.getById(102) → Ticket object
   - totalAmount = 230000 + 230000 = 460000
   - setAttribute("trip", trip), setAttribute("tickets", list), setAttribute("totalAmount", ...)
   - forward booking.jsp

Step 5: booking.jsp hiển thị:
   - Phiếu vé điện tử đẹp với thông tin chuyến xe
   - Bảng: Mã vé (#VE101), Số ghế (A01), Trạng thái (Đã thanh toán), Giá (230.000 ₫)
   - Tổng: 460.000 ₫
   - Nút "In Phiếu Vé" → window.print() (in trang hiện tại)
```

---

## Phân tích code TV4

### Tại sao dùng `getServletPath()` để phân luồng?

```java
String path = request.getServletPath();
// → "/search" hoặc "/booking/seats" hoặc "/booking/confirm"

if ("/booking/seats".equals(path)) {
    handleSeatMap(request, response);
} else if ("/search".equals(path)) {
    handleSearchTrips(request, response);
}
```

Một Servlet lắng nghe nhiều URL. `getServletPath()` trả về phần URL đã match với `@WebServlet`. Từ đó phân luồng đến đúng method xử lý.

---

### Tại sao `sendRedirect` sau khi đặt vé?

```java
response.sendRedirect("/booking?action=success&tripId=" + tripId + ...);
```

Sau `doPost()` thành công, nếu dùng `forward` → URL vẫn là `/booking/confirm` → người dùng F5 → form submit lại lần 2 → đặt vé 2 lần!

`sendRedirect` bảo browser gọi URL mới (`GET /booking?action=success...`) → F5 chỉ lặp lại GET, an toàn.

---

### Tại sao `RETURN_GENERATED_KEYS`?

```java
PreparedStatement ps = getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
ps.executeUpdate();

ResultSet rs = ps.getGeneratedKeys();
if (rs.next()) {
    t.setId(rs.getInt(1)); // Lấy ID tự tăng vừa được tạo
}
```

Bảng Tickets dùng `Id INT IDENTITY(1,1)` (SQL Server tự sinh ID). Sau INSERT, cần biết ID mới là bao nhiêu để truyền sang trang thành công. `RETURN_GENERATED_KEYS` yêu cầu JDBC trả về giá trị đó.

---

### Tại sao SQL ghép chuyến phức tạp?

```sql
SELECT t1.Id, t2.Id, (t1.Price + t2.Price) AS TotalPrice
FROM Trips t1                                              -- Chặng 1
JOIN Routes r1 ON t1.RouteId = r1.Id
JOIN Locations fl1 ON r1.FromLocationId = fl1.Id           -- Điểm đi của chặng 1
JOIN Locations tl1 ON r1.ToLocationId = tl1.Id             -- Điểm trung gian
JOIN Routes r2 ON tl1.Id = r2.FromLocationId               -- Trung gian = điểm đi chặng 2!
JOIN Trips t2 ON t2.RouteId = r2.Id                        -- Chặng 2
JOIN Locations tl2 ON r2.ToLocationId = tl2.Id             -- Điểm đến cuối
WHERE fl1.Name LIKE ?                                      -- Điểm đi đầu
  AND tl2.Name LIKE ?                                      -- Điểm đến cuối
  AND t2.DepartureTime >= DATEADD(MINUTE, 30, t1.ArrivalTime)  -- Chờ ít nhất 30 phút
  AND t2.DepartureTime <= DATEADD(HOUR, 8, t1.ArrivalTime)     -- Không chờ quá 8 tiếng
```

SQL tự JOIN bảng Trips với chính nó (t1 và t2), dùng Locations làm cầu nối. Điều kiện thời gian đảm bảo chặng 2 phải khởi hành sau chặng 1 đủ lâu để khách kịp trung chuyển.

---

### Tại sao cần `normalizeLocation()`?

Hai nơi gọi `/search` nhưng format khác nhau:
- **home.jsp** (TV6) gửi `from=6` (ID số từ `<option value="6">`)
- **search.jsp** (TV4) gửi `from=Bạc Liêu` (tên từ `<option value="Bạc Liêu">`)

Hàm `normalizeLocation()` xử lý cả hai trường hợp để luôn trả về tên chuẩn:

```java
private String normalizeLocation(String loc, List<Location> list) {
    // Trường hợp 1: Là ID số ("6") → tìm trong list → trả về "Bạc Liêu"
    try {
        int id = Integer.parseInt(loc.trim());
        for (Location l : list) {
            if (l.getId() == id) return l.getName();
        }
    } catch (NumberFormatException ignored) { }

    // Trường hợp 2: Viết tắt
    if ("TP.HCM".equalsIgnoreCase(loc)) return "TP. Hồ Chí Minh";

    // Trường hợp 3: Đã là tên đầy đủ → giữ nguyên
    return loc.trim();
}
```

---

## Tóm tắt luồng request tổng quát

```
Browser
  │ HTTP Request (GET/POST)
  ▼
Tomcat → @WebServlet(urlPatterns=...)
  ▼
Controller (Servlet)
  ├── getParameter()          ← Đọc input từ browser
  ├── Validate dữ liệu
  ├── Gọi DAO.method()        ← Lấy/lưu dữ liệu DB
  ├── setAttribute()          ← Truyền data sang JSP
  │
  ├── forward → JSP
  │       ├── ${variable}     ← Đọc data từ Controller
  │       ├── <c:forEach>     ← Vòng lặp
  │       └── Render HTML → Browser
  │
  └── sendRedirect → Browser gửi request GET mới → lặp lại từ đầu
```
