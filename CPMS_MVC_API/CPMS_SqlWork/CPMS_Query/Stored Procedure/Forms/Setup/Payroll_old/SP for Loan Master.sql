
USE MFI
GO

--Insert
alter  proc [dbo].[ins_m_loan](@mloan_nam varchar(250),@mloan_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@mloan_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mloan_id			int,
@aud_act			char(20)
begin
	set @mloan_id =(select max(mloan_id) from m_loan)+1
	set @aud_act='Insert'

	if (@mloan_id is null)
		begin	
			set @mloan_id=1
		end

	insert into m_loan (mloan_id,mloan_nam,mloan_typ)
	values
	(@mloan_id,@mloan_nam,@mloan_typ)

	set @mloan_id_out=@mloan_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_m_loan](@mloan_id int,@mloan_nam varchar(250),@mloan_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_loan 
			set mloan_nam=@mloan_nam,mloan_typ=@mloan_typ
			where mloan_id=@mloan_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter  proc [dbo].[del_m_loan](@com_id char(2),@br_id char(3),@mloan_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_loan  
			where mloan_id=@mloan_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

