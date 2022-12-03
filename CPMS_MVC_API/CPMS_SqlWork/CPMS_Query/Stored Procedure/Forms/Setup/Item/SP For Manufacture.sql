USE phm
go

--Insert
create proc [dbo].[ins_m_man](@man_nam varchar(250),@man_act bit,@man_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@man_id_out int output)
as
declare
@man_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @man_id=(select max(man_id)+1 from m_man)
		if @man_id is null
			begin
				set @man_id=1
			end
	insert into m_man(man_id,man_nam,man_act,man_typ,log_act,log_dat,usr_id,log_ip)
			values(@man_id,@man_nam,@man_act,@man_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @man_id_out=@man_id
		
		set @log_newval= 'ID=' + cast(@man_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_man](@man_id int,@man_nam varchar(250),@man_act bit,@man_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_man set man_nam=@man_nam,man_act=@man_act,man_typ=@man_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where man_id=@man_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_man](@man_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_man set log_act=@log_act where man_id=@man_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

