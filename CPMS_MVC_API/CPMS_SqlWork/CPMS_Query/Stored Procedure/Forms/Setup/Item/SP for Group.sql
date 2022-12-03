USE phm
GO


--Insert
create proc [dbo].[ins_m_grp](@grp_nam varchar(250),@grp_act bit,@grp_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@grp_id_out int output)
as
declare
@grp_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @grp_id=(select MAX(grp_id)+1 from m_grp)
	if @grp_id is null
		begin
			set @grp_id=1
		end
		
	insert into m_grp(grp_id,grp_nam,grp_act,grp_typ,log_act,log_dat,usr_id,log_ip)
	values(@grp_id,@grp_nam,@grp_act,@grp_typ,@log_act,@log_dat,@usr_id,@log_ip)
	set @grp_id_out=@grp_id
	
	set @log_newval='ID=' + CAST(@grp_id as varchar) + '-' + CAST(@log_newval as varchar(max))
	
	--Audit
	exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end
GO

--Update
create proc [dbo].[upd_m_grp](@grp_id int,@grp_nam varchar(250),@grp_act bit,@grp_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_grp set grp_nam=@grp_nam,grp_act=@grp_act,grp_typ=@grp_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
	where grp_id=@grp_id
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat  
		
end
go

--Delete
create proc [dbo].[del_m_grp](@grp_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_grp set log_act=@log_act where grp_id=@grp_id
	
	--Audit
	exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end