USE phm
GO

--alter table m_sca add sca_ckcon bit,sca_met float
--update m_sca set sca_ckcon=0,sca_met=0
--alter table m_sca add sca_snm varchar(10)
--alter table m_sca add constraint UNQ_MSCA_SCANAM unique (sca_nam)
--alter table m_sca add constraint UNQ_MSCA_SCASNM unique (sca_snm)
--alter table m_sca add sca_ckdos bit,sca_ckpack bit,sca_packqty float
--alter table m_sca add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--UPDATE m_sca set sca_ckdos=0,sca_ckpack=0,sca_packqty=0


--Insert
alter proc ins_m_sca(@sca_nam varchar(250),@sca_ckcon bit,@sca_met float,@sca_typ char(1),@sca_snm varchar(10),@sca_ckdos bit,@sca_ckpack bit,@sca_packqty float,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@sca_id_out int output)
as
declare
@sca_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @sca_id=(select max(sca_id)+1 from m_sca)
		if @sca_id is null
			begin
				set @sca_id=1
			end
		if (@sca_ckcon=0)
			begin
				set @sca_met=0
			end
	insert into m_sca(sca_id,sca_nam,sca_snm,sca_ckcon,sca_met,sca_typ,sca_ckdos,sca_ckpack,sca_packqty,log_act,log_dat,usr_id,log_ip)
					values (@sca_id,@sca_nam,@sca_snm,@sca_ckcon,@sca_met,@sca_typ,@sca_ckdos,@sca_ckpack,@sca_packqty,@log_act,@log_dat,@usr_id,@log_ip)

	set @sca_id_out=@sca_id
	
	set @log_newval= 'ID=' + cast(@sca_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
go		

--Update
alter proc upd_m_sca(@sca_id int,@sca_nam varchar(250),@sca_snm varchar(10),@sca_ckcon bit,@sca_met float,@sca_typ char(1),@sca_ckdos bit,@sca_ckpack bit,@sca_packqty float,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	if (@sca_ckcon=0)
		begin
			set @sca_met=0
		end
	update m_sca set sca_nam=@sca_nam,sca_snm=@sca_snm,sca_ckcon=@sca_ckcon,sca_met=@sca_met,sca_typ=@sca_typ,sca_ckdos=@sca_ckdos ,sca_ckpack=@sca_ckpack ,sca_packqty=@sca_packqty,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip   where sca_id=@sca_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		
go
--Delete
alter proc del_m_sca(@sca_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	
	update m_sca set log_act=@log_act where sca_id=@sca_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		