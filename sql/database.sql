-- =========================================================
-- HỆ THỐNG QUẢN LÝ ĐẶT VÉ XE KHÁCH (BUS TICKET MANAGEMENT SYSTEM)
-- Database Script: Microsoft SQL Server
-- Phân công: Thành viên 1 (Setup Project & Database Schema)
-- =========================================================

-- Tạo Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'BusTicketDB')
BEGIN
    CREATE DATABASE BusTicketDB;
END
GO

USE BusTicketDB;
GO

-- Xoá bảng cũ nếu đã tồn tại (theo thứ tự khóa ngoại)
IF OBJECT_ID(N'dbo.tickets', N'U') IS NOT NULL DROP TABLE dbo.tickets;
IF OBJECT_ID(N'dbo.trips', N'U') IS NOT NULL DROP TABLE dbo.trips;
IF OBJECT_ID(N'dbo.routes', N'U') IS NOT NULL DROP TABLE dbo.routes;
IF OBJECT_ID(N'dbo.customers', N'U') IS NOT NULL DROP TABLE dbo.customers;
IF OBJECT_ID(N'dbo.vehicles', N'U') IS NOT NULL DROP TABLE dbo.vehicles;
IF OBJECT_ID(N'dbo.locations', N'U') IS NOT NULL DROP TABLE dbo.locations;
IF OBJECT_ID(N'dbo.users', N'U') IS NOT NULL DROP TABLE dbo.users;
GO

-- 1. BẢNG USERS (Tài khoản người dùng & Quản trị)
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL DEFAULT 'user', -- 'admin' hoặc 'user'
    full_name NVARCHAR(100) NULL,
    email NVARCHAR(100) NULL,
    phone NVARCHAR(20) NULL,
    status NVARCHAR(30) NOT NULL DEFAULT N'Hoạt động', -- N'Hoạt động' hoặc N'Bị khóa'
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 2. BẢNG LOCATIONS (Địa điểm, Bến xe)
CREATE TABLE locations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    province NVARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 3. BẢNG VEHICLES (Phương tiện / Xe khách)
CREATE TABLE vehicles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    license_plate NVARCHAR(30) NOT NULL UNIQUE,
    total_seats INT NOT NULL DEFAULT 40,
    type NVARCHAR(50) NOT NULL, -- 'Ghế ngồi', 'Giường nằm', 'Limousine VIP'
    status NVARCHAR(50) NOT NULL DEFAULT N'Hoạt động', -- 'Hoạt động', 'Bảo dưỡng', 'Tạm ngưng'
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 4. BẢNG ROUTES (Tuyến đường)
CREATE TABLE routes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    from_location_id INT NOT NULL,
    to_location_id INT NOT NULL,
    distance DECIMAL(10, 2) NOT NULL, -- đơn vị: km
    duration INT NOT NULL, -- đơn vị: phút (hoặc giờ)
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_routes_from_location FOREIGN KEY (from_location_id) REFERENCES locations(id),
    CONSTRAINT FK_routes_to_location FOREIGN KEY (to_location_id) REFERENCES locations(id)
);
GO

-- 5. BẢNG TRIPS (Chuyến xe)
CREATE TABLE trips (
    id INT IDENTITY(1,1) PRIMARY KEY,
    route_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NULL,
    available_seats INT NOT NULL,
    price DECIMAL(18, 2) NOT NULL,
    status NVARCHAR(50) NOT NULL DEFAULT N'Sắp khởi hành', -- 'Sắp khởi hành', 'Đang chạy', 'Đã hoàn thành', 'Đã hủy'
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_trips_route FOREIGN KEY (route_id) REFERENCES routes(id),
    CONSTRAINT FK_trips_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id)
);
GO

-- 6. BẢNG CUSTOMERS (Thông tin khách hàng đặt vé)
CREATE TABLE customers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    email NVARCHAR(100) NULL,
    id_card NVARCHAR(30) NULL, -- CMND / CCCD
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 7. BẢNG TICKETS (Vé xe đã đặt)
CREATE TABLE tickets (
    id INT IDENTITY(1,1) PRIMARY KEY,
    trip_id INT NOT NULL,
    customer_id INT NOT NULL,
    seat_number NVARCHAR(20) NOT NULL, -- Ví dụ: 'A01', 'B05'
    booking_time DATETIME DEFAULT GETDATE(),
    status NVARCHAR(50) NOT NULL DEFAULT N'Đã thanh toán', -- 'Đã đặt', 'Đã thanh toán', 'Đã hủy'
    total_price DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_tickets_trip FOREIGN KEY (trip_id) REFERENCES trips(id),
    CONSTRAINT FK_tickets_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);
GO

-- =========================================================
-- DỮ LIỆU MẪU (SEED DATA CHO CẢ NHÓM CHẠY TEST NGAY)
-- =========================================================

-- Seed Users (Mật khẩu mặc định là 123456 hoặc admin123)
INSERT INTO users (username, password, role, full_name, email, phone, status) VALUES
('admin', 'admin123', 'admin', N'Quản Trị Viên Hệ Thống', 'admin@busticket.vn', '0901234567', N'Hoạt động'),
('user1', '123456', 'user', N'Nguyễn Văn An', 'an.nguyen@gmail.com', '0912345678', N'Hoạt động'),
('user2', '123456', 'user', N'Trần Thị Bích', 'bich.tran@gmail.com', '0987654321', N'Hoạt động'),
('user_locked', '123456', 'user', N'Lê Văn Boom', 'boom@gmail.com', '0999888777', N'Bị khóa');
GO

-- Seed Locations
INSERT INTO locations (name, province) VALUES
(N'Bến xe Miền Đông Mới', N'TP. Hồ Chí Minh'),
(N'Bến xe Miền Tây', N'TP. Hồ Chí Minh'),
(N'Bến xe Trung tâm Cần Thơ', N'Cần Thơ'),
(N'Bến xe Liên tỉnh Đà Lạt', N'Lâm Đồng'),
(N'Bến xe Phía Nam Nha Trang', N'Khánh Hòa'),
(N'Bến xe Trung tâm Đà Nẵng', N'Đà Nẵng'),
(N'Bến xe Mỹ Đình', N'Hà Nội');
GO

-- Seed Vehicles
INSERT INTO vehicles (license_plate, total_seats, type, status) VALUES
('51B-123.45', 40, N'Giường nằm', N'Hoạt động'),
('51B-678.90', 34, N'Limousine VIP', N'Hoạt động'),
('65B-112.23', 45, N'Ghế ngồi', N'Hoạt động'),
('49B-998.87', 34, N'Limousine VIP', N'Hoạt động'),
('79B-554.32', 40, N'Giường nằm', N'Bảo dưỡng');
GO

-- Seed Routes
-- Cần Thơ (3) -> TP.HCM (2) : ~165km, ~210 phút (3.5h)
-- TP.HCM (1) -> Đà Lạt (4) : ~305km, ~360 phút (6.0h)
-- TP.HCM (1) -> Nha Trang (5) : ~430km, ~480 phút (8.0h)
-- TP.HCM (1) -> Đà Nẵng (6) : ~960km, ~1020 phút (17h)
INSERT INTO routes (from_location_id, to_location_id, distance, duration) VALUES
(3, 2, 165.0, 210), -- Cần Thơ -> Bến xe Miền Tây (TP.HCM)
(2, 3, 165.0, 210), -- Bến xe Miền Tây (TP.HCM) -> Cần Thơ
(1, 4, 305.0, 360), -- Bến xe Miền Đông (TP.HCM) -> Đà Lạt
(4, 1, 305.0, 360), -- Đà Lạt -> Bến xe Miền Đông (TP.HCM)
(1, 5, 430.0, 480), -- Bến xe Miền Đông (TP.HCM) -> Nha Trang
(5, 1, 430.0, 480); -- Nha Trang -> Bến xe Miền Đông (TP.HCM)
GO

-- Seed Trips (Tạo các chuyến xe với giờ xuất bến và giờ đến dự kiến)
INSERT INTO trips (route_id, vehicle_id, departure_time, arrival_time, available_seats, price, status) VALUES
(1, 1, DATEADD(hour, 4, GETDATE()), DATEADD(minute, 210 + 240, GETDATE()), 38, 180000.00, N'Sắp khởi hành'),
(1, 2, DATEADD(hour, 8, GETDATE()), DATEADD(minute, 210 + 480, GETDATE()), 30, 250000.00, N'Sắp khởi hành'),
(3, 2, DATEADD(day, 1, GETDATE()), DATEADD(minute, 360, DATEADD(day, 1, GETDATE())), 32, 350000.00, N'Sắp khởi hành'),
(3, 4, DATEADD(day, 2, GETDATE()), DATEADD(minute, 360, DATEADD(day, 2, GETDATE())), 34, 380000.00, N'Sắp khởi hành'),
(5, 1, DATEADD(day, 1, GETDATE()), DATEADD(minute, 480, DATEADD(day, 1, GETDATE())), 39, 320000.00, N'Sắp khởi hành');
GO

-- Seed Customers
INSERT INTO customers (full_name, phone, email, id_card) VALUES
(N'Lê Hoàng Long', '0909112233', 'long.le@gmail.com', '079202001234'),
(N'Phạm Minh Tuấn', '0938445566', 'tuan.pm@gmail.com', '079201004321');
GO

-- Seed Tickets
INSERT INTO tickets (trip_id, customer_id, seat_number, booking_time, status, totalPrice) VALUES
(1, 1, 'A01', GETDATE(), N'Đã thanh toán', 180000.00),
(1, 1, 'A02', GETDATE(), N'Đã thanh toán', 180000.00),
(3, 2, 'B05', GETDATE(), N'Đã thanh toán', 350000.00);
GO

PRINT N'Khởi tạo Cơ sở dữ liệu BusTicketDB thành công!';
