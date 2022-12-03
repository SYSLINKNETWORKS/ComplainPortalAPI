USE PAGEY
GO

--delete from m_bd



declare @bd_nam varchar(250),@bd_idold varchar(1000)
	declare  brand1  cursor for			
			SELECT CompanyID,rtrim(Companyname) FROM primeagencies.dbo.company 
		OPEN brand1
			FETCH NEXT FROM brand1
			INTO @bd_idold,@bd_nam
				WHILE @@FETCH_STATUS = 0
				BEGIN
					exec ins_m_bd @bd_nam ,1,'U',0,@bd_idold,'' 
							
					FETCH NEXT FROM brand1
					INTO @bd_idold,@bd_nam

		end
		CLOSE brand1
		DEALLOCATE brand1
		GO
--select * from gl_m_acc where acc_id='0302007'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
