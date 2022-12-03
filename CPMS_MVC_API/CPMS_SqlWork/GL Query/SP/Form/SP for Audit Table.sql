USE [zsons]
GO

ALTER proc [dbo].[sp_ins_aud1](@com_id char(2),@br_id char(3),@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_act varchar(20),@aud_ip varchar(100))
as
declare @aud_dat datetime
begin	
	set @aud_dat =(select getdate())
	insert into tbl_aud1
	(com_id,br_id,aud_frmnam,aud_des,usr_id,aud_act,aud_dat,aud_ip)
	values
	(@com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_dat,@aud_ip)
end


GO


