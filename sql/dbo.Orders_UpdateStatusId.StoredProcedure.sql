USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Orders_UpdateStatusId]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	David
-- Description:	 This is to update OrderStatus after successful payment, or when only StatusId needs to be updated.
-- Code Reviewer: John

-- Modified By: Quinn Burch
-- Code Reviewer: Leno
-- Note: changed to updating ModifiedBy column with the UserId to match new table design
-- =============================================
		
CREATE Proc [dbo].[Orders_UpdateStatusId]
										@Id int,
										@UserId int,
										@StatusId int
		/*
			DECLARE @Id int = 84,
					@UserId int = 577
					@StatusId int = 2

			SELECT [Id]
				  ,[OrderStatusId]
				  ,[TotalPriceInCents]
				  ,[TotalPriceWithTax]
				  ,[StripeSessionId]
				  ,[CreatedBy]
				  ,[ModifiedBy]
				  ,[DateCreated]
				  ,[DateModified]
			FROM [dbo].[Orders]
			WHERE Id = @Id

			EXECUTE [dbo].[Orders_UpdateStatusId]
												@UserId,
												@Id,
												@StatusId
												
			SELECT [Id]
				  ,[OrderStatusId]
				  ,[TotalPriceInCents]
				  ,[TotalPriceWithTax]
				  ,[StripeSessionId]
				  ,[CreatedBy]
				  ,[ModifiedBy]
				  ,[DateCreated]
				  ,[DateModified]
			FROM [dbo].[Orders]
			WHERE Id = @Id
		*/
AS

BEGIN

	DECLARE @DateModified datetime2(7) = getutcdate();
	
	Update dbo.Orders
	SET [ModifiedBy] = @UserId,
			[OrderStatusId] = @StatusId,
			[DateModified] = @DateModified
	WHERE Id = @Id

END
GO
