USE phm
go


--alter table m_mso add mso_dat datetime

--Insert
alter proc [dbo].[ins_m_mso](@mso_nam varchar(250),@mso_dat datetime,@mso_act bit,@mso_typ char(1),@rm_id int,@sm_id int,@nsm_id int,@mm_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mso_id_out int output)
as
declare
@mso_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @mso_id=(select max(mso_id)+1 from m_mso)
		if @mso_id is null
			begin
				set @mso_id=1
			end
	insert into m_mso(mso_id,mso_nam,mso_dat,mso_act,mso_typ,rm_id,sm_id,nsm_id,mm_id,log_act,log_dat,usr_id,log_ip)
			values(@mso_id,@mso_nam,@mso_dat,@mso_act,@mso_typ,@rm_id,@sm_id,@nsm_id,@mm_id,@log_act,@log_dat,@usr_id,@log_ip)
		set @mso_id_out=@mso_id
		
		set @log_newval= 'ID=' + cast(@mso_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_mso](@mso_id int,@mso_nam varchar(250),@mso_dat datetime,@mso_act bit,@mso_typ char(1),@rm_id int,@sm_id int,@nsm_id int,@mm_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_mso set mso_nam=@mso_nam,mso_dat=@mso_dat,mso_act=@mso_act,mso_typ=@mso_typ,rm_id=@rm_id,sm_id=@sm_id,nsm_id=@nsm_id,mm_id=@mm_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where mso_id=@mso_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
alter proc [dbo].[del_m_mso](@mso_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_mso set log_act=@log_act where mso_id=@mso_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

