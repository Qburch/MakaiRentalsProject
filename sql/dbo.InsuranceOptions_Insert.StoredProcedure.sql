USE [Makai]
GO
/****** Object:  StoredProcedure [dbo].[InsuranceOptions_Insert]    Script Date: 8/28/2023 10:46:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Quinn Burch
-- Description: Insert proc for Insurace Option for Rental Order (Theft/Lost Protection, Damage Waiver)
-- Code Reviewer: Santi
-- =============================================
CREATE proc [dbo].[InsuranceOptions_Insert]
							@OrderId int,
							@UserId int,
							@Cost int,
							@Id int OUTPUT

		/* 
			Declare @OrderId int = 152,
					@UserId int = 577,
					@Cost int = 25,
					@Id int

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

			Execute dbo.InsuranceOptions_Insert
										@OrderId,
										@UserId,
										@Cost,
										@Id OUTPUT
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

		*/
as
BEGIN
	--- Cancellation Date is set to null by not passing any value (No cancellation date exists for a new entry)

	--- IsActive and IsCancelled are set to their default values 1 and 0, respectively
	--- DateCreated and DateModified are also set their default values of the current datetime
	--- None of the other entries have defaults

	--- StartTime we set to the current datetime
	DECLARE @StartTime datetime2(7) = GETUTCDATE()

	--- EndTime we set to the end of rental time
	DECLARE @EndTime datetime2(7) = (
									SELECT [EstimatedStop]
									From [dbo].[Orders]
									WHERE [Id] = @OrderId
									)

	--- CreatedBy and ModifiedBy are set to the UserId we take in as a parameter			

	INSERT INTO [dbo].[InsuranceOptions]
			   ([OrderId]
			   ,[StartTime]
			   ,[EndTime]
			   ,[Cost]
			   ,[CreatedBy]
			   ,[ModifiedBy]
			   )
		 VALUES
			   (@OrderId,
			   @StartTime,
			   @EndTime,
			   @Cost,
			   @UserId,
			   @UserId)

	SET @Id = SCOPE_IDENTITY()
END





GO
