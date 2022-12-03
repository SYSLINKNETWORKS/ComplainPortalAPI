USE epharm
GO


--Insert
alter  proc [dbo].[ins_m_destrans](@destrans_dat datetime,@destrans_typ char(1),@emppro_macid int,@memp_sub_id int,@newdes_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@destrans_id_out int output)
as
declare
@destrans_id int,
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @destrans_id =(select max(destrans_id) from m_destrans)+1
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)

	if (@destrans_id is null)
		begin	
			set @destrans_id=1
		end

	insert into m_destrans (destrans_id,destrans_dat,destrans_typ,emppro_id,memp_sub_id,newdes_id,log_act,log_dat,usr_id,log_ip)
	values
	(@destrans_id,@destrans_dat,@destrans_typ,@emppro_id,@memp_sub_id,@newdes_id,@log_act,@log_dat,@usr_id,@log_ip)

	set @destrans_id_out=@destrans_id


set @log_newval= 'ID=' + cast(@destrans_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update

alter proc [dbo].[upd_m_destrans](@destrans_id int,@destrans_dat datetime,@destrans_typ char(1),@emppro_macid int,@memp_sub_id int,@newdes_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@emppro_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	
	update m_destrans 
			set destrans_dat=@destrans_dat,destrans_typ=@destrans_typ,emppro_id=@emppro_id,memp_sub_id=@memp_sub_id,newdes_id=@newdes_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
			where destrans_id=@destrans_id 
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO



--Delete
alter proc [dbo].[del_m_destrans](@destrans_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	delete from m_destrans  
			where destrans_id=@destrans_id

	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO

