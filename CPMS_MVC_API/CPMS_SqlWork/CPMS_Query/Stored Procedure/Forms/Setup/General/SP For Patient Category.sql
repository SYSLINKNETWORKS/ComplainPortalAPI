USE phm
go

--Insert
create proc [dbo].[ins_m_patcat](@patcat_nam varchar(250),@patcat_act bit,@patcat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@patcat_id_out int output)
as
declare
@patcat_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @patcat_id=(select max(patcat_id)+1 from m_patcat)
		if @patcat_id is null
			begin
				set @patcat_id=1
			end
	insert into m_patcat(patcat_id,patcat_nam,patcat_act,patcat_typ,log_act,log_dat,usr_id,log_ip)
			values(@patcat_id,@patcat_nam,@patcat_act,@patcat_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @patcat_id_out=@patcat_id
		
		set @log_newval= 'ID=' + cast(@patcat_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_patcat](@patcat_id int,@patcat_nam varchar(250),@patcat_act bit,@patcat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_patcat set patcat_nam=@patcat_nam,patcat_act=@patcat_act,patcat_typ=@patcat_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where patcat_id=@patcat_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_patcat](@patcat_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_patcat set log_act=@log_act where patcat_id=@patcat_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

