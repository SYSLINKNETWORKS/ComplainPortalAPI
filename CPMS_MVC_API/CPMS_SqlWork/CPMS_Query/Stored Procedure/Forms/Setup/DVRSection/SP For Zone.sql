USE phm
go

--alter table m_zone add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter proc [dbo].[ins_m_zone](@zone_nam varchar(250),@zone_typ char(1),@coun_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@zone_id_out int output)
as
declare
@zone_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @zone_id=(select max(zone_id)+1 from m_zone)
		if @zone_id is null
			begin
				set @zone_id=1
			end
	insert into m_zone(zone_id,zone_nam,zone_typ,coun_id,log_act,log_dat,usr_id,log_ip)
			values(@zone_id,@zone_nam,@zone_typ,@coun_id,@log_act,@log_dat,@usr_id,@log_ip)
		set @zone_id_out=@zone_id
		
		set @log_newval= 'ID=' + cast(@zone_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--Update
alter proc [dbo].[upd_m_zone](@zone_id int,@zone_nam varchar(250),@zone_typ char(1),@coun_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_zone set zone_nam=@zone_nam,zone_typ=@zone_typ,coun_id=@coun_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where zone_id=@zone_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


--Delete
alter proc [dbo].[del_m_zone](@zone_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()

	update m_zone set log_act=@log_act where zone_id=@zone_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

