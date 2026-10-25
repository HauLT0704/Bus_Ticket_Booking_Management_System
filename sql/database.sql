-- =========================================================
-- HỆ THỐNG QUẢN LÝ ĐẶT VÉ XE KHÁCH (BUS TICKET MANAGEMENT SYSTEM)
-- Dữ liệu: Chuyên tuyến MIỀN TÂY (Đồng bằng Sông Cửu Long) & SÀI GÒN
-- Tinh giản: Bảng Locations chỉ lưu Tên Tỉnh / Thành phố (Bỏ cột Province)
-- Mật khẩu Users: Đã băm chuẩn MD5 100%
-- =========================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'BusTicketDB')
BEGIN
    CREATE DATABASE BusTicketDB;
END
GO

USE BusTicketDB;
GO

-- Xoá các bảng cũ theo thứ tự ràng buộc khóa ngoại
IF OBJECT_ID(N'dbo.Tickets', N'U') IS NOT NULL DROP TABLE dbo.Tickets;
IF OBJECT_ID(N'dbo.Trips', N'U') IS NOT NULL DROP TABLE dbo.Trips;
IF OBJECT_ID(N'dbo.Routes', N'U') IS NOT NULL DROP TABLE dbo.Routes;
IF OBJECT_ID(N'dbo.Customers', N'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID(N'dbo.Vehicles', N'U') IS NOT NULL DROP TABLE dbo.Vehicles;
IF OBJECT_ID(N'dbo.Locations', N'U') IS NOT NULL DROP TABLE dbo.Locations;
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- 1. BẢNG Users (Mật khẩu băm MD5 sẵn)
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL DEFAULT 'user', -- 'admin' hoặc 'user'
    FullName NVARCHAR(100) NULL,
    Email NVARCHAR(100) NULL,
    Phone NVARCHAR(20) NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT N'Hoạt động', -- 'Hoạt động' hoặc 'Bị khóa'
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. BẢNG Locations (Chỉ lưu Tên Tỉnh / Thành phố)
CREATE TABLE Locations (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE, -- Tên Tỉnh / Thành phố
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 3. BẢNG Vehicles (Phương tiện / Xe khách các tỉnh Miền Tây)
CREATE TABLE Vehicles (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    LicensePlate NVARCHAR(30) NOT NULL UNIQUE,
    TotalSeats INT NOT NULL DEFAULT 40,
    Type NVARCHAR(50) NOT NULL, -- 'Limousine VIP', 'Giường nằm', 'Ghế ngồi'
    Status NVARCHAR(50) NOT NULL DEFAULT N'Hoạt động',
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 4. BẢNG Routes (Tuyến đường giữa các Tỉnh)
CREATE TABLE Routes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FromLocationId INT NOT NULL,
    ToLocationId INT NOT NULL,
    Distance DECIMAL(10, 2) NOT NULL, -- km
    Duration INT NOT NULL, -- phút
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
    Status NVARCHAR(50) NOT NULL DEFAULT N'Sắp khởi hành',
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Trips_Route FOREIGN KEY (RouteId) REFERENCES Routes(Id),
    CONSTRAINT FK_Trips_Vehicle FOREIGN KEY (VehicleId) REFERENCES Vehicles(Id)
);
GO

-- 6. BẢNG Customers (Khách hàng)
CREATE TABLE Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NULL,
    IdCard NVARCHAR(30) NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 7. BẢNG Tickets (Vé xe)
CREATE TABLE Tickets (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TripId INT NOT NULL,
    CustomerId INT NOT NULL,
    SeatNumber NVARCHAR(20) NOT NULL,
    BookingTime DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL DEFAULT N'Đã thanh toán',
    TotalPrice DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_Tickets_Trip FOREIGN KEY (TripId) REFERENCES Trips(Id),
    CONSTRAINT FK_Tickets_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);
GO

-- =========================================================
-- DỮ LIỆU SEED (CHUYÊN TUYẾN MIỀN TÂY & SÀI GÒN)
-- =========================================================

-- 1. Users (Mật khẩu đã băm MD5 chuẩn 100%: admin123 và 123456)
INSERT INTO Users (Username, Password, Role, FullName, Email, Phone, Status) VALUES
('admin', '0192023a7bbd73250516f069df18b500', 'admin', N'Quản Trị Viên Hệ Thống', 'admin@busticket.vn', '0901234567', N'Hoạt động'),
('user1', 'e10adc3949ba59abbe56e057f20f883e', 'user', N'Nguyễn Văn An', 'an.nguyen@gmail.com', '0912345678', N'Hoạt động'),
('user2', 'e10adc3949ba59abbe56e057f20f883e', 'user', N'Trần Thị Bích', 'bich.tran@gmail.com', '0987654321', N'Hoạt động'),
('hau', 'e10adc3949ba59abbe56e057f20f883e', 'user', N'Lâm Trung Hậu', 'haultce200918@gmail.com', '0346793125', N'Hoạt động'),
('user_locked', 'e10adc3949ba59abbe56e057f20f883e', 'user', N'Lê Văn Boom', 'boom@gmail.com', '0999888777', N'Bị khóa');
GO

-- 2. Locations (14 Tỉnh / Thành phố: TP.HCM + 13 Tỉnh Miền Tây)
INSERT INTO Locations (Name) VALUES
(N'TP. Hồ Chí Minh'), -- ID 1
(N'Cần Thơ'),         -- ID 2
(N'Kiên Giang'),      -- ID 3
(N'An Giang'),        -- ID 4
(N'Cà Mau'),          -- ID 5
(N'Bạc Liêu'),        -- ID 6
(N'Sóc Trăng'),       -- ID 7
(N'Đồng Tháp'),       -- ID 8
(N'Bến Tre'),         -- ID 9
(N'Vĩnh Long'),       -- ID 10
(N'Tiền Giang'),      -- ID 11
(N'Trà Vinh'),        -- ID 12
(N'Hậu Giang'),       -- ID 13
(N'Long An');         -- ID 14
GO

-- 3. Vehicles (Đội xe khách biển số Miền Tây & Sài Gòn)
INSERT INTO Vehicles (LicensePlate, TotalSeats, Type, Status) VALUES
('51B-222.11', 22, N'Limousine VIP', N'Hoạt động'), -- 1 (Sài Gòn)
('51B-888.99', 34, N'Giường nằm', N'Hoạt động'),    -- 2 (Sài Gòn)
('65B-012.34', 22, N'Limousine VIP', N'Hoạt động'), -- 3 (Cần Thơ)
('65B-567.89', 34, N'Giường nằm', N'Hoạt động'),    -- 4 (Cần Thơ)
('68B-111.22', 34, N'Giường nằm', N'Hoạt động'),    -- 5 (Kiên Giang)
('68B-333.44', 22, N'Limousine VIP', N'Hoạt động'), -- 6 (Kiên Giang)
('67B-777.88', 34, N'Giường nằm', N'Hoạt động'),    -- 7 (An Giang)
('67B-999.00', 40, N'Giường nằm', N'Hoạt động'),    -- 8 (An Giang)
('69B-123.45', 22, N'Limousine VIP', N'Hoạt động'), -- 9 (Cà Mau)
('69B-678.90', 34, N'Giường nằm', N'Hoạt động'),    -- 10 (Cà Mau)
('94B-444.55', 34, N'Giường nằm', N'Hoạt động'),    -- 11 (Bạc Liêu)
('83B-555.66', 34, N'Giường nằm', N'Hoạt động'),    -- 12 (Sóc Trăng)
('66B-789.10', 29, N'Ghế ngồi', N'Hoạt động'),      -- 13 (Đồng Tháp)
('71B-345.67', 29, N'Ghế ngồi', N'Hoạt động'),      -- 14 (Bến Tre)
('64B-234.56', 29, N'Ghế ngồi', N'Hoạt động');      -- 15 (Vĩnh Long)
GO

-- 4. Routes (Tuyến đường kết nối Sài Gòn <-> Các Tỉnh Miền Tây)
INSERT INTO Routes (FromLocationId, ToLocationId, Distance, Duration) VALUES
-- Sài Gòn <-> Cần Thơ (165km, 180p ~ 3h)
(1, 2, 165.0, 180),  -- 1
(2, 1, 165.0, 180),  -- 2

-- Sài Gòn <-> Kiên Giang (250km, 300p ~ 5h)
(1, 3, 250.0, 300),  -- 3
(3, 1, 250.0, 300),  -- 4

-- Sài Gòn <-> An Giang (240km, 330p ~ 5.5h)
(1, 4, 240.0, 330),  -- 5
(4, 1, 240.0, 330),  -- 6

-- Sài Gòn <-> Cà Mau (350km, 450p ~ 7.5h)
(1, 5, 350.0, 450),  -- 7
(5, 1, 350.0, 450),  -- 8

-- Sài Gòn <-> Bạc Liêu (280km, 360p ~ 6h)
(1, 6, 280.0, 360),  -- 9
(6, 1, 280.0, 360),  -- 10

-- Sài Gòn <-> Sóc Trăng (230km, 300p ~ 5h)
(1, 7, 230.0, 300),  -- 11
(7, 1, 230.0, 300),  -- 12

-- Sài Gòn <-> Đồng Tháp (150km, 180p ~ 3h)
(1, 8, 150.0, 180),  -- 13
(8, 1, 150.0, 180),  -- 14

-- Sài Gòn <-> Bến Tre (85km, 120p ~ 2h)
(1, 9, 85.0, 120),   -- 15
(9, 1, 85.0, 120),   -- 16

-- Sài Gòn <-> Vĩnh Long (135km, 150p ~ 2.5h)
(1, 10, 135.0, 150), -- 17
(10, 1, 135.0, 150), -- 18

-- Tuyến liên tỉnh Miền Tây: Cần Thơ <-> Kiên Giang & Cần Thơ <-> Cà Mau
(2, 3, 110.0, 150),  -- 19
(3, 2, 110.0, 150),  -- 20
(2, 5, 180.0, 240),  -- 21
(5, 2, 180.0, 240);  -- 22
GO

-- 5. Trips (Chuyến xe đa dạng hôm nay, ngày mai, ngày mốt)
INSERT INTO Trips (RouteId, VehicleId, DepartureTime, ArrivalTime, AvailableSeats, Price, Status) VALUES
-- ===== HÔM NAY =====
(1, 1, DATEADD(hour, 2, GETDATE()), DATEADD(minute, 180 + 120, GETDATE()), 20, 220000.00, N'Sắp khởi hành'),
(1, 4, DATEADD(hour, 5, GETDATE()), DATEADD(minute, 180 + 300, GETDATE()), 30, 175000.00, N'Sắp khởi hành'),
(1, 3, DATEADD(hour, 8, GETDATE()), DATEADD(minute, 180 + 480, GETDATE()), 18, 220000.00, N'Sắp khởi hành'),
(2, 4, DATEADD(hour, 3, GETDATE()), DATEADD(minute, 180 + 180, GETDATE()), 28, 175000.00, N'Sắp khởi hành'),
(2, 1, DATEADD(hour, 7, GETDATE()), DATEADD(minute, 180 + 420, GETDATE()), 22, 220000.00, N'Sắp khởi hành'),
(3, 5, DATEADD(hour, 4, GETDATE()), DATEADD(minute, 300 + 240, GETDATE()), 32, 210000.00, N'Sắp khởi hành'),
(3, 6, DATEADD(hour, 9, GETDATE()), DATEADD(minute, 300 + 540, GETDATE()), 21, 280000.00, N'Sắp khởi hành'),
(5, 7, DATEADD(hour, 3, GETDATE()), DATEADD(minute, 330 + 180, GETDATE()), 29, 210000.00, N'Sắp khởi hành'),
(5, 8, DATEADD(hour, 8, GETDATE()), DATEADD(minute, 330 + 480, GETDATE()), 38, 190000.00, N'Sắp khởi hành'),
(7, 9, DATEADD(hour, 4, GETDATE()), DATEADD(minute, 450 + 240, GETDATE()), 19, 340000.00, N'Sắp khởi hành'),
(7, 10, DATEADD(hour, 10, GETDATE()), DATEADD(minute, 450 + 600, GETDATE()), 31, 260000.00, N'Sắp khởi hành'),
(9, 11, DATEADD(hour, 5, GETDATE()), DATEADD(minute, 360 + 300, GETDATE()), 30, 230000.00, N'Sắp khởi hành'),
(11, 12, DATEADD(hour, 4, GETDATE()), DATEADD(minute, 300 + 240, GETDATE()), 32, 200000.00, N'Sắp khởi hành'),
(13, 13, DATEADD(hour, 3, GETDATE()), DATEADD(minute, 180 + 180, GETDATE()), 26, 140000.00, N'Sắp khởi hành'),
(15, 14, DATEADD(hour, 2, GETDATE()), DATEADD(minute, 120 + 120, GETDATE()), 25, 110000.00, N'Sắp khởi hành'),
(17, 15, DATEADD(hour, 4, GETDATE()), DATEADD(minute, 150 + 240, GETDATE()), 28, 130000.00, N'Sắp khởi hành'),

-- ===== NGÀY MAI (+1 NGÀY) =====
(1, 1, DATEADD(hour, 6, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 180, DATEADD(hour, 6, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 22, 220000.00, N'Sắp khởi hành'),
(1, 2, DATEADD(hour, 9, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 180, DATEADD(hour, 9, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 175000.00, N'Sắp khởi hành'),
(1, 3, DATEADD(hour, 14, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 180, DATEADD(hour, 14, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 22, 220000.00, N'Sắp khởi hành'),
(1, 4, DATEADD(hour, 20, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 180, DATEADD(hour, 20, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 175000.00, N'Sắp khởi hành'),
(3, 6, DATEADD(hour, 7, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 300, DATEADD(hour, 7, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 22, 280000.00, N'Sắp khởi hành'),
(3, 5, DATEADD(hour, 21, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 300, DATEADD(hour, 21, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 210000.00, N'Sắp khởi hành'),
(5, 7, DATEADD(hour, 8, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 330, DATEADD(hour, 8, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 210000.00, N'Sắp khởi hành'),
(5, 8, DATEADD(hour, 22, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 330, DATEADD(hour, 22, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 40, 190000.00, N'Sắp khởi hành'),
(7, 9, DATEADD(hour, 9, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 450, DATEADD(hour, 9, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 22, 340000.00, N'Sắp khởi hành'),
(7, 10, DATEADD(hour, 21, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 450, DATEADD(hour, 21, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 260000.00, N'Sắp khởi hành'),
(9, 11, DATEADD(hour, 8, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 360, DATEADD(hour, 8, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 230000.00, N'Sắp khởi hành'),
(11, 12, DATEADD(hour, 10, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 300, DATEADD(hour, 10, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 200000.00, N'Sắp khởi hành'),
(13, 13, DATEADD(hour, 7, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 180, DATEADD(hour, 7, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 29, 140000.00, N'Sắp khởi hành'),
(15, 14, DATEADD(hour, 9, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 120, DATEADD(hour, 9, DATEADD(day, 1, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 29, 110000.00, N'Sắp khởi hành'),

-- ===== NGÀY MỐT (+2 NGÀY) =====
(1, 1, DATEADD(hour, 7, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 180, DATEADD(hour, 7, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 22, 220000.00, N'Sắp khởi hành'),
(1, 4, DATEADD(hour, 15, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 180, DATEADD(hour, 15, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 175000.00, N'Sắp khởi hành'),
(3, 5, DATEADD(hour, 8, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 300, DATEADD(hour, 8, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 210000.00, N'Sắp khởi hành'),
(7, 10, DATEADD(hour, 20, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 450, DATEADD(hour, 20, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 260000.00, N'Sắp khởi hành'),
(19, 5, DATEADD(hour, 8, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 150, DATEADD(hour, 8, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 120000.00, N'Sắp khởi hành'),
(21, 10, DATEADD(hour, 14, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME))), DATEADD(minute, 240, DATEADD(hour, 14, DATEADD(day, 2, CAST(CAST(GETDATE() AS DATE) AS DATETIME)))), 34, 160000.00, N'Sắp khởi hành');
GO

-- 6. Customers
INSERT INTO Customers (FullName, Phone, Email, IdCard) VALUES
(N'Lê Hoàng Long', '0909112233', 'long.le@gmail.com', '079202001234'),
(N'Phạm Minh Tuấn', '0938445566', 'tuan.pm@gmail.com', '079201004321'),
(N'Nguyễn Thị Mai', '0918776655', 'mai.nguyen@gmail.com', '079203009876');
GO

-- 7. Tickets
INSERT INTO Tickets (TripId, CustomerId, SeatNumber, BookingTime, Status, TotalPrice) VALUES
(1, 1, 'A01', GETDATE(), N'Đã thanh toán', 220000.00),
(1, 1, 'A02', GETDATE(), N'Đã thanh toán', 220000.00),
(2, 2, 'B05', GETDATE(), N'Đã thanh toán', 175000.00),
(6, 3, 'A06', GETDATE(), N'Đã thanh toán', 210000.00);
GO

PRINT N'Cập nhật thành công: Bỏ Province, chỉ lưu Tỉnh, Mật khẩu MD5 100%!';