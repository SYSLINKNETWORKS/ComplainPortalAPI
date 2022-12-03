USE NATHI

GO
--select * from t_minv where mvch_no is not null
--select * from m_cus where cus_id=109


declare @minv_id int
	declare  currec1  cursor for			
			SELECT minv_id from t_minv
		OPEN currec1
			FETCH NEXT FROM currec1
			INTO @minv_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					EXEC sp_voucher_inv @minv_id
					
					FETCH NEXT FROM currec1
					INTO @minv_id
		end
		CLOSE currec1
		DEALLOCATE currec1
		GO

