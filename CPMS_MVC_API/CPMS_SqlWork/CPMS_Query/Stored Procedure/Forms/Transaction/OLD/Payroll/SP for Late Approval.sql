USE ZSONS
GO

--Insert
alter  proc [dbo].[ins_m_anl](@manl_dat datetime,@emppro_macid int,@manl_app bit,@manl_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@manl_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@manl_id			int,
@aud_act			char(20)
begin
	set @manl_id =(select max(manl_id) from m_anl)+1
	set @aud_act='Insert'

	if (@manl_id is null)
		begin	
			set @manl_id=1
		end

	insert into m_anl (manl_id,manl_dat,emppro_macid,manl_app,manl_typ)
	values
	(@manl_id,@manl_dat,@emppro_macid,@manl_app,@manl_typ)

	set @manl_id_out=@manl_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_m_anl](@manl_id int,@manl_dat datetime,@emppro_macid int,@manl_app bit,@manl_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_anl 
			set manl_dat=@manl_dat,emppro_macid=@emppro_macid,manl_app=@manl_app,manl_typ=@manl_typ
			where manl_id=@manl_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter  proc [dbo].[del_m_anl](@com_id char(2),@br_id char(3),@manl_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_anl  
			where manl_id=@manl_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

