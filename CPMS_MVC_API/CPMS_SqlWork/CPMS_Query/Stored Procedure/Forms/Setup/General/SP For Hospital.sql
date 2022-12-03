USE phm
go


--alter table m_hos add hos_add varchar(1000),hos_pho varchar(100),hos_eml varchar(100)


--Insert
alter proc [dbo].[ins_m_hos](@hos_nam varchar(250),@hos_act bit,@hos_typ char(1),@hos_add varchar(1000),@hos_pho varchar(100),@hos_eml varchar(100),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@hos_id_out int output)
as
declare
@hos_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @hos_id=(select max(hos_id)+1 from m_hos)
		if @hos_id is null
			begin
				set @hos_id=1
			end
	insert into m_hos(hos_id,hos_nam,hos_act,hos_typ,hos_add,hos_pho,hos_eml,log_act,log_dat,usr_id,log_ip)
			values(@hos_id,@hos_nam,@hos_act,@hos_typ,@hos_add,@hos_pho,@hos_eml,@log_act,@log_dat,@usr_id,@log_ip)
		set @hos_id_out=@hos_id
		
		set @log_newval= 'ID=' + cast(@hos_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_hos](@hos_id int,@hos_nam varchar(250),@hos_act bit,@hos_typ char(1),@hos_add varchar(1000),@hos_pho varchar(100),@hos_eml varchar(100),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_hos set hos_nam=@hos_nam,hos_act=@hos_act,hos_typ=@hos_typ,hos_add=@hos_add,hos_pho=@hos_pho,hos_eml=@hos_eml,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where hos_id=@hos_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
alter proc [dbo].[del_m_hos](@hos_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_hos set log_act=@log_act where hos_id=@hos_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

