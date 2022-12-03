USE phm
go

--Insert
create proc [dbo].[ins_m_str](@str_nam varchar(250),@str_act bit,@str_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@str_id_out int output)
as
declare
@str_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @str_id=(select max(str_id)+1 from m_str)
		if @str_id is null
			begin
				set @str_id=1
			end
	insert into m_str(str_id,str_nam,str_act,str_typ,log_act,log_dat,usr_id,log_ip)
			values(@str_id,@str_nam,@str_act,@str_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @str_id_out=@str_id
		
		set @log_newval= 'ID=' + cast(@str_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_str](@str_id int,@str_nam varchar(250),@str_act bit,@str_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_str set str_nam=@str_nam,str_act=@str_act,str_typ=@str_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where str_id=@str_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_str](@str_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_str set log_act=@log_act where str_id=@str_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

