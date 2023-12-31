USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[InsuranceOptions_Update]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Update proc for Insurace Option for Rental Order (Theft/Lost Protection, Damage Waiver)
-- Code Reviewer: Santi
-- =============================================
CREATE proc [dbo].[InsuranceOptions_Update]
						@Id int,
						@OrderId int, -- Used to find EndTime of rental. Also for consistency with Insert proc
						@UserId int,  -- Need for ModifiedBy
						@Cost int


		/*

			DECLARE @Id int = 1,
					@UserId int = 576,
					@Cost int = 25

			SELECT [Id]
				  ,[OrderId]
				  ,[StartTime]
				  ,[EndTime]
				  ,[Cost]
				  ,[IsActive]
				  ,[IsCancelled]
				  ,[CancellationDate]
				  ,[CreatedBy]
				  ,[ModifiedBy]
				  ,[DateCreated]
				  ,[DateModified]
			  FROM [dbo].[InsuranceOptions]
			  WHERE Id = @Id


			EXECUTE dbo.Insurance_Update
									@Id,
									@UserId, -- Need for ModifiedBy
									@Cost

			SELECT [Id]
				  ,[OrderId]
				  ,[StartTime]
				  ,[EndTime]
				  ,[Cost]
				  ,[IsActive]
				  ,[IsCancelled]
				  ,[CancellationDate]
				  ,[CreatedBy]
				  ,[ModifiedBy]
				  ,[DateCreated]
				  ,[DateModified]
			  FROM [dbo].[InsuranceOptions]
			  WHERE Id = @Id

		*/
as
BEGIN

	

	--- We set DateModified to the current datetime

	--- Since it is a waiver, they will need to sign it again upon updating (since it's now a new legal document),
	--- hence we need to update the start time by setting it to the current datetime
	DECLARE @DateNow datetime2(7) = GETUTCDATE()

	-- If we allow them to go back and change the endtime and then come back to the form
	-- Then we must update the EndTime for the order
	DECLARE @EndTime datetime2(7) = (
										SELECT [EstimatedStop]
										FROM [dbo].[Orders]
										WHERE [Id] = @OrderId
										)

	Update [dbo].[InsuranceOptions]
	SET [Cost] = @Cost,
		[StartTime] = @DateNow,
		[EndTime] = @EndTime,
		[ModifiedBy] = @UserId,
		[DateModified] = @DateNow
	WHERE [Id] = @Id

	-- The rest of the columns have no need to be updated
		-- OrderId
		-- CreatedBy     
		-- DateCreated
		-- isActive  
		-- isCancelled    
		-- CancellationDate 
END
GO
