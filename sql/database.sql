-- =========================================================
-- HỆ THỐNG QUẢN LÝ ĐẶT VÉ XE KHÁCH (BUS TICKET MANAGEMENT SYSTEM)
-- Database Script: Microsoft SQL Server (PascalCase Columns)
-- Phân công: Thành viên 1 - Lâm Trung Hậu
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
IF OBJECT_ID(N'dbo.Tickets', N'U') IS NOT NULL DROP TABLE dbo.Tickets;
IF OBJECT_ID(N'dbo.Trips', N'U') IS NOT NULL DROP TABLE dbo.Trips;
IF OBJECT_ID(N'dbo.Routes', N'U') IS NOT NULL DROP TABLE dbo.Routes;
IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID(N'dbo.Vehicles', N'U') IS NOT NULL DROP TABLE dbo.Vehicles;
IF OBJECT_ID(N'dbo.Locations', N'U') IS NOT NULL DROP TABLE dbo.Locations;
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- 1. BẢNG Users (Tài khoản người dùng & Quản trị)
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL DEFAULT 'user', -- 'admin' hoặc 'user'
    FullName NVARCHAR(100) NULL,
    Email NVARCHAR(100) NULL,
    Phone NVARCHAR(20) NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT N'Hoạt động', -- N'Hoạt động' hoặc N'Bị khóa'
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. BẢNG Locations (Địa điểm, Bến xe)
CREATE TABLE Locations (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    Province NVARCHAR(100) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 3. BẢNG Vehicles (Phương tiện / Xe khách)
CREATE TABLE Vehicles (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    LicensePlate NVARCHAR(30) NOT NULL UNIQUE,
    TotalSeats INT NOT NULL DEFAULT 40,
    Type NVARCHAR(50) NOT NULL, -- 'Ghế ngồi', 'Giường nằm', 'Limousine VIP'
    Status NVARCHAR(50) NOT NULL DEFAULT N'Hoạt động', -- 'Hoạt động', 'Bảo dưỡng', 'Tạm ngưng'
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 4. BẢNG Routes (Tuyến đường)
CREATE TABLE Routes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FromLocationId INT NOT NULL,
    ToLocationId INT NOT NULL,
    Distance DECIMAL(10, 2) NOT NULL, -- đơn vị: km
    Duration INT NOT NULL, -- đơn vị: phút
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Routes_FromLocation FOREIGN KEY (FromLocationId) REFERENCES Locations(Id),
    CONSTRAINT FK_Routes_ToLocation FOREIGN KEY (ToLocationId) REFERENCES Locations(Id)
);
GO

-- 5. BẢNG Trips (Chuyến xe)
CREATE TABLE Trips (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    RouteId INT NOT NULL,
    VehicleId INT NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NULL,
    AvailableSeats INT NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT N'Sắp khởi hành', -- 'Sắp khởi hành', 'Đang chạy', 'Đã hoàn thành', 'Đã hủy'
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Trips_Route FOREIGN KEY (RouteId) REFERENCES Routes(Id),
    CONSTRAINT FK_Trips_Vehicle FOREIGN KEY (VehicleId) REFERENCES Vehicles(Id)
);
GO

-- 6. BẢNG Customers (Thông tin khách hàng)
CREATE TABLE Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NULL,
    IdCard NVARCHAR(30) NULL, -- CMND / CCCD
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 7. BẢNG Tickets (Vé xe đã đặt)
CREATE TABLE Tickets (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TripId INT NOT NULL,
    CustomerId INT NOT NULL,
    SeatNumber NVARCHAR(20) NOT NULL, -- Ví dụ: 'A01', 'B05'
    BookingTime DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL DEFAULT N'Đã thanh toán', -- 'Đã đặt', 'Đã thanh toán', 'Đã hủy'
    TotalPrice DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_Tickets_Trip FOREIGN KEY (TripId) REFERENCES Trips(Id),
    CONSTRAINT FK_Tickets_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);
GO

-- =========================================================
-- DỮ LIỆU MẪU (SEED DATA CHO CẢ NHÓM CHẠY TEST NGAY)
-- =========================================================

-- Seed Users (Mật khẩu mặc định là 123456 hoặc admin123)
INSERT INTO Users (Username, Password, Role, FullName, Email, Phone, Status) VALUES
('admin', 'admin123', 'admin', N'Quản Trị Viên Hệ Thống', 'admin@busticket.vn', '0901234567', N'Hoạt động'),
('user1', '123456', 'user', N'Nguyễn Văn An', 'an.nguyen@gmail.com', '0912345678', N'Hoạt động'),
('user2', '123456', 'user', N'Trần Thị Bích', 'bich.tran@gmail.com', '0987654321', N'Hoạt động'),
('user_locked', '123456', 'user', N'Lê Văn Boom', 'boom@gmail.com', '0999888777', N'Bị khóa');
GO

-- Seed Locations
INSERT INTO Locations (Name, Province) VALUES
(N'Bến xe Miền Đông Mới', N'TP. Hồ Chí Minh'),
(N'Bến xe Miền Tây', N'TP. Hồ Chí Minh'),
(N'Bến xe Trung tâm Cần Thơ', N'Cần Thơ'),
(N'Bến xe Liên tỉnh Đà Lạt', N'Lâm Đồng'),
(N'Bến xe Phía Nam Nha Trang', N'Khánh Hòa'),
(N'Bến xe Trung tâm Đà Nẵng', N'Đà Nẵng'),
(N'Bến xe Mỹ Đình', N'Hà Nội');
GO

-- Seed Vehicles
INSERT INTO Vehicles (LicensePlate, TotalSeats, Type, Status) VALUES
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
INSERT INTO Routes (FromLocationId, ToLocationId, Distance, Duration) VALUES
(3, 2, 165.0, 210), -- Cần Thơ -> Bến xe Miền Tây (TP.HCM)
(2, 3, 165.0, 210), -- Bến xe Miền Tây (TP.HCM) -> Cần Thơ
(1, 4, 305.0, 360), -- Bến xe Miền Đông (TP.HCM) -> Đà Lạt
(4, 1, 305.0, 360), -- Đà Lạt -> Bến xe Miền Đông (TP.HCM)
(1, 5, 430.0, 480), -- Bến xe Miền Đông (TP.HCM) -> Nha Trang
(5, 1, 430.0, 480); -- Nha Trang -> Bến xe Miền Đông (TP.HCM)
GO

-- Seed Trips (Tạo các chuyến xe với giờ xuất bến và giờ đến dự kiến)
INSERT INTO Trips (RouteId, VehicleId, DepartureTime, ArrivalTime, AvailableSeats, Price, Status) VALUES
(1, 1, DATEADD(hour, 4, GETDATE()), DATEADD(minute, 210 + 240, GETDATE()), 38, 180000.00, N'Sắp khởi hành'),
(1, 2, DATEADD(hour, 8, GETDATE()), DATEADD(minute, 210 + 480, GETDATE()), 30, 250000.00, N'Sắp khởi hành'),
(3, 2, DATEADD(day, 1, GETDATE()), DATEADD(minute, 360, DATEADD(day, 1, GETDATE())), 32, 350000.00, N'Sắp khởi hành'),
(3, 4, DATEADD(day, 2, GETDATE()), DATEADD(minute, 360, DATEADD(day, 2, GETDATE())), 34, 380000.00, N'Sắp khởi hành'),
(5, 1, DATEADD(day, 1, GETDATE()), DATEADD(minute, 480, DATEADD(day, 1, GETDATE())), 39, 320000.00, N'Sắp khởi hành');
GO

-- Seed Customers
INSERT INTO Customers (FullName, Phone, Email, IdCard) VALUES
(N'Lê Hoàng Long', '0909112233', 'long.le@gmail.com', '079202001234'),
(N'Phạm Minh Tuấn', '0938445566', 'tuan.pm@gmail.com', '079201004321');
GO

-- Seed Tickets
INSERT INTO Tickets (TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice) VALUES
(1, 1, 'A01', GETDATE(), N'Đã thanh toán', 180000.00),
(1, 1, 'A02', GETDATE(), N'Đã thanh toán', 180000.00),
(3, 2, 'B05', GETDATE(), N'Đã thanh toán', 350000.00);
GO

PRINT N'Khởi tạo Cơ sở dữ liệu BusTicketDB thành công (PascalCase Columns)!';