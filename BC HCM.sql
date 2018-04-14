
/*SHEET THI HK*/
DECLARE @MaPGD NVARCHAR(50) = 'hcm-q1',
 @MaNamHoc NVARCHAR(50) = '2016',
 @MaMonHoc NVARCHAR(50) = 'TO',/*Ví dụ TO-Môn tính điểm toán TOAN_PGD.XLS, TD-Môn nhận xét thể dục/*MÔN NHẬN XÉT THEDUC_PGD.XLSX*/ */
 @NamHocID INT = 9551,
 @HocKy INT = 2,
 @KieuMon INT = 2,/*1-Tinh diem, 2-Nhan xet*/
 @SoLieu INT = 1/*1-Thi HK, 2-XLmon HK, 3-XLCN*/
 
EXEC BaoCao_DiemSo_XepLoai_MonHoc_CapPhong
 -- Add the parameters for the stored procedure here
 @MaPGD ,
 @MaNamHoc ,
 @MaMonHoc ,
 @HocKy /*1-Kỳ I, 2-Kỳ II, Giá trị khác(thường là 3) là cả năm*/,
 @SoLieu /*1-Thi HK, 2-Xếp loại môn*/--,
 --@KieuMon /*1-Tính điểm, 2-Nhận xét*/

 GO 
/*SHEET XLHK2*/
 DECLARE @MaPGD NVARCHAR(50) = 'hcm-q1',
 @MaNamHoc NVARCHAR(50) = '2016',
 @MaMonHoc NVARCHAR(50) = 'TD',/*Ví dụ TO-Môn tính điểm toán, TD-Môn nhận xét thể dục */
 @NamHocID INT = 9551,
 @HocKy INT = 2,
 @KieuMon INT = 2,/*1-Tinh diem, 2-Nhan xet*/
 @SoLieu INT = 2/*1-Thi HK, 2-XLmon HK, 3-XLCN*/
 
EXEC BaoCao_DiemSo_XepLoai_MonHoc_CapPhong
 -- Add the parameters for the stored procedure here
 @MaPGD ,
 @MaNamHoc ,
 @MaMonHoc ,
 @HocKy /*1-Kỳ I, 2-Kỳ II, Giá trị khác(thường là 3) là cả năm*/,
 @SoLieu /*1-Thi HK, 2-Xếp loại môn*/,
 @KieuMon /*1-Tính điểm, 2-Nhận xét*/

 
 GO 
/*SHEET XLCN*/
 DECLARE @MaPGD NVARCHAR(50) = 'hcm-q1',
 @MaNamHoc NVARCHAR(50) = '2016',
 @MaMonHoc NVARCHAR(50) = 'TD',/*Ví dụ TO-Môn tính điểm toán, TD-Môn nhận xét thể dục */
 @NamHocID INT = 9551,
 @HocKy INT = 3,
 @KieuMon INT = 2,/*1-Tinh diem, 2-Nhan xet*/
 @SoLieu INT = 2/*1-Thi HK, 2-XLmon HK, 3-XLCN*/
 
EXEC BaoCao_DiemSo_XepLoai_MonHoc_CapPhong
 -- Add the parameters for the stored procedure here
 @MaPGD ,
 @MaNamHoc ,
 @MaMonHoc ,
 @HocKy /*1-Kỳ I, 2-Kỳ II, Giá trị khác(thường là 3) là cả năm*/,
 @SoLieu /*1-Thi HK, 2-Xếp loại môn*/,
 @KieuMon /*1-Tính điểm, 2-Nhận xét*/