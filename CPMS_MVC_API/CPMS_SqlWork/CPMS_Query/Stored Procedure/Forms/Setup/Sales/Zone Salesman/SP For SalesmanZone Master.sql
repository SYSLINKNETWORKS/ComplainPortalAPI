USE phm
GO
--alter table m_msalzon add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter proc ins_m_msalzon(@msalzon_dat datetime,@msalzon_typ char(1),@msalzon_act bit,@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@msalzon_id_out int output)
as
declare
@msalzon_id int,
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @msalzon_id=(select max(msalzon_id)+1 from m_msalzon)
		if @msalzon_id is null
			begin
				set @msalzon_id=1
			end
	insert into m_msalzon(msalzon_id,msalzon_dat,msalzon_typ,msalzon_act,emppro_id,log_act,log_dat,usr_id,log_ip)
					values (@msalzon_id,@msalzon_dat,@msalzon_typ,@msalzon_act,@emppro_id,@log_act,@log_dat,@usr_id,@log_ip)

	set @msalzon_id_out=@msalzon_id
	
	set @log_newval= 'ID=' + cast(@msalzon_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
go		

--Update
alter proc upd_m_msalzon(@msalzon_id int,@msalzon_dat date,@msalzon_typ char(1),@msalzon_act bit,@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@emppro_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	update m_msalzon set msalzon_dat=@msalzon_dat,msalzon_typ=@msalzon_typ,msalzon_act=@msalzon_act,emppro_id=@emppro_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where msalzon_id=@msalzon_id
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		
go
--Delete
alter proc del_m_msalzon(@msalzon_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	exec del_m_dsalzon @msalzon_id
	update m_msalzon set log_act=@log_act where msalzon_id=@msalzon_id
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		