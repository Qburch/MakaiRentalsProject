USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[OrderItems_SelectByUserId_Paginated]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description:	Select order items by user who created the order
-- Code Reviewer: Leno
-- =============================================
CREATE proc [dbo].[OrderItems_SelectByUserId_Paginated]
									@UserId int,
									@PageIndex int,
									@PageSize int

				/*
					Declare	@UserId int = 577,
					@PageIndex int = 0,
					@PageSize int = 15

					Execute [dbo].[OrderItems_SelectByUserId_Paginated] 
													@UserId,
													@PageIndex,
													@PageSize
				*/
as
BEGIN

	DECLARE @Offset int = @PageIndex * @PageSize

		SELECT i.[Id]
			  ,i.[OrderId]
			  ,[Product] = (
								SELECT p.[Id] as [id],
									    p.[Name] as [name],
										 p.[ProductTypeId] as [productType],
										 p.[Description] as [description],
										 p.[StandId] as [standId],
										 p.[Identifier] as [identifier],
										 p.[HourlyPriceInCents] as [hourlyPriceInCents]
								From [dbo].[Products] as p 
								WHERE i.[ProductId] = p.[Id]
								FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER
							)
			  ,i.[PriceInCents]
			  ,i.[PriceWithTax]
			  ,i.[EstimatedStartTime]
			  ,i.[EstimatedStopTime]
			  ,i.[ActualStartTime]
			  ,i.[ActualStopTime]
			  ,o.[InsurancePriceInCents]
			  ,o.[TotalPriceInCents]
			  ,o.[TotalPriceWithTax]
			  ,ot.[Id] as [OrderStatusId]
			  ,ot.[Name] as [OrderStatusName]
			  ,o.[DateCreated]
			  ,o.[DateModified]
			  ,[TotalCount] = Count(1) Over()
	FROM [dbo].[OrderItems] as i inner join [dbo].[Orders] as o
									ON i.[OrderId] = o.[Id]
								 inner join [dbo].[OrderStatusTypes] as ot
									ON o.[OrderStatusId] = ot.[Id]
	WHERE o.[CreatedBy] = @UserId
	ORDER BY o.[DateCreated] DESC
	OFFSET @Offset Rows
	Fetch Next @PageSize Rows ONLY

END
GO
