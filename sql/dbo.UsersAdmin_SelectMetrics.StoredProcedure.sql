USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[UsersAdmin_SelectMetrics]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Gets Users and Sales metrics for the Admin Dashboard
-- Code Reviewer: Jacob
-- =============================================
CREATE proc [dbo].[UsersAdmin_SelectMetrics]
as
		/*

			Execute dbo.UsersAdmin_SelectMetrics

		*/
BEGIN

	Execute dbo.UsersAdmin_SelectUserStatusMetrics

	Execute dbo.UsersAdmin_SelectUserGrowthMetrics

	Execute dbo.UsersAdmin_SelectRevenueGrowthMetrics

END
GO
