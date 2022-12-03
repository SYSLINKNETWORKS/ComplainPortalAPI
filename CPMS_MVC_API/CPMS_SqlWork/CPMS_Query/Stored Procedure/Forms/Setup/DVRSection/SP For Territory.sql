USE phm
go

--select * from m_terr

--Insert
create proc [dbo].[ins_m_terr](@terr_nam varchar(250),@terr_typ char(1),@reg_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@terr_id_out int output)
as
declare
@terr_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @terr_id=(select max(terr_id)+1 from m_terr)
		if @terr_id is null
			begin
				set @terr_id=1
			end
	insert into m_terr(terr_id,terr_nam,terr_typ,reg_id,log_act,log_dat,usr_id,log_ip)
			values(@terr_id,@terr_nam,@terr_typ,@reg_id,@log_act,@log_dat,@usr_id,@log_ip)
		set @terr_id_out=@terr_id
		
		set @log_newval= 'ID=' + cast(@terr_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_terr](@terr_id int,@terr_nam varchar(250),@terr_typ char(1),@reg_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_terr set terr_nam=@terr_nam,terr_typ=@terr_typ,reg_id=@reg_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where terr_id=@terr_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_terr](@terr_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_terr set log_act=@log_act where terr_id=@terr_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

