USE phm
go

--select * from m_reg

--Insert
create proc [dbo].[ins_m_reg](@reg_nam varchar(250),@reg_typ char(1),@zone_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@reg_id_out int output)
as
declare
@reg_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @reg_id=(select max(reg_id)+1 from m_reg)
		if @reg_id is null
			begin
				set @reg_id=1
			end
	insert into m_reg(reg_id,reg_nam,reg_typ,zone_id,log_act,log_dat,usr_id,log_ip)
			values(@reg_id,@reg_nam,@reg_typ,@zone_id,@log_act,@log_dat,@usr_id,@log_ip)
		set @reg_id_out=@reg_id
		
		set @log_newval= 'ID=' + cast(@reg_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_reg](@reg_id int,@reg_nam varchar(250),@reg_typ char(1),@zone_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_reg set reg_nam=@reg_nam,reg_typ=@reg_typ,zone_id=@zone_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where reg_id=@reg_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_reg](@reg_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_reg set log_act=@log_act where reg_id=@reg_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

