USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Orders_Insert]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Kimberly
-- Description:	Insert [dbo].[Orders] table
-- Code Reviewer: John

-- Modified By: Quinn Burch
-- Code Reviewer: Leno
-- Note: Changed to match new order table design

-- Modified By: Quinn Burch
-- Code Reviewer: Santi
-- Note: Removed insurance price
-- =============================================
CREATE PROC [dbo].[Orders_Insert]
					@UserId int,
					@BatchOrderItems dbo.BatchOrderItems READONLY,
					@TotalPriceInCents int,
					@TotalPriceWithTax decimal = null,
					@StripeSessionId nvarchar(200),
					@OrderStatusId int,
					@Id int OUTPUT
									   					 
		/*
			DECLARE @UserId int = 577,
					@InsurancePriceInCents int = 500,
					@TotalPriceInCents int = 3398,
					@TotalPriceWithTax DECIMAL = null,
					@StripeSessionId nvarchar(200) = 'testSession',
					@OrderStatusId int = 1,
					@Id int

			DECLARE @BatchOrderItems dbo.BatchOrderItems 

			Insert Into @BatchOrderItems ([ProductId]
											,[PriceInCents]
											,[PriceWithTax]
											,[EstimatedStartTime]
											,[EstimatedStopTime]
											)
			VALUES (12, 1299, null, '2023-05-01 10:00', '2023-05-01 12:00')

			EXECUTE [dbo].[Orders_Insert]
					@UserId,
					@BatchOrderItems,
					@TotalPriceInCents,
					@TotalPriceWithTax,
					@StripeSessionId,
					@OrderStatusId,
					@Id OUTPUT
			
			Execute dbo.Orders_SelectById @Id 
		*/
AS
BEGIN
	DECLARE @DateNow datetime2(7) = GETUTCDATE()

    INSERT INTO [dbo].[Orders]
        ([TotalPriceInCents],
        [TotalPriceWithTax],
        [OrderStatusId],
		[StripeSessionId],
		[CreatedBy],
		[ModifiedBy],
		[DateCreated],
		[DateModified]
		)

    VALUES 
        (@TotalPriceInCents,
        @TotalPriceWithTax,
		@OrderStatusId,
		@StripeSessionId,
		@UserId,
        @UserId,
        @DateNow,
		@DateNow)
        
    SET @Id = SCOPE_IDENTITY()

	INSERT INTO dbo.OrderItems ([OrderId]
								,[ProductId]
								,[PriceInCents]
								,[PriceWithTax]
								,[EstimatedStartTime]
								,[EstimatedStopTime]
								)
	SELECT @Id
			,b.[ProductId]
			,b.[PriceInCents]
			,b.[PriceWithTax]
			,b.[EstimatedStartTime]
			,b.[EstimatedStopTime]
	FROM @BatchOrderItems as b
END
GO
