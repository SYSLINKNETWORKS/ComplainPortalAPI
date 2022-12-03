USE zsons
go

--cussubcat_id int ,cussubcat_nam varchar(100)
--alter table m_cussubcat add cussubcat_typ char(1)
--alter table m_cussubcat add cussubcat_act bit 
--Insert
alter proc [dbo].[ins_m_cussubcat](@cussubcat_nam varchar(100),@cussubcat_typ char(1),@cussubcat_act bit,@com_id char(2),@br_id char(2),@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_ip varchar(100),@cussubcat_id_out int output)
as
declare
@cussubcat_id int,
@aud_act char(20)
begin
	set @aud_act='Insert'
	set @cussubcat_id=(select max(cussubcat_id)+1 from m_cussubcat)
		if @cussubcat_id is null
			begin
				set @cussubcat_id=1
			end
			
	insert into m_cussubcat(cussubcat_id,cussubcat_nam,cussubcat_typ,cussubcat_act)
			values(@cussubcat_id,@cussubcat_nam,@cussubcat_typ,@cussubcat_act)
		set @cussubcat_id_out=@cussubcat_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_m_cussubcat](@cussubcat_id int,@cussubcat_nam varchar(250),@cussubcat_typ char(1),@cussubcat_act bit,@com_id char(2),@br_id char(2),@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
set @aud_act='Update'
	update m_cussubcat set cussubcat_nam=@cussubcat_nam,cussubcat_typ=@cussubcat_typ,cussubcat_act=@cussubcat_act
	where cussubcat_id=@cussubcat_id
	
	
	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--Delete
alter proc [dbo].[del_m_cussubcat](@cussubcat_id int,@com_id char(2),@br_id char(2),@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	
	delete m_cussubcat where cussubcat_id=@cussubcat_id
	
	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
Go
		

--select * from m_cussubcat
--update m_cussubcat set cussubcat_act = 1
