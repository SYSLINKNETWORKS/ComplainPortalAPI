USE NATHI

GO
--select * from t_mrec where mvch_no is not null
--select * from m_cus where cus_id=109
--select * from t_mrec where mrec_id=70


declare @mrec_id int
	declare  currec1  cursor for			
			SELECT mrec_id from t_mrec
		OPEN currec1
			FETCH NEXT FROM currec1
			INTO @mrec_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					EXEC sp_voucher_rec @mrec_id
					
					FETCH NEXT FROM currec1
					INTO @mrec_id
		end
		CLOSE currec1
		DEALLOCATE currec1
		GO

