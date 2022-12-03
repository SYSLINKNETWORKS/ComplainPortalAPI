USE phm
go


--alter table m_doccat add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)


--Insert
alter proc [dbo].[ins_m_doccat](@doccat_nam varchar(250),@doccat_act bit,@doccat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@doccat_id_out int output)
as
declare
@doccat_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @doccat_id=(select max(doccat_id)+1 from m_doccat)
		if @doccat_id is null
			begin
				set @doccat_id=1
			end
	insert into m_doccat(doccat_id,doccat_nam,doccat_act,doccat_typ,log_act,log_dat,usr_id,log_ip)
			values(@doccat_id,@doccat_nam,@doccat_act,@doccat_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @doccat_id_out=@doccat_id
		
		set @log_newval= 'ID=' + cast(@doccat_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_doccat](@doccat_id int,@doccat_nam varchar(250),@doccat_act bit,@doccat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_doccat set doccat_nam=@doccat_nam,doccat_act=@doccat_act,doccat_typ=@doccat_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where doccat_id=@doccat_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
alter proc [dbo].[del_m_doccat](@doccat_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_doccat set log_act=@log_act where doccat_id=@doccat_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

