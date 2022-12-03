USE phm
GO
--alter table t_mpr add ins_usr_id char(2),ins_dat datetime,upd_usr_id char(2),upd_dat datetime
--alter table t_mpr drop column com_id,br_id
--alter table t_mpr drop constraint FK_mpr_COMID foreign key (com_id) references m_com(com_id)
--alter table t_mpr drop constraint FK_mpr_BRID foreign key (br_id) references m_br(br_id)
--update t_mpr set com_id='01',br_id='01'
--alter table t_mpr add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--alter table t_mpr add emppro_macid int
--alter table t_mpr add mpr_ddat datetime
--update t_mpr set mpr_ddat=GETDATE()
--alter table t_mpr add mpr_auth bit
--update t_mpr set mpr_auth=0
--alter table t_mpr add mpr_rmk varchar(250)
--alter table t_mpr add prcat_id int
--update t_mpr set prcat_id=1
--alter table t_mpr add constraint FK_MPR_PRCATID foreign key (prcat_id) references m_prcat(prcat_id)

--Insert
alter proc ins_t_mpr(@mpr_dat datetime,@mpr_typ char(1),@mpr_act bit,@dpt_id char(2),@mso_id int,@m_yr_id char(2),@mpr_ddat datetime,@mpr_rmk varchar(250),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@emppro_macid int,@mpr_auth bit,@prcat_id int,@mpr_id_out int output)
as
declare
@mpr_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	set @mpr_id=(select max(mpr_id)+1 from t_mpr )
		if @mpr_id is null
			begin
				set @mpr_id=1
			end
	insert into t_mpr(mpr_id,mpr_dat,dpt_id,mpr_act,mpr_typ,mso_id,m_yr_id,log_act,log_dat,usr_id,log_ip,emppro_macid,mpr_ddat,mpr_auth,mpr_rmk,prcat_id)
			values(@mpr_id,@mpr_dat,@dpt_id,@mpr_act,@mpr_typ,@mso_id,@m_yr_id,@log_act,@log_dat,@usr_id,@log_ip,@emppro_macid,@mpr_ddat,@mpr_auth,@mpr_rmk,@prcat_id)
	set @mpr_id_out=@mpr_id
	
	set @log_newval= 'ID=' + cast(@mpr_id as varchar) + '-' + cast(@log_newval as varchar(max))
	--Audit
	exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		
go
--Update
alter proc upd_t_mpr(@mpr_id int,@dpt_id char(2),@mpr_dat datetime,@mpr_act bit,@mso_id int,@mpr_typ char(1),@m_yr_id char(2),@mpr_ddat datetime,@mpr_rmk varchar(250),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@emppro_macid int,@mpr_auth bit,@prcat_id int)
as
declare
@log_dat datetime
begin
    set @log_dat=GETDATE()	
	update t_mpr set mpr_dat=@mpr_dat,dpt_id=@dpt_id,mpr_act=@mpr_act,mso_id=@mso_id,mpr_typ=@mpr_typ,m_yr_id=@m_yr_id,mpr_ddat=@mpr_ddat,mpr_rmk=@mpr_rmk,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip,emppro_macid=@emppro_macid,mpr_auth=@mpr_auth,prcat_id=@prcat_id 
	where mpr_id=@mpr_id 
	--Audit
	exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end

go
--Delete

alter  proc del_t_mpr(@mpr_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
set @log_dat=GETDATE()
	
	delete t_dpr where mpr_id=@mpr_id 
	update t_mpr set log_act=@log_act where mpr_id=@mpr_id 
	
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		
--select * from rm_det
