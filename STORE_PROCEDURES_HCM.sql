﻿DROP PROCEDURE BaoCao_DiemSo_XepLoai_MonHoc_CapPhong
GO
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		thanhluan@quangich.com
-- Create date: 2017/04/11
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE BaoCao_DiemSo_XepLoai_MonHoc_CapPhong
	-- Add the parameters for the stored procedure here
	@MaPGD NVARCHAR(50),
	@MaNamHoc NVARCHAR(25),
	@MaMonHoc NVARCHAR(25),
	@HocKy INT/*1-Kỳ I, 2-Kỳ II, Giá trị khác(thường là 3) là cả năm*/,
	@SoLieu INT/*1-Thi HK, 2-Xếp loại môn*/
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	DECLARE @KieuMon INT = 0;/*1-Tính điểm, 2-Nhận xét*/
	SELECT @KieuMon = KieuMon_ID FROM DMMonHocChuan WHERE Ma = @MaMonHoc;
	IF(@KieuMon = 1)
	BEGIN
		IF(@SoLieu = 1)
		BEGIN
			SELECT KHOI,
				TEN_TRUONG,
				SO_LUONGHS,
				GIOI_TS,
				GIOI_TL,
				KHA_TS,
				KHA_TL,
				TRUNGBINH_TS,
				TRUNGBINH_TL,
				YEU_TS,
				YEU_TL,
				KEM_TS,
				KEM_TL,
				TBTROLEN_TS,
				TBTROLEN_TL,
				(CASE WHEN GROUP_ROW = 1 THEN NULL ELSE (RANK() OVER (PARTITION BY KHOI ORDER BY TBTROLEN_TL DESC)) END) AS TBTROLEN_XEP_HANG
			FROM
			(
				SELECT (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN l.DMKhoi_ID*10 ELSE l.DMKhoi_ID END) AS KHOI,
					(CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'THCS' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Khối '+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END) AS TEN_TRUONG,
					--COUNT(h.ID) AS TONG_SOHS,
					--COUNT(d.HocSinh_ID) AS SO_LUONGHS_MON,
					COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) AS SO_LUONGHS,
					COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 8) THEN h.ID END) AS GIOI_TS,
					(CASE WHEN COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) = 0 THEN 0 ELSE CAST(COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 8) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) AS numeric(10, 2)) END) AS GIOI_TL,
					COUNT(CASE WHEN (DiemHK < 8) AND (DiemHK >= 6.5) THEN h.ID END) AS KHA_TS,
					(CASE WHEN COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN (DiemHK < 8) AND (DiemHK >= 6.5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END)) AS numeric(10, 2)) END) AS KHA_TL,
					COUNT(CASE WHEN (DiemHK < 6.5) AND (DiemHK >= 5) THEN h.ID END) AS TRUNGBINH_TS,
					(CASE WHEN COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN (DiemHK < 6.5) AND (DiemHK >= 5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END)) AS numeric(10, 2)) END) AS TRUNGBINH_TL,
					COUNT(CASE WHEN (DiemHK < 5) AND (DiemHK >= 3.5) THEN h.ID END) AS YEU_TS,
					(CASE WHEN COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN (DiemHK < 5) AND (DiemHK >= 3.5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END)) AS numeric(10, 2)) END) AS YEU_TL,
					COUNT(CASE WHEN (DiemHK < 3.5) AND (DiemHK >= 0) THEN h.ID END) AS KEM_TS,
					(CASE WHEN COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN (DiemHK < 3.5) AND (DiemHK >= 0) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END)) AS numeric(10, 2)) END) AS KEM_TL,
					COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 5) THEN h.ID END) AS TBTROLEN_TS,
					(CASE WHEN COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (DiemHK <= 10.1) AND (DiemHK >= 0) THEN h.ID END)) AS numeric(10, 2)) END) AS TBTROLEN_TL,		
					(CASE WHEN t.TenTruong IS NULL THEN 1 ELSE 0 END) AS GROUP_ROW,
					(ROW_NUMBER() OVER(ORDER BY (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 ELSE l.DMKhoi_ID END), (CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'Z100' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Z'+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END))) AS STT
				FROM dbo.HocSinh h
				INNER JOIN dbo.Lop l ON h.Lop_ID = l.ID
				INNER JOIN NamHoc n on l.NamHoc_ID = n.id
				INNER JOIN Truong t on n.Truong_id = t.id
				JOIN dbo.MonHoc m ON  l.ID = m.Lop_ID AND m.HocKy_ID = (Case when @HocKy=1 then 1 else 2 end)
				JOIN dbo.DMMonHoc mh ON m.DMMonHoc_ID = mh.ID AND t.ID = mh.Truong_ID
				LEFT JOIN dbo.Diem d ON h.ID = d.HocSinh_ID AND d.MonHoc_ID = m.id
				WHERE 1=1
				AND t.Phong_Ma = @MaPGD
				AND n.Ma = @MaNamHoc
				AND (CASE WHEN @HocKy = 1 AND h.DMTrangThaiHS = 1 THEN 1
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 21 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 31 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 211 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 212 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 213 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 214 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 215 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 216 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 217 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 1 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 61 THEN 1 
						ELSE 0 END) = 1
				AND mh.Ma = @MaMonHoc
				GROUP BY GROUPING SETS ((l.DMKhoi_ID, t.ID, t.TenTruong,t.Ma),(l.DMKhoi_ID),())
			) AS A
			ORDER BY STT
		END
		ELSE --IF(@SoLieu = 2)
		BEGIN
			SELECT KHOI,
				TEN_TRUONG,
				SO_LUONGHS,
				GIOI_TS,
				GIOI_TL,
				KHA_TS,
				KHA_TL,
				TRUNGBINH_TS,
				TRUNGBINH_TL,
				YEU_TS,
				YEU_TL,
				KEM_TS,
				KEM_TL,
				TBTROLEN_TS,
				TBTROLEN_TL,
				(CASE WHEN GROUP_ROW = 1 THEN NULL ELSE (RANK() OVER (PARTITION BY KHOI ORDER BY TBTROLEN_TL DESC)) END) AS TBTROLEN_XEP_HANG
			FROM
			(
				SELECT (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN l.DMKhoi_ID*10 ELSE l.DMKhoi_ID END) AS KHOI,
					(CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'THCS' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Khối '+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END) AS TEN_TRUONG,
					--COUNT(h.ID) AS TONG_SOHS,
					--COUNT(d.HocSinh_ID) AS SO_LUONGHS_MON,
					COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) AS SO_LUONGHS,
					COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 8 THEN h.ID END) AS GIOI_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) = 0 THEN 0 ELSE CAST(COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10.1) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 8) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) AS numeric(10, 2)) END) AS GIOI_TL,
					COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 8) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 6.5) THEN h.ID END) AS KHA_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 8) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 6.5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END)) AS numeric(10, 2)) END) AS KHA_TL,
					COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 6.5) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 5) THEN h.ID END) AS TRUNGBINH_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 6.5) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END)) AS numeric(10, 2)) END) AS TRUNGBINH_TL,
					COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 5) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 3.5) THEN h.ID END) AS YEU_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 5) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 3.5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END)) AS numeric(10, 2)) END) AS YEU_TL,
					COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 3.5) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0) THEN h.ID END) AS KEM_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) < 3.5) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END)) AS numeric(10, 2)) END) AS KEM_TL,
					COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10.1) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 5) THEN h.ID END) AS TBTROLEN_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10.1) AND ((CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 5) THEN h.ID END) * 100.0 / COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) <= 10 AND (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) >= 0 THEN h.ID END)) AS numeric(10, 2)) END) AS TBTROLEN_TL,		
					(CASE WHEN t.TenTruong IS NULL THEN 1 ELSE 0 END) AS GROUP_ROW,
					(ROW_NUMBER() OVER(ORDER BY (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 ELSE l.DMKhoi_ID END), (CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'Z100' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Z'+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END))) AS STT
				FROM dbo.HocSinh h
				INNER JOIN dbo.Lop l ON h.Lop_ID = l.ID
				INNER JOIN NamHoc n on l.NamHoc_ID = n.id
				INNER JOIN Truong t on n.Truong_id = t.id
				JOIN dbo.MonHoc m ON  l.ID = m.Lop_ID AND m.HocKy_ID = (Case when @HocKy=1 then 1 else 2 end)
				JOIN dbo.DMMonHoc mh ON m.DMMonHoc_ID = mh.ID AND t.ID = mh.Truong_ID
				LEFT JOIN dbo.Diem d ON h.ID = d.HocSinh_ID AND d.MonHoc_ID = m.id
				WHERE 1=1
				AND t.Phong_Ma = @MaPGD
				AND n.Ma = @MaNamHoc
				AND (CASE WHEN @HocKy = 1 AND h.DMTrangThaiHS = 1 THEN 1
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 21 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 31 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 211 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 212 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 213 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 214 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 215 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 216 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 217 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 1 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 61 THEN 1 
						ELSE 0 END) = 1
				AND mh.Ma = @MaMonHoc
				GROUP BY GROUPING SETS ((l.DMKhoi_ID, t.ID, t.TenTruong,t.Ma),(l.DMKhoi_ID),())
			) AS A
			ORDER BY STT
		END
	END
	ELSE --IF(@KieuMon = 2)
	BEGIN
		IF(@SoLieu = 1)
		BEGIN
			SELECT KHOI,
				TEN_TRUONG,
				SO_LUONGHS,
				DAT_TS,
				DAT_TL,
				CHUADAT_TS,
				CHUADAT_TL,
				TBTROLEN_TS,
				TBTROLEN_TL,
				(CASE WHEN GROUP_ROW = 1 THEN NULL ELSE (RANK() OVER (PARTITION BY KHOI ORDER BY TBTROLEN_TL DESC)) END) AS TBTROLEN_XEP_HANG
			FROM
			(
				SELECT (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN l.DMKhoi_ID*10 ELSE l.DMKhoi_ID END) AS KHOI,
					(CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'THCS' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Khối '+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END) AS TEN_TRUONG,
					--COUNT(h.ID) AS TONG_SOHS,
					--COUNT(d.HocSinh_ID) AS SO_LUONGHS_MON,
					COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID WHEN DiemHK = 0 THEN h.ID END) AS SO_LUONGHS,
					COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID END) AS DAT_TS,
					(CASE WHEN COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID WHEN DiemHK = 0 THEN h.ID END) = 0 THEN 0 ELSE CAST(COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID END) * 100.0 / COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID WHEN DiemHK = 0 THEN h.ID END) AS NUMERIC(10, 2)) END) AS DAT_TL,
		
					COUNT(CASE WHEN DiemHK = 0 THEN h.ID END) AS CHUADAT_TS,
					(CASE WHEN COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID WHEN DiemHK = 0 THEN h.ID END) = 0 THEN 0 ELSE CAST((COUNT(CASE WHEN DiemHK = 0 THEN h.ID END) * 100.0 / COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID WHEN DiemHK = 0 THEN h.ID END)) AS NUMERIC(10, 2)) END) AS CHUADAT_TL,
		
					COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID END) AS TBTROLEN_TS,
					(CASE WHEN COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID WHEN DiemHK = 0 THEN h.ID END) = 0 THEN 0 ELSE CAST(COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID END) * 100.0 / COUNT(CASE WHEN DiemHK = 1 THEN h.ID WHEN DiemHK = 2 THEN h.ID WHEN DiemHK = 0 THEN h.ID END) AS NUMERIC(10, 2)) END) AS TBTROLEN_TL,
		
					(CASE WHEN t.TenTruong IS NULL THEN 1 ELSE 0 END) AS GROUP_ROW,
					(ROW_NUMBER() OVER(ORDER BY (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 ELSE l.DMKhoi_ID END), (CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'Z100' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Z'+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END))) AS STT
				
				FROM dbo.HocSinh h
				INNER JOIN dbo.Lop l ON h.Lop_ID = l.ID
				INNER JOIN NamHoc n on l.NamHoc_ID = n.id
				INNER JOIN Truong t on n.Truong_id = t.id
				JOIN dbo.MonHoc m ON  l.ID = m.Lop_ID AND m.HocKy_ID = (Case when @HocKy=1 then 1 else 2 end)
				JOIN dbo.DMMonHoc mh ON m.DMMonHoc_ID = mh.ID AND t.ID = mh.Truong_ID
				LEFT JOIN dbo.Diem d ON h.ID = d.HocSinh_ID AND d.MonHoc_ID = m.id
				WHERE 1=1
				AND t.Phong_Ma = @MaPGD
				AND n.Ma = @MaNamHoc
				AND (CASE WHEN @HocKy = 1 AND h.DMTrangThaiHS = 1 THEN 1
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 21 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 31 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 211 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 212 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 213 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 214 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 215 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 216 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 217 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 1 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 61 THEN 1 
						ELSE 0 END) = 1
				AND mh.Ma = @MaMonHoc
				GROUP BY GROUPING SETS ((l.DMKhoi_ID, t.ID, t.TenTruong,t.Ma),(l.DMKhoi_ID),())
			) AS A
			ORDER BY STT
		END
		ELSE --IF(@SoLieu = 2)
		BEGIN
			SELECT KHOI,
				TEN_TRUONG,
				SO_LUONGHS,
				DAT_TS,
				DAT_TL,
				CHUADAT_TS,
				CHUADAT_TL,
				TBTROLEN_TS,
				TBTROLEN_TL,
				(CASE WHEN GROUP_ROW = 1 THEN NULL ELSE (RANK() OVER (PARTITION BY KHOI ORDER BY TBTROLEN_TL DESC)) END) AS TBTROLEN_XEP_HANG
			FROM
			(
				SELECT (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN l.DMKhoi_ID*10 ELSE l.DMKhoi_ID END) AS KHOI,
					(CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'THCS' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Khối '+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END) AS TEN_TRUONG,
					--COUNT(h.ID) AS TONG_SOHS,
					--COUNT(d.HocSinh_ID) AS SO_LUONGHS_MON,
					COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
							WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
							WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID 
						END) AS SO_LUONGHS,

					COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
							WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
						END) AS DAT_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
										WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
										WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID 
									END) = 0 THEN 0 
						ELSE CAST((COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
											WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
										END) * 100.0 
										/ COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
												WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
												WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID 
											END)
									) AS NUMERIC(10, 2)) END) AS DAT_TL,
		
					COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID END) AS CHUADAT_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
										WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
										WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID 
									END) = 0 THEN 0 
						ELSE CAST((COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID END) * 100.0 
										/ COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
												WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
												WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID 
											END)
									) AS NUMERIC(10, 2)) END) AS CHUADAT_TL,
		
					COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
							WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
						END) AS TBTROLEN_TS,
					(CASE WHEN COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
										WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
										WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID 
									END) = 0 THEN 0 
						ELSE CAST((COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
											WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
										END) * 100.0 
										/ COUNT(CASE WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 1 THEN h.ID 
												WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 2 THEN h.ID 
												WHEN (CASE WHEN @HocKy=1 THEN TBK1 WHEN @HocKy=2 THEN TBK2 ELSE TBCN END) = 0 THEN h.ID 
											END)
									) AS NUMERIC(10, 2)) END) AS TBTROLEN_TL,

					(CASE WHEN t.TenTruong IS NULL THEN 1 ELSE 0 END) AS GROUP_ROW,
					(ROW_NUMBER() OVER(ORDER BY (CASE WHEN l.DMKhoi_ID IS NULL THEN 100 ELSE l.DMKhoi_ID END), (CASE WHEN l.DMKhoi_ID IS NULL AND t.TenTruong IS NULL THEN 'Z100' WHEN l.DMKhoi_ID IS NOT NULL AND t.TenTruong IS NULL THEN N'Z'+ CONVERT(NVARCHAR(10),l.DMKhoi_ID) ELSE t.TenTruong END))) AS STT
				FROM dbo.HocSinh h
				INNER JOIN dbo.Lop l ON h.Lop_ID = l.ID
				INNER JOIN NamHoc n on l.NamHoc_ID = n.id
				INNER JOIN Truong t on n.Truong_id = t.id
				JOIN dbo.MonHoc m ON  l.ID = m.Lop_ID AND m.HocKy_ID = (Case when @HocKy=1 then 1 else 2 end)
				JOIN dbo.DMMonHoc mh ON m.DMMonHoc_ID = mh.ID AND t.ID = mh.Truong_ID
				LEFT JOIN dbo.Diem d ON h.ID = d.HocSinh_ID AND d.MonHoc_ID = m.id
				WHERE 1=1
				AND t.Phong_Ma = @MaPGD
				AND n.Ma = @MaNamHoc
				AND (CASE WHEN @HocKy = 1 AND h.DMTrangThaiHS = 1 THEN 1
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 21 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 31 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 211 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 212 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 213 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 214 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 215 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 216 THEN 1 
						WHEN @HocKy = 1 AND h.DMTrangThaiHS = 217 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 1 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 4 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 6 THEN 1 
						WHEN @HocKy != 1 AND  H.DMTrangThaiHS = 61 THEN 1 
						ELSE 0 END) = 1
				AND mh.Ma = @MaMonHoc
				GROUP BY GROUPING SETS ((l.DMKhoi_ID, t.ID, t.TenTruong,t.Ma),(l.DMKhoi_ID),())
			) AS A
			ORDER BY STT
		END
	END
END
GO
