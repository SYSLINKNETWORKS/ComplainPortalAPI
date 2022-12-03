USE MFI
GO



--Insert
alter  proc [dbo].[ins_m_holi](@mholi_dat datetime,@mholi_dayact bit,@mholi_rmks varchar(1000),@mholi_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@mholi_id_out int output)
as
declare
@mholi_id			int,
@aud_act			char(20)
begin
	set @mholi_id =(select max(mholi_id) from m_holi)+1
	set @aud_act='Insert'

	if (@mholi_id is null)
		begin	
			set @mholi_id=1
		end

	insert into m_holi (mholi_id,mholi_dat,mholi_dayact,mholi_rmks,mholi_typ)
	values
	(@mholi_id,@mholi_dat,@mholi_dayact,@mholi_rmks,@mholi_typ)

	set @mholi_id_out=@mholi_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_m_holi](@mholi_id int,@mholi_dat datetime,@mholi_rmks varchar(1000),@mholi_dayact bit,@mholi_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_holi 
			set mholi_dat=@mholi_dat,mholi_dayact=@mholi_dayact,mholi_rmks=@mholi_rmks,mholi_typ=@mholi_typ
			where mholi_id=@mholi_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter  proc [dbo].[del_m_holi](@com_id char(2),@br_id char(3),@mholi_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_holi  
			where mholi_id=@mholi_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

