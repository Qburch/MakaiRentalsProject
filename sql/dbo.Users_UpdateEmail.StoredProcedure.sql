USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Users_UpdateEmail]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description:	Update User's email if email is not already in use
-- Code Reviewer: Dan
-- =============================================
CREATE proc [dbo].[Users_UpdateEmail]
					@Id int,
					@Email nvarchar(255)
	/*
			Declare @Id int = 708,
					@Email nvarchar(255) = 'jessiejj@dispostable.com'

			Execute dbo.Users_SelectById @Id

			Execute dbo.Users_UpdateEmail
								@Id,
								@Email

			Execute dbo.Users_SelectById @Id
	*/
as
BEGIN

	IF NOT EXISTS ( 
					SELECT 1
					FROM dbo.Users
					WHERE [Email] = @Email AND [Id] <> @Id
				  )
	BEGIN
	Update dbo.Users
	SET [Email] = @Email
	WHERE [Id] = @Id
	END
	ELSE
	THROW 51000, 'Email is already in use. Please try again.', 1;
END
GO
