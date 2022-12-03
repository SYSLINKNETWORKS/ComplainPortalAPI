USE phm
GO
--alter table m_mspo add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
create proc ins_m_mspo(@mspo_dat datetime,@mspo_typ char(1),@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mspo_id_out int output)
as
declare
@mspo_id int,
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @mspo_id=(select max(mspo_id)+1 from m_mspo)
		if @mspo_id is null
			begin
				set @mspo_id=1
			end
	insert into m_mspo(mspo_id,mspo_dat,mspo_typ,emppro_id,log_act,log_dat,usr_id,log_ip)
					values (@mspo_id,@mspo_dat,@mspo_typ,@emppro_id,@log_act,@log_dat,@usr_id,@log_ip)

	set @mspo_id_out=@mspo_id
	
	set @log_newval= 'ID=' + cast(@mspo_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
go		

--Update
create proc upd_m_mspo(@mspo_id int,@mspo_dat date,@mspo_typ char(1),@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	update m_mspo set mspo_dat=@mspo_dat,mspo_typ=@mspo_typ,emppro_id=@emppro_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where mspo_id=@mspo_id
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		
go
--Delete
create proc del_m_mspo(@mspo_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	--exec del_m_dspo_cus @mspo_id
	--exec del_m_dspo_titm @mspo_id
	update m_mspo set log_act=@log_act where mspo_id=@mspo_id
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		