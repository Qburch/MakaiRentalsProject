USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[Orders_SelectByUserId_Paginated]    Script Date: 8/28/2023 10:46:47 AM ******/
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
-- Note: Changed to match new order and orderItems table designs

-- Modified By: Quinn Burch
-- Code Reviewer: Santi
-- Note: Joined insurance price with insurace option table
-- =============================================
CREATE PROC [dbo].[Orders_SelectByUserId_Paginated]
										@UserId int,
										@PageIndex int,
										@PageSize int
		/*
			Declare	@UserId int = 577,
					@PageIndex int = 0,
					@PageSize int = 5

			Execute [dbo].[Orders_SelectByUserId_Paginated] 
													@UserId,
													@PageIndex,
													@PageSize
		*/
AS
BEGIN
	DECLARE @offset int = @PageIndex * @PageSize

	SELECT o.[Id]
		  ,[OrderItems] = (
							SELECT i.[Id] as [id],
									JSON_QUERY((
												SELECT p.[Id] as [id],
													   p.[Name] as [name],
													   p.[ProductTypeId] as [productType],
													   p.[Description] as [description],
													   p.[StandId] as [standId],
													   p.[Identifier] as [identifier],
													   p.[HourlyPriceInCents] as [hourlyPriceInCents]
												FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
												)) as [Product],
									i.[PriceInCents] as [priceInCents],
									i.[PriceWithTax] as [priceWithTax],
									i.[EstimatedStartTime] as [estimatedStartTime],
									i.[EstimatedStopTime] as [estimatedStopTime],
									i.[ActualStartTime] as [actualStartTime],
									i.[ActualStopTime] as [actualStopTime]
							FROM [dbo].[OrderItems] as i inner join dbo.Products as p
																	ON i.[ProductId] = p.[Id]
							WHERE i.[OrderId] = o.[Id]
							FOR JSON PATH
							)
		  ,io.[Cost] as [InsurancePriceInCents]
		  ,o.[TotalPriceInCents]
		  ,o.[TotalPriceWithTax]
		  ,ot.[Id] as [OrderStatusId]
		  ,ot.[Name] as [OrderStatusName]
		  ,c.[Id] as [CreatedById]
		  ,c.[FirstName] as [CreatedByName]
		  ,c.[LastName] as [CreatedByLastName]
		  ,c.[Mi] as [CreatedByMi]
		  ,c.[AvatarUrl] as [CreatedByAvatarUrl]
		  ,m.[Id] as [ModifiedById]
		  ,m.[FirstName] as [ModifiedByName]
		  ,m.[LastName] as [ModifiedByLastName]
		  ,m.[Mi] as [ModifiedByMi]
		  ,m.[AvatarUrl] as [ModifiedByAvatarUrl]
		  ,o.[DateCreated]
		  ,o.[DateModified]
		  ,[TotalCount] = Count(1) Over()
	FROM [dbo].[Orders] as o inner join [dbo].[Users] as c
									ON o.[CreatedBy] = c.[Id]
							  inner join [dbo].[Users] as m
									ON o.[ModifiedBy] = m.[Id]
							  inner join [dbo].[OrderStatusTypes] as ot
									ON o.[OrderStatusId] = ot.[Id]
							  left join [dbo].[InsuranceOptions] as io
									ON io.[OrderId] = o.[Id] AND io.[IsActive] = 1 AND io.[IsCancelled] = 0
	WHERE o.[CreatedBy] = @UserId
	ORDER BY o.[DateCreated] DESC
	OFFSET @Offset Rows
	Fetch Next @PageSize Rows ONLY
END
GO
