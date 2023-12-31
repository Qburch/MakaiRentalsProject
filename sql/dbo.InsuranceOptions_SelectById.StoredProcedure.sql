USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[InsuranceOptions_SelectById]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: SelectById proc for Insurace Option for Rental Order (Theft/Lost Protection, Damage Waiver)
-- Code Reviewer: Santi
-- =============================================
CREATE proc [dbo].[InsuranceOptions_SelectById]
									@Id int

	/*
		DECLARE @Id int = 1

		EXECUTE dbo.InsuranceOptions_SelectById
											@Id
	*/
as
BEGIN

	-- Restricted to Active records

	SELECT i.[Id]
		  ,o.[Id] as OrderId
		  ,o.[StartTime] as OrderStartTime
		  ,o.[EstimatedStop] as OrderEstimatedStop
		  ,o.[ActualStop] as OrderActualStop -- Not sure if I should be getting this here
		  ,o.[PriceInCents] as OrderPriceInCents
		  ,o.[PriceWithTax] as OrderPriceWithTax
		  ,i.[StartTime]
		  ,i.[EndTime]
		  ,i.[Cost]
		  ,i.[IsActive]
		  ,i.[IsCancelled]
		  ,i.[CancellationDate]
		  ,c.[Id] as CreatedById
		  ,c.[FirstName] as CreatedByFirstName
		  ,c.[LastName] as CreatedByLastName
		  ,c.[Email] as CreatedByEmail
		  ,c.[Phone] as CreatedByPhone
		  ,m.[Id] as ModifiedById
		  ,m.[FirstName] as ModifiedByFirstName
		  ,m.[LastName] as ModifiedByLastName
		  ,m.[Email] as ModifiedByEmail
		  ,m.[Phone] as ModifiedByPhone
		  ,i.[DateCreated]
		  ,i.[DateModified]
	  FROM [dbo].[InsuranceOptions] as i left join [dbo].[Orders] as o
												ON i.[OrderId] = o.[Id]
										left join [dbo].[Users] as c
												ON i.[CreatedBy] = c.[Id]
										left join [dbo].[Users] as m
												ON i.[ModifiedBy] = m.[Id]
	  WHERE i.[Id] = @Id and i.[IsActive] = 1

END
GO
