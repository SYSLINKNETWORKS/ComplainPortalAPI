USE MFI
GO

--alter table m_mac add mac_cat char(100)
--alter table m_mac add mac_act bit
--alter table m_mac add mac_com_id int


--Insert
alter proc [dbo].[ins_m_mac](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mac_nam varchar(250),@mac_ip varchar(100),@mac_prt int,@mac_act bit,@mac_cat char(100),@mac_com_id char(100),@mac_typ char(1),@mac_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mac_id			int,
@aud_act			char(20)
begin
	set @mac_id =(select max(mac_id) from m_mac)+1
	set @aud_act='Insert'

	if (@mac_id is null)
		begin	
			set @mac_id=1
		end

	insert into m_mac (mac_id,mac_nam,mac_ip,mac_prt,mac_typ,mac_act,mac_cat,mac_com_id)
	values(@mac_id,@mac_nam,@mac_ip,@mac_prt,@mac_typ,@mac_act,@mac_cat,@mac_com_id)

	set @mac_id_out=@mac_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter proc [dbo].[upd_m_mac](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mac_id int,@mac_nam varchar(250),@mac_ip varchar(100),@mac_prt int,@mac_act bit,@mac_cat char(100),@mac_com_id char(100),@mac_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_mac 
			set mac_nam=@mac_nam,mac_ip=@mac_ip ,mac_prt=@mac_prt,mac_typ=@mac_typ,mac_act=@mac_act,mac_cat=@mac_cat,mac_com_id=@mac_com_id
			where mac_id=@mac_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter proc [dbo].[del_m_mac](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mac_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_mac  
			where mac_id=@mac_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from m_mac
