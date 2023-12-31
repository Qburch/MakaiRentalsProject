USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[InsuranceOptions_DeleteById]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: DeleteById proc for Insurace Option for Rental Order (Theft/Lost Protection, Damage Waiver)
-- Code Reviewer: Santi
-- =============================================
CREATE proc [dbo].[InsuranceOptions_DeleteById]
								@Id int
								,@UserId int --Need for ModifiedBy
	/*
	
		DECLARE @Id int = 1
				,@UserId int = 576

		EXECUTE dbo.InsuranceOptions_SelectById
											@Id

		EXECUTE dbo.InsuranceOptions_DeleteById
											@Id

		EXECUTE dbo.InsuranceOptions_SelectById
											@Id
	*/
as
BEGIN
	-- On Delete, we set isActive to false, isCancelled to true, and CancellationDate to the current datetime

	-- We also set the DateModified to the current datetime
	-- and ModifiedBy to UserId we taekin (presumably the one making the call)

	Declare @DateNow datetime2(7) = GETUTCDATE()

	Update [dbo].[InsuranceOptions]
	SET [IsActive] = 0, -- Should I put into a variable?
		[IsCancelled] = 1, -- Should I put into a variable?
		[CancellationDate] = @DateNow,
		[ModifiedBy] = @UserId,
		[DateModified] = @DateNow
	WHERE [Id] = @Id and [CreatedBy] = @UserId

END
GO
