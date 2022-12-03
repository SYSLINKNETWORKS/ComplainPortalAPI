USE MFI
GO

--Insert
create proc [dbo].[ins_t_empatt](@empatt_dat datetime,@empatt_prd bit,@empatt_ot float,@empatt_typ char(1),@emppro_id int,@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@empatt_id_out int output)
as
declare
@empatt_id			int,
@aud_act			char(20)
begin
	set @empatt_id =(select max(empatt_id) from t_empatt)+1
	set @aud_act='Insert'

	if (@empatt_id is null)
		begin	
			set @empatt_id=1
		end

	insert into t_empatt (empatt_id,empatt_dat,empatt_prd,empatt_ot,empatt_typ,emppro_id)
	values
	(@empatt_id,@empatt_dat,@empatt_prd,@empatt_ot,@empatt_typ,@emppro_id)

	set @empatt_id_out=@empatt_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
create proc [dbo].[del_t_empatt](@com_id char(2),@br_id char(3),@empatt_dat datetime,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from t_empatt  
			where empatt_dat=@empatt_dat
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from m_empatt
