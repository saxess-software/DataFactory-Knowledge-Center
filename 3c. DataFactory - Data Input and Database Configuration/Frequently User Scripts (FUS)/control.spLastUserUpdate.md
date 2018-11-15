### Snippet for POST_PDTV
after END CATCH

创创SQL

-----------------------------------------------------------------------------------------------------------------------------
-- #### CUSTOMIZATION ########
	IF @FactoryID <> 'ZT'
		BEGIN
			EXEC control.spLastUserUpdate @TransactUsername,@FactoryID ,@ProductLineID,@ProductID			
		END

-----------------------------------------------------------------------------------------------------------------------------

创创