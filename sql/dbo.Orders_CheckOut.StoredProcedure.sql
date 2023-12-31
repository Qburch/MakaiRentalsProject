USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Orders_CheckOut]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Quinn Burch
-- Description:	Proc for user to check back in all items in their order
-- Code Reviewer: Amanda
-- =============================================
CREATE proc [dbo].[Orders_CheckOut]
					@UserId int,
					@Id int

		/*
		DECLARE @UserId int = 577
				,@Id int = 88

		Execute dbo.Orders_SelectById @Id

		Execute dbo.Orders_CheckOut
								@UserId,
								@Id

		Execute dbo.Orders_SelectById @Id

		*/

as
BEGIN
	DECLARE @DateNow datetime2(7) = getutcdate()

	Update dbo.OrderItems
	SET [ActualStartTime] = @DateNow
	WHERE [OrderId] = @Id

	Update dbo.Orders
	SET [DateModified] = @DateNow
		,[ModifiedBy] = @UserId
	WHERE Id = @Id
END
GO
