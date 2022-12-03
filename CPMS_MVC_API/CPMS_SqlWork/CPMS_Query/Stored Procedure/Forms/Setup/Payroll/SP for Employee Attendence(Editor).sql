USE MFI
GO
--alter table checkinout add ckinout_st bit,check_typ char(1)


--Insert
alter proc [dbo].[ins_t_empattedit](@userid int,@checktime datetime,@empatt_typ char,@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@empatt_id_out int output)
as
declare
@empatt_id int,
@emppro_macid int,
@aud_act char(20)
begin
	set @aud_act='Insert'
	set @emppro_macid=(select emppro_userid from m_emppro where emppro_macid=@userid)

	if (@empatt_id is null)
		begin	
			set @empatt_id=1
		end

	insert into checkinout (userid,checktime,ckinout_st,check_typ)
	values
	(@emppro_macid,@checktime,1,@empatt_typ)

	set @empatt_id_out=@empatt_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter proc [dbo].[del_t_empattedit](@com_id char(2),@br_id char(3),@empatt_dat datetime,@userid int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from checkinout where checktime=@empatt_dat and userid=@userid and check_typ='U'
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

