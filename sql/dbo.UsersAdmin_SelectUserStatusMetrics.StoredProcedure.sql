USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[UsersAdmin_SelectUserStatusMetrics]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Gets user status metrics for the Admin Dashboard
-- Code Reviewer: Jacob
-- =============================================
CREATE proc [dbo].[UsersAdmin_SelectUserStatusMetrics]
		/*
			Execute dbo.UsersAdmin_SelectUserStatusMetrics
		*/
as
BEGIN
	SELECT COALESCE(st.[Name], 'Total Users') as [Status],
			Count(1) as [NumberofUsers]
	FROM [dbo].[Users] as u inner join [dbo].[StatusTypes] as st
								ON u.[StatusId] = st.[Id]
	GROUP BY ROLLUP(st.[Name])
END
GO
