USE MFI
GO

--Insert
create  proc [dbo].[ins_m_inoutcat](@inoutcat_nam varchar(250),@inoutcat_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@inoutcat_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@inoutcat_id			int,
@aud_act			char(20)
begin
	set @inoutcat_id =(select max(inoutcat_id) from m_inoutcat)+1
	set @aud_act='Insert'

	if (@inoutcat_id is null)
		begin	
			set @inoutcat_id=1
		end

	insert into m_inoutcat (inoutcat_id,inoutcat_nam,inoutcat_typ)
	values
	(@inoutcat_id,@inoutcat_nam,@inoutcat_typ)

	set @inoutcat_id_out=@inoutcat_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

create proc [dbo].[upd_m_inoutcat](@inoutcat_id int,@inoutcat_nam varchar(250),@inoutcat_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_inoutcat 
			set inoutcat_nam=@inoutcat_nam,inoutcat_typ=@inoutcat_typ
			where inoutcat_id=@inoutcat_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--Delete
create proc [dbo].[del_m_inoutcat](@com_id char(2),@br_id char(3),@inoutcat_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_inoutcat  
			where inoutcat_id=@inoutcat_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

