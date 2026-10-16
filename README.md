# 🚌 Bus Ticket Booking Management System (Hệ Thống Đặt Vé Xe Khách)

> **Môn học**: Java Web (Servlet & JSP)  
> **Môi trường**: NetBeans IDE (Jakarta EE 10) + Microsoft SQL Server  
> **Repository**: [https://github.com/HauLT0704/Bus_Ticket_Booking_Management_System](https://github.com/HauLT0704/Bus_Ticket_Booking_Management_System)

---

## 👥 Bảng Phân Công Nhiệm Vụ 6 Thành Viên

| STT | Họ và tên | Phần việc phụ trách | Các file phụ trách chính |
| :---: | :--- | :--- | :--- |
| **1** | **Lâm Trung Hậu** | **Setup Project + Auth + Quản lý Địa điểm** | `AuthController`, `LocationController`, `UserDAO`, `LocationDAO`, `DBContext`, `User`, `Location`, `login.jsp`, `register.jsp`, `location-list.jsp`, `location-form.jsp` |
| **2** | **Nguyễn Tấn Phát** | **Quản lý Tuyến đường + Chuyến xe** | `RouteController`, `TripController`, `RouteDAO`, `TripDAO`, `Route`, `Trip`, `route-list.jsp`, `route-form.jsp`, `trip-list.jsp`, `trip-form.jsp` |
| **3** | **Phan Thanh Tu** | **Quản lý Xe khách + Khách hàng** | `VehicleController`, `CustomerController`, `VehicleDAO`, `CustomerDAO`, `Vehicle`, `Customer`, `vehicle-list.jsp`, `vehicle-form.jsp`, `customer-list.jsp`, `customer-form.jsp` |
| **4** | **Huỳnh Nhất Bảo** | **Tìm chuyến + Đặt vé + Sơ đồ ghế** | `BookingController`, `BookingDAO`, `Ticket`, `search.jsp`, `seat-map.jsp`, `booking.jsp` |
| **5** | **Hứa Hạo Danh** | **In vé + Báo cáo + Phân trang** | `ReportController`, `ReportDAO`, `PaginationUtil`, `print-ticket.jsp`, `trip-customer-list.jsp`, `report.jsp`, `pagination.jsp` |
| **6** | **Châu Thành Tâm** | **Trang chủ + Khung sườn + Ghép chuyến**| `TransferController`, `TransferDAO`, `header.jsp`, `footer.jsp`, `home.jsp`, `dashboard.jsp` |

---

## ⚡ Quy Trình Làm Việc Chung Cho Cả Nhóm (Git Workflow)

1. **Bước 1: Tải project về máy**:
   ```bash
   git clone https://github.com/HauLT0704/Bus_Ticket_Booking_Management_System.git
   ```
2. **Bước 2: Chạy Database**:
   - Mở file `sql/database.sql` trong **SQL Server Management Studio (SSMS)** và bấm **F5 (Execute)**.
   - Mở `src/main/java/db/DBContext.java` và chỉnh mật khẩu `sa` của máy bạn.
3. **Bước 3: Mở bằng NetBeans**:
   - Chọn **File** -> **Open Project** -> Chọn thư mục vừa clone về.
4. **Bước 4: Trước khi code (BẮT BUỘC)**:
   - Luôn kéo code mới nhất của các bạn khác về trước:
     ```bash
     git pull origin main
     ```
5. **Bước 5: Sau khi code xong phần của mình**:
   ```bash
   git add .
   git commit -m "feat: [Tên Bạn] hoàn thành chức năng XYZ"
   git push origin main
   ```