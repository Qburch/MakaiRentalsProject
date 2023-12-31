USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Orders_Update]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Kimberly
-- Description:	 Orders vanilla update
-- Code Reviewer: John

-- Modified By: Quinn Burch
-- Code Reviewer: Leno
-- Note: changed to match new order table design 

-- Modified By: Quinn Burch
-- Code Reviewer: Santi
-- Note: removed insurance price
-- =============================================
CREATE Proc [dbo].[Orders_Update]
			@Id int,
			@UserId int,
			@TotalPriceInCents int,
			@TotalPriceWithTax decimal = null,
			@StripeSessionId nvarchar(200),
			@OrderStatusId int

			/*
				Declare @Id int = 84,
						@UserId int = 8,
						@TotalPriceInCents int = 19990,
						@TotalPriceWithTax DECIMAL = null,
						@StripeSessionId nvarchar(200) =  'cs_test_a1I7FhtQnNVcdu07QTpXQlu3Ch8jXWbS0rXnNyQ5YGji9sZAxGv0vqJazD',
						@OrderStatudId int = 2
				
				Select [Id]
					  ,[OrderStatusId]
					  ,[TotalPriceInCents]
					  ,[TotalPriceWithTax]
					  ,[StripeSessionId]
					  ,[CreatedBy]
					  ,[ModifiedBy]
					  ,[DateCreated]
					  ,[DateModified]
				From [dbo].[Orders]
				Where [Id] = @Id	

				Execute dbo.Orders_Update 
									@Id,
									@UserId,
									@TotalPriceInCents,
									@TotalPriceWithTax,
									@StripeSessionId,
									@OrderStatudId

				Select [Id]
					  ,[OrderStatusId]
					  ,[TotalPriceInCents]
					  ,[TotalPriceWithTax]
					  ,[StripeSessionId]
					  ,[CreatedBy]
					  ,[ModifiedBy]
					  ,[DateCreated]
					  ,[DateModified]
				From [dbo].[Orders]
				Where [Id] = @Id	
			*/
as
BEGIN
	
	DECLARE @DateModified datetime2(7) = getutcdate();
	
	UPDATE [dbo].[Orders]
	   SET [TotalPriceInCents] = @TotalPriceInCents
		  ,[TotalPriceWithTax] = @TotalPriceWithTax
		  ,[StripeSessionId] = @StripeSessionId
		  ,[OrderStatusId] = @OrderStatusId
		  ,[ModifiedBy] = @UserId
		  ,[DateModified] = @DateModified
	 WHERE [Id] = @Id
END
GO
