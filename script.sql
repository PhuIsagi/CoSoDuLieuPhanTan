USE master
GO

CREATE DATABASE Northwind1
GO

-- Cach 1
CREATE TABLE Northwind1.dbo.KH1(
	[CustomerID] [nchar](5) PRIMARY KEY,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
)
GO

CREATE TABLE Northwind1.dbo.KH2(
	[CustomerID] [nchar](5) PRIMARY KEY,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
)
GO

INSERT INTO Northwind1.dbo.KH1
SELECT * FROM Northwind.dbo.Customers KH
WHERE KH.Country = N'USA' OR KH.Country = N'UK'
GO

INSERT INTO Northwind1.dbo.KH2
SELECT * FROM Northwind.dbo.Customers KH
WHERE KH.Country <> N'USA' AND KH.Country <> N'UK'
GO

SELECT * FROM Northwind1.dbo.KH1 ORDER BY Country
SELECT * FROM Northwind1.dbo.KH2 ORDER BY Country

-- Cach 2
SELECT * INTO Northwind1.dbo.KH1
FROM Northwind.dbo.Customers
WHERE Country = N'USA' OR Country = N'UK'

SELECT * FROM Northwind1.DBO.KH1

SELECT * INTO Northwind1.dbo.KH2
FROM Northwind.dbo.Customers
WHERE Country <> N'USA' OR Country <> N'UK'

SELECT * FROM Northwind1.DBO.KH2

-- 5
CREATE PROC DSTatCaKHMuc1
AS
BEGIN
	SELECT * FROM Northwind.dbo.Customers
END
GO

EXEC DSTatCaKHMuc1
GO

DROP PROC DSTatCaKHMuc1
GO

-- 6
-- Cach 1
CREATE PROC DSTatCaKHMuc2
AS
BEGIN
	SELECT * FROM Northwind1.dbo.KH1
	UNION
	SELECT * FROM Northwind1.dbo.KH2
END
GO

EXEC DSTatCaKHMuc2
GO

DROP  PROC DSTatCaKHMuc2
GO

-- Cach 2
ALTER PROC DSTatCaKHMuc2
AS
BEGIN
	IF EXISTS (SELECT * FROM sys.tables
				JOIN sys.schemas ON sys.tables.schema_id = sys.schemas.schema_id
				WHERE sys.schemas.name = 'dbo' AND sys.tables.name = 'TAM')
	DROP TABLE Northwind1.dbo.TAM
	SELECT * INTO Northwind1.dbo.TAM FROM Northwind1.dbO.KH1
	INSERT INTO Northwind1.dbo.TAM SELECT * FROM Northwind1.dbO.KH2
	SELECT * FROM Northwind1.dbo.TAM ORDER BY Country
END
GO

EXEC DSTatCaKHMuc2
GO

DROP TABLE Northwind1.dbo.TAM
GO

DROP PROC DSTatCaKHMuc2
GO

-- 7
CREATE PROC DSKHBietTenQGMuc1(
	@TenQG NVARCHAR(15)
)
AS
BEGIN
	SELECT * FROM Northwind.dbo.Customers
	WHERE Country=@TenQG
END
GO

EXEC DSKHBietTenQGMuc1 N'Canada'
GO
EXEC DSKHBietTenQGMuc1 N'USA'
GO

-- 8
USE Northwind1
GO

CREATE PROC DSKHBietTenQGMuc2(
	@TenQG NVARCHAR(15)
)
AS
BEGIN
	IF (@TenQG = N'USA' OR @TenQG = N'UK')
		SELECT * FROM Northwind1.dbo.KH1 WHERE Country = @TenQG
	ELSE
		SELECT * FROM Northwind1.dbo.KH2 WHERE Country = @TenQG
END
GO

EXEC Northwind1.dbo.DSKHBietTenQGMuc2 N'USA'
GO

EXEC Northwind1.dbo.DSKHBietTenQGMuc2 N'Canada'
GO

DROP PROC dbo.DSKHBietTenQGMuc2
GO

-- 9
CREATE TABLE Northwind1.dbo.DH1(
	[OrderID] [int] PRIMARY KEY,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL
)
GO

INSERT INTO dbo.DH1
SELECT * FROM Northwind.dbo.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Northwind1.dbo.KH1)

SELECT * FROM dbo.DH1

CREATE TABLE Northwind1.dbo.DH2(
	[OrderID] [int] PRIMARY KEY,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL
)
GO

INSERT INTO dbo.DH2
SELECT * FROM Northwind.dbo.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Northwind1.dbo.KH2)

SELECT * FROM dbo.DH2

-- 10
USE Northwind
GO

SELECT * FROM Orders

-- 11
USE Northwind1
GO

SELECT * FROM dbo.DH1
UNION
SELECT * FROM dbo.DH2

-- 12
USE Northwind
GO

CREATE PROC DSDonHang(
	@TenQG NVARCHAR(20)
)
AS
BEGIN
	SELECT * FROM Orders
	WHERE CustomerID IN ( SELECT CustomerID FROM Customers WHERE Country = @TenQG)
END
GO

EXEC DSDonHang N'Canada'
GO

DROP PROC DSDonHang
GO

-- 13
USE Northwind1
GO

ALTER PROC DSDonHangMuc2(
	@TenQG NVARCHAR(20)
)
AS
BEGIN
	IF (@TenQG = N'USA' OR @TenQG = N'UK')
		SELECT * FROM dbo.DH1
		WHERE CustomerID IN (SELECT CustomerID FROM dbo.KH1 WHERE Country = @TenQG)
	ELSE
		SELECT * FROM dbo.DH2
		WHERE CustomerID IN (SELECT CustomerID FROM dbo.KH2 WHERE Country = @TenQG)
END
GO

EXEC DSDonHangMuc2 N'USA'
GO

EXEC DSDonHangMuc2 N'Canada'
GO

-- 14
USE Northwind1
GO

CREATE TABLE dbo.NV1(
	[EmployeeID] [int] PRIMARY KEY,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[TitleOfCourtesy] [nvarchar](25) NULL,
)
GO

CREATE TABLE dbo.NV2(
	[EmployeeID] [int] PRIMARY KEY,
	[Title] [nvarchar](30) NULL,
	[BirthDate] [datetime] NULL,
	[HireDate] [datetime] NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[HomePhone] [nvarchar](24) NULL,
	[Extension] [nvarchar](4) NULL,
	[Photo] [image] NULL,
	[Notes] [ntext] NULL,
	[ReportsTo] [int] NULL,
	[PhotoPath] [nvarchar](255) NULL,
)
GO

INSERT INTO NV1
SELECT EmployeeID, LastName, FirstName, TitleOfCourtesy FROM Northwind.dbo.Employees
GO

SELECT * FROM NV1

INSERT INTO NV2
SELECT EmployeeID, Title, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath FROM Northwind.dbo.Employees
GO

SELECT * FROM NV2

-- 15
SELECT * FROM Northwind.dbo.Employees

--16
SELECT 