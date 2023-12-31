USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[UsersAdmin_SelectUserGrowthMetrics]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Gets User growth metrics for the Admin Dashboard
-- Code Reviewer: Jacob
-- =============================================
CREATE proc [dbo].[UsersAdmin_SelectUserGrowthMetrics]

	/*
		Execute dbo.UsersAdmin_SelectUserGrowthMetrics
	*/
as
BEGIN

	DECLARE @DateNow date = GETUTCDATE()

	DECLARE @LastWeek date = DATEADD(WEEK, -1, @DateNow),
			@LastMonth date = DATEADD(MONTH,-1,@DateNow),
			@LastYear date = DATEADD(YEAR, -1, @DateNow)

	DECLARE @TotalUsers int = (
						SELECT DISTINCT Count(1) Over()
						FROM [dbo].[Users]
	)

	SELECT [WeeklyGrowth] = (
						SELECT DISTINCT Cast(Count(1) Over() as DECIMAL) * 100 / @TotalUsers
						FROM [dbo].[Users]
						WHERE [DateCreated] > @LastWeek
						),
			[MonthlyGrowth] = (
						SELECT DISTINCT Cast(Count(1) Over() as DECIMAL) * 100 / @TotalUsers
						FROM [dbo].[Users]
						WHERE [DateCreated] > @LastMonth
						),
			[YearlyGrowth] = (
						SELECT DISTINCT Cast(Count(1) Over() as DECIMAL) * 100 / @TotalUsers
						FROM [dbo].[Users]
						WHERE [DateCreated] > @LastYear
						)
END
GO
