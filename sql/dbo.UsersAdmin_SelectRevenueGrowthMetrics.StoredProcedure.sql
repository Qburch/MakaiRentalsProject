USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[UsersAdmin_SelectRevenueGrowthMetrics]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Gets Revenue metrics for the Admin Dashboard
-- Code Reviewer: Jacob
-- =============================================
CREATE proc [dbo].[UsersAdmin_SelectRevenueGrowthMetrics]
as
	/*

	*/
BEGIN

	DECLARE @DateNow date = GETUTCDATE()

	DECLARE @LastWeek date = DATEADD(WEEK, -1, @DateNow),
			@LastMonth date = DATEADD(MONTH,-1,@DateNow),
			@LastYear date = DATEADD(YEAR, -1, @DateNow)

	DECLARE @RevenueLastWeek int = (
										SELECT SUM(AmountTotal)
										FROM [dbo].[StripeTransactions]
										WHERE [PaymentStatus] = 'paid' AND [DateCreated] > @LastWeek
									),
			@RevenueLastMonth int = (
										SELECT SUM(AmountTotal)
										FROM [dbo].[StripeTransactions]
										WHERE [PaymentStatus] = 'paid' AND [DateCreated] > @LastMonth
									),
			@RevenueLastYear int = (
										SELECT SUM(AmountTotal)
										FROM [dbo].[StripeTransactions]
										WHERE [PaymentStatus] = 'paid' AND [DateCreated] > @LastYear
									),
			@TotalRevenue int =    (
										SELECT SUM(AmountTotal)
										FROM [dbo].[StripeTransactions]
										WHERE [PaymentStatus] = 'paid'
								    )

	SELECT [RevenueLastWeek] = @RevenueLastWeek,
		  [RevenueLastMonth] = @RevenueLastMonth,
		  [RevenueLastYear] = @RevenueLastYear,
		  [RevenueGrowthLastWeek] = CAST(@RevenueLastWeek as DECIMAL) * 100 / @TotalRevenue,
		  [RevenueGrowthLastMonth]  = CAST(@RevenueLastMonth as DECIMAL) * 100 / @TotalRevenue,
		  [RevenueGrowthLastYear] = CAST(@RevenueLastYear as DECIMAL) * 100 / @TotalRevenue,
		  [RevenueGrowthOnYearLastWeek] = CAST(@RevenueLastWeek as DECIMAL) * 100 / @RevenueLastYear,
		  [RevenueGrowthOnYearLastMonth] = CAST(@RevenueLastMonth as DECIMAL) * 100 / @RevenueLastYear
END
GO
