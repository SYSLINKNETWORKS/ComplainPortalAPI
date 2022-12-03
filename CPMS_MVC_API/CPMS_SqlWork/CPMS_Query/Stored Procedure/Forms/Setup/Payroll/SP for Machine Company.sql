
USE MFI
GO

--Insert
create  proc [dbo].[ins_m_mac_com](@mac_com_nam varchar(250),@mac_com_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@mac_com_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mac_com_id			int,
@aud_act			char(20)
begin
	set @mac_com_id =(select max(mac_com_id) from m_mac_com)+1
	set @aud_act='Insert'

	if (@mac_com_id is null)
		begin	
			set @mac_com_id=1
		end

	insert into m_mac_com (mac_com_id,mac_com_nam,mac_com_typ)
	values
	(@mac_com_id,@mac_com_nam,@mac_com_typ)

	set @mac_com_id_out=@mac_com_id


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

create  proc [dbo].[upd_m_mac_com](@mac_com_id int,@mac_com_nam varchar(250),@mac_com_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_mac_com 
			set mac_com_nam=@mac_com_nam,mac_com_typ=@mac_com_typ
			where mac_com_id=@mac_com_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
create  proc [dbo].[del_m_mac_com](@com_id char(2),@br_id char(3),@mac_com_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_mac_com  
			where mac_com_id=@mac_com_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

