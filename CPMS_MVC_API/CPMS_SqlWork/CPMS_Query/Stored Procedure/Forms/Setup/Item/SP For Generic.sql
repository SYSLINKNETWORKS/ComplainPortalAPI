USE phm
go

--alter table m_ger add gger_id int
--alter table m_ger add constraint FK_MGER_GGERID foreign key (gger_id) references m_gger(gger_id)
--select * from m_ger
--update m_ger set gger_id=1

--Insert
alter proc [dbo].[ins_m_ger](@ger_nam varchar(250),@ger_act bit,@ger_typ char(1),@gger_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@ger_id_out int output)
as
declare
@ger_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @ger_id=(select max(ger_id)+1 from m_ger)
		if @ger_id is null
			begin
				set @ger_id=1
			end
	insert into m_ger(ger_id,ger_nam,ger_act,ger_typ,gger_id,log_act,log_dat,usr_id,log_ip)
			values(@ger_id,@ger_nam,@ger_act,@ger_typ,@gger_id,@log_act,@log_dat,@usr_id,@log_ip)
		set @ger_id_out=@ger_id
		
		set @log_newval= 'ID=' + cast(@ger_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_ger](@ger_id int,@ger_nam varchar(250),@ger_act bit,@ger_typ char(1),@gger_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_ger set ger_nam=@ger_nam,ger_act=@ger_act,ger_typ=@ger_typ,gger_id=@gger_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where ger_id=@ger_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
alter proc [dbo].[del_m_ger](@ger_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_ger set log_act=@log_act where ger_id=@ger_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

