USE phm
go

--alter table m_coun add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter proc [dbo].[ins_m_coun](@coun_nam varchar(250),@coun_act bit,@coun_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@coun_id_out int output)
as
declare
@coun_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @coun_id=(select max(coun_id)+1 from m_coun)
		if @coun_id is null
			begin
				set @coun_id=1
			end
	insert into m_coun(coun_id,coun_nam,coun_act,coun_typ,log_act,log_dat,usr_id,log_ip)
			values(@coun_id,@coun_nam,@coun_act,@coun_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @coun_id_out=@coun_id
		
		set @log_newval= 'ID=' + cast(@coun_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_coun](@coun_id int,@coun_nam varchar(250),@coun_act bit,@coun_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_coun set coun_nam=@coun_nam,coun_act=@coun_act,coun_typ=@coun_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where coun_id=@coun_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
alter proc [dbo].[del_m_coun](@coun_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_coun set log_act=@log_act where coun_id=@coun_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

