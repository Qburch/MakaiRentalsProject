USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Users_UpdatePasswordV2]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Update just the password for a logged in user
-- Code Reviewer: Dan
-- =============================================
CREATE proc [dbo].[Users_UpdatePasswordV2]
					@UserId int,
					@Password nvarchar(100)

		/*
			Declare @UserId int = 708,
					@Password nvarchar(100) = 'Password1!'


			SELECT [Password]
			FROM dbo.Users
			WHERE Id = @UserId

			Execute dbo.Users_UpdatePasswordV2
										@UserId,
										@Password

			SELECT [Password]
			FROM dbo.Users
			WHERE Id = @UserId

		*/
as
BEGIN
	Update [dbo].[Users]
	SET [Password] = @Password
	WHERE [Id] = @UserId
END
GO
