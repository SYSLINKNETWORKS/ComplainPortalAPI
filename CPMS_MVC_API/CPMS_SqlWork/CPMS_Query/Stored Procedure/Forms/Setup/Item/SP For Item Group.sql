USE phm
go

--Insert
create proc [dbo].[ins_m_itmgp](@itmgp_nam varchar(250),@itmgp_act bit,@itmgp_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@itmgp_id_out int output)
as
declare
@itmgp_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @itmgp_id=(select max(itmgp_id)+1 from m_itmgp)
		if @itmgp_id is null
			begin
				set @itmgp_id=1
			end
	insert into m_itmgp(itmgp_id,itmgp_nam,itmgp_act,itmgp_typ,log_act,log_dat,usr_id,log_ip)
			values(@itmgp_id,@itmgp_nam,@itmgp_act,@itmgp_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @itmgp_id_out=@itmgp_id
		
		set @log_newval= 'ID=' + cast(@itmgp_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
create proc [dbo].[upd_m_itmgp](@itmgp_id int,@itmgp_nam varchar(250),@itmgp_act bit,@itmgp_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_itmgp set itmgp_nam=@itmgp_nam,itmgp_act=@itmgp_act,itmgp_typ=@itmgp_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where itmgp_id=@itmgp_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
create proc [dbo].[del_m_itmgp](@itmgp_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_itmgp set log_act=@log_act where itmgp_id=@itmgp_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

