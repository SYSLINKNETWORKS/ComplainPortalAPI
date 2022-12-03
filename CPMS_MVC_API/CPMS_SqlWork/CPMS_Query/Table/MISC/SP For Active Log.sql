USE phm
GO



alter proc [dbo].[sp_ins_log](@log_frmnam varchar(1024),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_oldval text,@log_newval text,@log_dat datetime output)
as
begin	
	
	
	insert into act_log
	(log_frmnam,log_act,usr_id,log_ip,log_oldval,log_newval,log_dat)
	values
	(@log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat)
	
end


GO


