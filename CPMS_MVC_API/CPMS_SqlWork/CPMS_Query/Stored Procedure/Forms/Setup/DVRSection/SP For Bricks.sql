USE phm
go

--select * from m_brk

--Insert
create proc [dbo].[ins_m_brk](@brk_nam varchar(250),@brk_typ char(1),@terr_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@brk_id_out int output)
as
declare
@brk_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @brk_id=(select max(brk_id)+1 from m_brk)
		if @brk_id is null
			begin
				set @brk_id=1
			end
	insert into m_brk(brk_id,brk_nam,brk_typ,terr_id,log_act,log_dat,usr_id,log_ip)
			values(@brk_id,@brk_nam,@brk_typ,@terr_id,@log_act,@log_dat,@usr_id,@log_ip)
		set @brk_id_out=@brk_id
		
		set @log_newval= 'ID=' + cast(@brk_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_brk](@brk_id int,@brk_nam varchar(250),@brk_typ char(1),@terr_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_brk set brk_nam=@brk_nam,brk_typ=@brk_typ,terr_id=@terr_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where brk_id=@brk_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_brk](@brk_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_brk set log_act=@log_act where brk_id=@brk_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

