USE phm
GO

--alter table m_supeva add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--alter table m_supeva add supeva_nverdat datetime
--alter table m_supeva drop column supeva_nam,supeva_cp,supeva_pho,supeva_mob,supeva_fax,supeva_eml,supeva_add
--alter table m_supeva add sup_id int


alter proc ins_m_supeva(@supeva_act bit,@supeva_app bit,@supeva_stdat datetime,@sup_id int,@terr_id int,@supeva_lic varchar(100),@supeva_exp datetime,@supeva_iso bit,@supeva_qm bit,@supeva_inspec char(2),@supeva_ckass bit,@supeva_skill char(1),@supeva_ncp varchar(250),@supeva_cus1 varchar(250),@supeva_cus2 varchar(250),@supeva_perinfo varchar(250),@supeva_pos varchar(250),@supeva_qrs varchar(250),@supeva_otdel varchar(250),@supeva_asalsrv varchar(250),@supeva_suprply bit,@supeva_mrktrep bit,@supeva_supprowrk bit,@supeva_supqua bit,@supeva_starea bit,@supeva_manqua bit,@supeva_supstnd bit,@supeva_vistper varchar(250),@supeva_vistdat datetime,@supeva_rmk varchar(1000),@supeva_appby varchar(250),@supeva_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@supeva_nverdat datetime,@supeva_id_out int output)
as
declare
@supeva_id int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	
	set @supeva_id=(select max(supeva_id)+1 from m_supeva)
		if @supeva_id is null
			begin
				set @supeva_id=1
			end
	if (@supeva_app =0)
		begin
			set @supeva_act=0
		end



	insert into m_supeva
			(supeva_id,supeva_act,supeva_app,supeva_stdat,sup_id,terr_id,supeva_lic,supeva_exp,supeva_iso,supeva_qm,supeva_inspec,supeva_ckass,supeva_skill,supeva_ncp,supeva_cus1,supeva_cus2,supeva_perinfo,supeva_pos,supeva_qrs,supeva_otdel,supeva_asalsrv,supeva_suprply,supeva_mrktrep,supeva_supprowrk,supeva_supqua,supeva_starea,supeva_manqua,supeva_supstnd,supeva_vistper,supeva_vistdat,supeva_rmk,supeva_appby,supeva_typ,log_dat,log_act,usr_id,log_ip,supeva_nverdat)
		 values(@supeva_id,@supeva_act,@supeva_app,@supeva_stdat,@sup_id,@terr_id,@supeva_lic,@supeva_exp,@supeva_iso,@supeva_qm,@supeva_inspec,@supeva_ckass,@supeva_skill,@supeva_ncp,@supeva_cus1,@supeva_cus2,@supeva_perinfo,@supeva_pos,@supeva_qrs,@supeva_otdel,@supeva_asalsrv,@supeva_suprply,@supeva_mrktrep,@supeva_supprowrk,@supeva_supqua,@supeva_starea,@supeva_manqua,@supeva_supstnd,@supeva_vistper,@supeva_vistdat,@supeva_rmk,@supeva_appby,@supeva_typ,@log_dat,@log_act,@usr_id,@log_ip,@supeva_nverdat)

		set @supeva_id_out=@supeva_id
	set @log_newval= 'ID=' + cast(@supeva_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat


end	
go

--Update
alter proc upd_m_supeva(@supeva_id int,@supeva_act bit,@supeva_app bit,@supeva_stdat datetime,@sup_id int,@terr_id int,@supeva_lic varchar(100),@supeva_exp datetime,@supeva_iso bit,@supeva_qm bit,@supeva_inspec char(2),@supeva_ckass bit,@supeva_skill char(1),@supeva_ncp varchar(250),@supeva_cus1 varchar(250),@supeva_cus2 varchar(250),@supeva_perinfo varchar(250),@supeva_pos varchar(250),@supeva_qrs varchar(250),@supeva_otdel varchar(250),@supeva_asalsrv varchar(250),@supeva_suprply bit,@supeva_mrktrep bit,@supeva_supprowrk bit,@supeva_supqua bit,@supeva_starea bit,@supeva_manqua bit,@supeva_supstnd bit,@supeva_vistper varchar(250),@supeva_vistdat datetime,@supeva_rmk varchar(1000),@supeva_appby varchar(250),@supeva_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@supeva_nverdat datetime)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	
	if (@supeva_app =0)
		begin
			set @supeva_act=0
		end
	update m_supeva set supeva_act=@supeva_act,supeva_app=@supeva_app,supeva_stdat=@supeva_stdat,sup_id=@sup_id,terr_id=@terr_id,supeva_lic=@supeva_lic,supeva_exp=@supeva_exp,supeva_iso=@supeva_iso,supeva_qm=@supeva_qm,supeva_inspec=@supeva_inspec,supeva_ckass=@supeva_ckass,supeva_skill=@supeva_skill,supeva_ncp=@supeva_ncp,supeva_cus1=@supeva_cus1,supeva_cus2=@supeva_cus2,supeva_perinfo=@supeva_perinfo,supeva_pos=@supeva_pos,supeva_qrs=@supeva_qrs,supeva_otdel=@supeva_otdel,supeva_asalsrv=@supeva_asalsrv,supeva_suprply=@supeva_suprply,supeva_mrktrep=@supeva_mrktrep,supeva_supprowrk=@supeva_supprowrk,supeva_supqua=@supeva_supqua,supeva_starea=@supeva_starea,supeva_manqua=@supeva_manqua,supeva_supstnd=@supeva_supstnd,supeva_vistper=@supeva_vistper,supeva_vistdat=@supeva_vistdat,supeva_rmk=@supeva_rmk,supeva_appby=@supeva_appby,supeva_typ=@supeva_typ,log_dat=@log_dat,log_act=@log_act,usr_id=@usr_id,log_ip=@log_ip,supeva_nverdat=@supeva_nverdat
	 where supeva_id=@supeva_id

	--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end	
go
--Delete
alter proc del_m_supeva(@supeva_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
		set @log_dat=GETDATE()	
		update m_supeva set log_act=@log_act where supeva_id=@supeva_id
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end

GO
