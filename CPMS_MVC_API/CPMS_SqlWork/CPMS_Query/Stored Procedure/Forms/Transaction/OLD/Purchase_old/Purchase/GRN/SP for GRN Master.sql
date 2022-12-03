USE phm
go
--alter table t_mgrn add mgrn_kepz varchar(100)
--update t_mgrn set mgrn_kepz=''
--alter table t_mgrn drop column ins_usr_id,ins_dat,upd_usr_id,upd_dat


--select * from t_mgrn
--alter table t_mgrn add com_id char(2),br_id char(3)
--alter table t_mgrn add constraint FK_MGRN_COMID foreign key (com_id) references m_com(com_id)
--alter table t_mgrn add constraint FK_MGRN_BRID foreign key (br_id) references m_br(br_id)

--alter table t_mgrn add sup_dcdat datetime
--update t_mgrn set sup_dcdat=mgrn_dat
---alter table t_mgrn add mgrn_idold varchar(1000)

--exec ins_t_mgrn '01','01','10/07/2011','U',2,'03',7,'',144,''
--alter table t_mgrn add lot_id int
--alter table t_mgrn drop column sup_id
--alter table t_mgrn add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)


--Insert
alter proc ins_t_mgrn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mgrn_dat datetime,@mgrn_typ char(1),@mgrn_nw float,@sca_id int,@mgrn_act bit,@sup_dc varchar(100),@sup_dcdat datetime,@mgrn_kepz varchar(100),@mgrn_rmk varchar(250),@mgrn_rat float,@mgrn_amt float,@mpo_id int,@wh_id int,@mgrn_idold varchar(1000),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mgrn_id_out int output)
as
declare
@mgrn_id int,
@cur_id int,
@lot_id int,
@lot_nam varchar(1000),
@sup_snm varchar(10),
@sup_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	set @cur_id=(select cur_id from t_mpo where mpo_id=@mpo_id)
	set @sup_id=(select t_mpo.sup_id from t_mpo where mpo_id=@mpo_id)
	set @sup_snm=(select rtrim(sup_snm) from m_sup where sup_id=@sup_id)
	
	set @mgrn_id=(select max(mgrn_id)+1 from t_mgrn)
		if @mgrn_id is null
			begin
				set @mgrn_id=1
			end

	--Lot Insert
	set @lot_nam =rtrim(cast(@mgrn_id as varchar(100)))+'-'+rtrim(isnull(@sup_snm,''))
	exec ins_m_lot @lot_nam ,@mgrn_act,@mgrn_typ,@lot_id_out =@lot_id output

	insert into t_mgrn(com_id,br_id,mgrn_id,mgrn_dat,mgrn_typ,mpo_id,m_yr_id,sup_dc,sup_dcdat,mgrn_kepz,mgrn_rmk,mgrn_rat,mgrn_amt,cur_id,mgrn_act,mgrn_nw,sca_id,wh_id,mgrn_idold,lot_id,log_act,log_dat,usr_id,log_ip)
			values(@com_id,@br_id,@mgrn_id,@mgrn_dat,@mgrn_typ,@mpo_id,@m_yr_id,@sup_dc,@sup_dcdat,@mgrn_kepz,@mgrn_rmk,@mgrn_rat,@mgrn_amt,@cur_id,@mgrn_act,@mgrn_nw,@sca_id,@wh_id,@mgrn_idold,@lot_id,@log_act,@log_dat,@usr_id,@log_ip)
	set @mgrn_id_out=@mgrn_id
	
	set @log_newval= 'ID=' + cast(@mgrn_id as varchar) + '-' + cast(@log_newval as varchar(max))

  --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end

		

go



--Update
alter proc upd_t_mgrn(@m_yr_id char(2),@mgrn_act bit,@mgrn_id int,@mgrn_dat datetime,@sup_dc varchar(100),@sup_dcdat datetime,@mgrn_kepz varchar(100),@mgrn_rmk varchar(250),@mgrn_rat float,@mgrn_amt float,@wh_id int,@mgrn_nw float,@sca_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@mvch_id char(12),
@cur_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	set @cur_id=(select cur_id from t_mpo where mpo_id=(select mpo_id from t_mgrn where mgrn_id=@mgrn_id))
	
	update t_mgrn set mgrn_dat=@mgrn_dat,sup_dc=@sup_dc,sup_dcdat=@sup_dcdat,mgrn_kepz=@mgrn_kepz,mgrn_rmk=@mgrn_rmk,mgrn_rat=@mgrn_rat,mgrn_amt=@mgrn_amt,cur_id=@cur_id,mgrn_act=@mgrn_act,wh_id=@wh_id,mgrn_nw=@mgrn_nw,sca_id=@sca_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where mgrn_id=@mgrn_id
  --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end
		
go

--Delete
alter proc del_t_mgrn(@mgrn_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	EXEC del_t_dgrn @mgrn_id	
	update t_mgrn set log_act=@log_act where mgrn_id=@mgrn_id 
	--Audit
   exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end

		
--select * from rm_det
