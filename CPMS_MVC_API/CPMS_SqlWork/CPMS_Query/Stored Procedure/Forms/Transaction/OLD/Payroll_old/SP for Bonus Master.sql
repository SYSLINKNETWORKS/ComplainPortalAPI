
USE ZSONS
GO

--Insert
alter proc [dbo].[ins_t_mbonus](@mbonus_dat datetime,@mbonus_mdat datetime,@mbonus_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@mbonus_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mbonus_id			int,
@aud_act			char(20)
begin
	set @mbonus_id =(select max(mbonus_id) from t_mbonus)+1
	set @aud_act='Insert'

	if (@mbonus_id is null)
		begin	
			set @mbonus_id=1
		end

	insert into t_mbonus (mbonus_id,mbonus_dat,mbonus_mdat,m_yr_id,mbonus_typ)
	values
	(@mbonus_id,@mbonus_dat,@mbonus_mdat,@m_yr_id,@mbonus_typ)

	set @mbonus_id_out=@mbonus_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_t_mbonus](@mbonus_id int,@mbonus_dat datetime,@mbonus_mdat datetime,@mbonus_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update t_mbonus 
			set mbonus_dat=@mbonus_dat,mbonus_mdat=@mbonus_mdat,m_yr_id=@m_yr_id,mbonus_typ=@mbonus_typ
			where mbonus_id=@mbonus_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter proc [dbo].[del_t_mbonus](@com_id char(2),@br_id char(3),@mbonus_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	exec del_t_dbonus @com_id,@br_id,@mbonus_id,@m_yr_id,@usr_id,@aud_frmnam,@aud_des,@aud_ip
	delete from t_mbonus  
			where mbonus_id=@mbonus_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

