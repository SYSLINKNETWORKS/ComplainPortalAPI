USE [MFI]
GO
--exec sp_miss_pack_del 194,1,''

--Delete Packing Issue
ALTER proc [dbo].[sp_miss_pack_del] (@mfg_id int,@usr_id int,@aud_ip varchar(100))
as
declare @miss_id int,
@m_yR_id char(2)
begin
	set @m_yr_id=(select m_yr_id from t_mfg where mfg_id=@mfg_id)
--Delete Previous Record of Packing Transfer 
	declare  delmiss  cursor for
		select  miss_id from t_dfg where mfg_id=@mfg_id
		OPEN delmiss
			FETCH NEXT FROM delmiss
			INTO @miss_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
					exec del_t_miss '01','01',@m_yr_id,@miss_id,'Delete delmiss Transfer through Finish Goods Transfer','',0,''
					FETCH NEXT FROM delmiss
					INTO @miss_id
				end
				CLOSE delmiss
				DEALLOCATE delmiss
end

GO

--exec sp_miss_pack_del 33,1,''
--exec sp_miss_pack 33,'01',1,''




