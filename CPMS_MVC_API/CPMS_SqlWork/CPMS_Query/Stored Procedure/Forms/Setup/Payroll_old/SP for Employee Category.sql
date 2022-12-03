USE MFI
GO

--Insert
create  proc [dbo].[ins_m_empcat](@mempcat_nam varchar(250),@mempcat_snam varchar(100),@mempcat_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@mempcat_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mempcat_id			int,
@aud_act			char(20)
begin
	set @mempcat_id =(select max(mempcat_id) from m_empcat)+1
	set @aud_act='Insert'

	if (@mempcat_id is null)
		begin	
			set @mempcat_id=1
		end

	insert into m_empcat (mempcat_id,mempcat_nam,mempcat_snam,mempcat_typ)
	values
	(@mempcat_id,@mempcat_nam,@mempcat_snam,@mempcat_typ)

	set @mempcat_id_out=@mempcat_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

create proc [dbo].[upd_m_empcat](@mempcat_id int,@mempcat_nam varchar(250),@mempcat_snam varchar(100),@mempcat_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_empcat 
			set mempcat_nam=@mempcat_nam,mempcat_snam=@mempcat_snam,mempcat_typ=@mempcat_typ
			where mempcat_id=@mempcat_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
create proc [dbo].[del_m_empcat](@com_id char(2),@br_id char(3),@mempcat_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_empcat  
			where mempcat_id=@mempcat_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

