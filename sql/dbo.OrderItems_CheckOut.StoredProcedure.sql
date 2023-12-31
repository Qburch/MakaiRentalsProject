USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[OrderItems_CheckOut]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description:	Proc for user to check out their order - sets the actual start time
-- Code Reviewer: Amanda
-- =============================================
CREATE proc [dbo].[OrderItems_CheckOut]
							@UserId int,
							@Id int

			/*
				DECLARE @UserId int = 577
						,@Id int = 1

				SELECT [Id]
					  ,[OrderId]
					  ,[ProductId]
					  ,[PriceInCents]
					  ,[PriceWithTax]
					  ,[EstimatedStartTime]
					  ,[EstimatedStopTime]
					  ,[ActualStartTime]
					  ,[ActualStopTime]
				FROM [dbo].[OrderItems]
				WHERE Id = @Id

				EXECUTE dbo.OrderItems_CheckOut
										@UserId,
										@Id

				SELECT [Id]
					  ,[OrderId]
					  ,[ProductId]
					  ,[PriceInCents]
					  ,[PriceWithTax]
					  ,[EstimatedStartTime]
					  ,[EstimatedStopTime]
					  ,[ActualStartTime]
					  ,[ActualStopTime]
				FROM [dbo].[OrderItems]
				WHERE Id = @Id

			*/

as
BEGIN
	DECLARE @DateNow datetime2(7) = GETUTCDATE()

	Update dbo.OrderItems
	SET [ActualStartTime] = @DateNow
	WHERE Id = @Id

	DECLARE @OrderId int = (	
								SELECT OrderId
								FROM dbo.OrderItems
								WHERE Id = @Id
							)

	Update dbo.Orders
	SET [DateModified] = @DateNow,
		[ModifiedBy] = @UserId
	WHERE Id = @OrderId				
END
GO
