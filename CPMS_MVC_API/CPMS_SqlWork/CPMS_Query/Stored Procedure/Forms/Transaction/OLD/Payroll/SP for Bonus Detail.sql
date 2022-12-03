USE MFI
GO

--Insert
create  proc [dbo].[ins_t_dbonus](@emppro_macid int,@dbonus_sal float,@dbonus_bonper float,@dbonus_bonamt float,@mbonus_id int,@dbonus_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@dbonus_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@dbonus_id			int,
@aud_act			char(20)
begin
	set @dbonus_id =(select max(dbonus_id) from t_dbonus)+1
	set @aud_act='Insert'

	if (@dbonus_id is null)
		begin	
			set @dbonus_id=1
		end

	insert into t_dbonus (dbonus_id,emppro_macid,dbonus_sal,dbonus_bonper,dbonus_bonamt,mbonus_id,dbonus_typ)
	values
	(@dbonus_id,@emppro_macid,@dbonus_sal,@dbonus_bonper,@dbonus_bonamt,@mbonus_id,@dbonus_typ)

	set @dbonus_id_out=@dbonus_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Delete
create proc [dbo].[del_t_dbonus](@com_id char(2),@br_id char(3),@mbonus_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from t_dbonus  
			where mbonus_id=@mbonus_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

