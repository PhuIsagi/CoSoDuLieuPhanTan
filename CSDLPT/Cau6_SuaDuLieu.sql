--Cau 6:

use Northwind
go
CREATE PROC ProcSuaKHMuc1  
				 @MaKH nvarchar(5)				
				,@ThanhPho nvarchar(15)
				,@QuocGia nvarchar(15)
AS
BEGIN
	IF NOT EXISTS(SELECT CustomerID FROM Customers WHERE CustomerID=@MaKH)
		PRINT N'Không tìm thấy mã khách hàng cần sửa!'
	ELSE
		BEGIN
			UPDATE Customers
				SET City=@ThanhPho,Country=@QuocGia
				WHERE CustomerID=@MaKH
			PRINT N'Đã sửa thành công 1 hàng của bảng Customers.'
		END
END
GO

EXEC Northwind.dbo.ProcThemKHMuc1 N'ABCD', N'Công ty ABCD', N'TP.HCM', N'Việt nam'
GO

SELECT * FROM Northwind.dbo.Customers
GO

EXEC Northwind.dbo.ProcSuaKHMuc1 N'ABCD', N'Băng-cốc', N'Thái lan'
GO

SELECT * FROM Northwind.dbo.Customers
GO

DELETE FROM Northwind.dbo.Customers WHERE CustomerID='ABCD'
GO

SELECT * FROM Northwind.dbo.Customers
GO

use Northwind1
go
CREATE PROC ProcSuaKHMuc2  
				 @MaKH nvarchar(5)				
				,@ThanhPho nvarchar(15)
				,@QuocGia nvarchar(15)
AS
BEGIN
	--1.Tìm ở PM KH1:
	IF EXISTS(SELECT CustomerID FROM KH1 WHERE CustomerID=@MaKH)
		BEGIN
			IF (@QuocGia='USA' OR @QuocGia='UK')
				BEGIN
					UPDATE KH1
						SET City=@ThanhPho,Country=@QuocGia
						WHERE CustomerID=@MaKH
					PRINT N'Đã sửa thành công 1 hàng của phân mảnh KH1.'
				END
			ELSE --Quốc gia khác USA và UK, phải dời KH và DH của KH
				BEGIN
					--Sửa dữ liệu
					UPDATE KH1
						SET City=@ThanhPho,Country=@QuocGia
						WHERE CustomerID=@MaKH
					--Dời KH
					INSERT INTO KH2
						SELECT * FROM KH1 WHERE CustomerID=@MaKH
					DELETE FROM KH1 WHERE CustomerID=@MaKH							
					---Dời DH
					INSERT INTO DH2
						SELECT * FROM DH1 WHERE CustomerID=@MaKH
					DELETE FROM DH1 WHERE CustomerID=@MaKH							
					--Báo thành công
					PRINT N'Đã sửa thành công 1 hàng ở phân mảnh KH1 
và chuyển hàng này qua lưu vào phân mảnh KH2; 
Đã dời các đơn hàng của KH này đang lưu ở phân mảnh DH1 sang phân mảnh DH2.'
				END		
		END
	
	--2.Tìm ở PM KH2:
	ELSE IF EXISTS(SELECT CustomerID FROM KH2 WHERE CustomerID=@MaKH)
		BEGIN
			IF (@QuocGia <>'USA' AND @QuocGia<>'UK')
				BEGIN
					UPDATE KH2
						SET City=@ThanhPho,Country=@QuocGia
						WHERE CustomerID=@MaKH
					PRINT N'Đã sửa thành công 1 hàng của phân mảnh KH2.'
				END			
				
			ELSE --Quốc gia là USA hay UK
				BEGIN
					--Sửa dữ liệu
					UPDATE KH2
						SET City=@ThanhPho,Country=@QuocGia
						WHERE CustomerID=@MaKH
					--Dời khách hàng
					INSERT INTO KH1
						SELECT * FROM KH2 WHERE CustomerID=@MaKH
					DELETE FROM KH2 WHERE CustomerID=@MaKH							
					--Dời đơn hàng
					INSERT INTO DH1
						SELECT * FROM DH2 WHERE CustomerID=@MaKH
					DELETE FROM DH2 WHERE CustomerID=@MaKH							
					--Báo thành công
					PRINT N'Đã sửa thành công 1 hàng ở phân mảnh KH2 
và chuyển hàng này qua lưu vào phân mảnh KH1; 
Đã dời các đơn hàng của KH này đang lưu ở phân mảnh DH2 sang phân mảnh DH1.'
				END		
		END
	
	--3.Không tìm thấy mã KH:
	ELSE
		PRINT N'Không tìm thấy mã khách hàng cần sửa!'
		
END
GO

--Test sửa Khách hàng mức 2:

-----------------------------------
EXEC Northwind1.dbo.ProcThemKHMuc2 N'KH001', N'Công ty 001', N'HCMC', N'Việt nam'
GO

SELECT * FROM Northwind1.dbo.KH1
SELECT * FROM Northwind1.dbo.KH2

EXEC Northwind1.dbo.ProcSuaKHMuc2 N'KH000',N'TP, Hồ Chí Minh', N'Việt nam'
GO
EXEC Northwind1.dbo.ProcSuaKHMuc2 N'KH001',N'TP. Viêng chăng', N'Lào'
GO
EXEC Northwind1.dbo.ProcSuaKHMuc2 N'KH001',N'Westminter', N'UK'
GO

SELECT * FROM KH1 WHERE CustomerID='AROUT'--ở London, UK
SELECT * FROM DH1 WHERE CustomerID='AROUT'--có 13 đơn hàng

--sửa khách hàng có sẳn
EXEC Northwind1.dbo.ProcSuaKHMuc2 N'AROUT',N'Paris', N'France'
GO

SELECT * FROM KH1 WHERE CustomerID='AROUT'--không có
SELECT * FROM DH1 WHERE CustomerID='AROUT'--có 0 đơn hàng

SELECT * FROM KH2 WHERE CustomerID='AROUT'--ở ở Paris, France
SELECT * FROM DH2 WHERE CustomerID='AROUT'--có 13 đơn hàng

--sửa lại nguyên thủy
EXEC Northwind1.dbo.ProcSuaKHMuc2 N'AROUT',N'London', N'UK'
GO
----------------------
EXEC Northwind1.dbo.ProcThemKHMuc2 N'KH002', N'Công ty 002', N'London', N'UK'
GO

SELECT * FROM Northwind1.dbo.KH1
SELECT * FROM Northwind1.dbo.KH2

EXEC Northwind1.dbo.ProcSuaKHMuc2 N'KH002',N'Garden Grove', N'USA'
GO
EXEC Northwind1.dbo.ProcSuaKHMuc2 N'KH002',N'Manila', N'Philipines'
GO
EXEC Northwind1.dbo.ProcSuaKHMuc2 N'KH002',N'Liverpool', N'UK'
GO
--------------------------------xóa rác
DELETE FROM Northwind1.dbo.KH1 WHERE CustomerID='KH001'
DELETE FROM Northwind1.dbo.KH2 WHERE CustomerID='KH001'

DELETE FROM Northwind1.dbo.KH1 WHERE CustomerID='KH002'
DELETE FROM Northwind1.dbo.KH2 WHERE CustomerID='KH002'
