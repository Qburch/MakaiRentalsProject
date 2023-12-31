USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Users_SelectPasswordById]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Gets hashed password for user by user Id
-- Code Reviewer: Dan
-- =============================================
CREATE proc [dbo].[Users_SelectPasswordById]
								@Id int

		/*
			Declare @Id int = 680;
				
			Execute dbo.Users_SelectPasswordById
											@Id
		*/
as
BEGIN
	SELECT [Password]
	FROM dbo.Users
	WHERE [Id] = @Id
END
GO
