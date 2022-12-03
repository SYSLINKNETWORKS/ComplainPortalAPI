USE phm
go

--Insert
create proc [dbo].[ins_m_gger](@gger_nam varchar(250),@gger_act bit,@gger_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@gger_id_out int output)
as
declare
@gger_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @gger_id=(select max(gger_id)+1 from m_gger)
		if @gger_id is null
			begin
				set @gger_id=1
			end
	insert into m_gger(gger_id,gger_nam,gger_act,gger_typ,log_act,log_dat,usr_id,log_ip)
			values(@gger_id,@gger_nam,@gger_act,@gger_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @gger_id_out=@gger_id
		
		set @log_newval= 'ID=' + cast(@gger_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_gger](@gger_id int,@gger_nam varchar(250),@gger_act bit,@gger_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_gger set gger_nam=@gger_nam,gger_act=@gger_act,gger_typ=@gger_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where gger_id=@gger_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_gger](@gger_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_gger set log_act=@log_act where gger_id=@gger_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

