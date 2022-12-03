USE MFI
GO



--Insert
alter proc [dbo].[ins_m_empall](@emppro_id int,@all_id int,@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@empall_id			int,
@aud_act			char(20)
begin
	set @empall_id =(select max(empall_id) from m_empall)+1
	set @aud_act='Insert'

	if (@empall_id is null)
		begin	
			set @empall_id=1
		end

	insert into m_empall (empall_id,emppro_id,all_id)
	values
	(@empall_id,@emppro_id,@all_id)


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--Delete
alter proc [dbo].[del_m_empall](@emppro_id int,@com_id char(2),@br_id char(3),@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_empall  
			where emppro_id=@emppro_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO
