USE MFI
GO

--Delete Packing Issue
ALTER proc [dbo].[sp_miss_stkadj_pack_del] (@mstkadj_id int,@usr_id int,@aud_ip varchar(100))
as
declare @miss_id int
begin

--Delete Previous Record of Packing Transfer 
	declare  delmiss  cursor for
		select  miss_id from t_dstkadj where mstkadj_id=@mstkadj_id
		OPEN delmiss
			FETCH NEXT FROM delmiss
			INTO @miss_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
					exec del_t_miss '01','01',@miss_id,'Delete PACKING Transfer through Stock Ajustment','',0,''
					FETCH NEXT FROM delmiss
					INTO @miss_id
				end
				CLOSE delmiss
				DEALLOCATE delmiss
end

GO


