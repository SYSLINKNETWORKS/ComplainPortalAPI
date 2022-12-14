USE MEIJI_RUSK
GO
--alter table m_wh column itm_id int
--alter table m_wh drop constraint FK_MWH_ITMID foreign key (itm_id) references m_itm(itm_id)
--alter table m_wh add br_id char(3)
--alter table m_wh add constraint FK_MWH_BRID foreign key (br_id) references m_br(br_id)
--update m_wh set br_id='01'

--alter table m_wh add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--select * from m_wh

--ALTER table m_wh add wh_ckdef bit
--update m_wh set wh_ckdef=0

alter proc [dbo].[ins_m_wh](@wh_nam varchar(100),@wh_ckdef bit,@br_id char(3),@wh_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@wh_id_out int output)
as
declare 
@wh_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @wh_id=(select max(wh_id) +1 from m_wh)
	if (@wh_id is null)
		begin
			set @wh_id=1
		end
	insert into m_wh(wh_id,wh_nam,wh_ckdef,br_id,wh_typ,log_act,log_dat,usr_id,log_ip)
	  values(@wh_id,@wh_nam,@wh_ckdef,@br_id,@wh_typ,@log_act,@log_dat,@usr_id,@log_ip)

	 set @wh_id_out=@wh_id
	 
		set @log_newval= 'ID=' + cast(@wh_id as varchar) + '-' + cast(@log_newval as varchar(max))
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO
----Update whanch
alter proc [dbo].[upd_m_wh](@wh_id char(3),@wh_nam varchar(100),@wh_ckdef bit,@br_id char(3),@wh_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_wh set wh_nam=@wh_nam,wh_ckdef=@wh_ckdef,br_id=@br_id,wh_typ=@wh_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where wh_id=@wh_id
	
	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO


----Delete the whanch
alter proc [dbo].[del_m_wh] (@wh_id char(3),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	update m_wh set log_act=@log_act where wh_id=@wh_id
	
	--Audit
	exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO

