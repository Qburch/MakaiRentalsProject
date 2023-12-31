USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Orders_SelectPaymentHistory_Paginated]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description:	Gets a paginated response of user's payment history
-- Code Reviewer: Leno

-- Modified By: Quinn Burch
-- Code Reviewer: Santi
-- Note: changed to only bring back neccessary info
-- =============================================
CREATE PROC [dbo].[Orders_SelectPaymentHistory_Paginated]
										@UserId int,
										@PageIndex int,
										@PageSize int

		/*
			Declare	@UserId int = 577,
					@PageIndex int = 0,
					@PageSize int = 5

			Execute [dbo].[Orders_SelectPaymentHistory_Paginated] 
												@UserId,
												@PageIndex,
		 										@PageSize
		*/
AS
BEGIN
	DECLARE @offset int = @PageIndex * @PageSize

	SELECT o.[Id]
		  ,io.[Cost] as [InsurancePriceInCents]
		  ,o.[TotalPriceInCents]
		  ,o.[TotalPriceWithTax]
		  ,s.[PaymentStatus]
		  ,s.[TransactionType]
		  ,s.[DateModified]
		  ,[TotalCount] = Count(1) Over()
	FROM [dbo].[Orders] as o inner join [dbo].[StripeTransactions] as s
									ON o.[StripeSessionId] = s.[StripeSessionId]
							inner join [dbo].[OrderStatusTypes] as ot
									ON o.[OrderStatusId] = ot.[Id]
							left join [dbo].[InsuranceOptions] as io
									ON io.[OrderId] = o.[Id] AND io.[IsActive] = 1 AND io.[IsCancelled] = 0
	WHERE o.[CreatedBy] = @UserId
	ORDER BY s.[DateModified] DESC
	OFFSET @Offset Rows
	Fetch Next @PageSize Rows ONLY
END
GO
