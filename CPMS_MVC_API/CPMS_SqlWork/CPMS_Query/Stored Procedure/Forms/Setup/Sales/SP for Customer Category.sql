USE phm
go

--alter table m_cuscat add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter proc [dbo].[ins_m_cuscat](@cuscat_nam varchar(250),@cuscat_act bit,@cuscat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@cuscat_id_out int output)
as
declare
@cuscat_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @cuscat_id=(select max(cuscat_id)+1 from m_cuscat)
		if @cuscat_id is null
			begin
				set @cuscat_id=1
			end
	insert into m_cuscat(cuscat_id,cuscat_nam,cuscat_act,cuscat_typ,log_act,log_dat,usr_id,log_ip)
			values(@cuscat_id,@cuscat_nam,@cuscat_act,@cuscat_typ,@log_act,@log_dat,@usr_id,@log_ip)
		set @cuscat_id_out=@cuscat_id
		
		set @log_newval= 'ID=' + cast(@cuscat_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_cuscat](@cuscat_id int,@cuscat_nam varchar(250),@cuscat_act bit,@cuscat_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_cuscat set cuscat_nam=@cuscat_nam,cuscat_act=@cuscat_act,cuscat_typ=@cuscat_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where cuscat_id=@cuscat_id
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO


--Delete
alter proc [dbo].[del_m_cuscat](@cuscat_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	
	update m_cuscat set log_act=@log_act  where cuscat_id=@cuscat_id
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		

