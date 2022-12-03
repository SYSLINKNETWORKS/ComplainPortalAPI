USE phm
go
--alter table t_mqc add mqc_kepz varchar(100)
--update t_mqc set mqc_kepz=''
--alter table t_mqc drop column ins_usr_id,ins_dat,upd_usr_id,upd_dat


--select * from t_mqc
--alter table t_mqc add com_id char(2),br_id char(3)
--alter table t_mqc add constraint FK_Mqc_COMID foreign key (com_id) references m_com(com_id)
--alter table t_mqc add constraint FK_Mqc_BRID foreign key (br_id) references m_br(br_id)
--alter table t_mqc drop column mpo_id int
--alter table t_mqc add sup_dcdat datetime
--update t_mqc set sup_dcdat=mqc_dat
---alter table t_mqc add mqc_idold varchar(1000)

--exec ins_t_mqc '01','01','10/07/2011','U',2,'03',7,'',144,''
--alter table t_mqc add lot_id int
--alter table t_mqc drop column sup_id
--alter table t_mqc add mgrn_id int
--alter table t_mqc add constraint FK_Mqc_MGRNID foreign key (mgrn_id) references t_mgrn(mgrn_id)
--alter table t_mqc add emppro_macid int
--alter table t_mqc add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)


--Insert
alter proc ins_t_mqc(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mqc_dat datetime,@mqc_typ char(1),@mqc_nw float,@sca_id int,@mqc_act bit,@sup_dc varchar(100),@sup_dcdat datetime,@mqc_kepz varchar(100),@mqc_rmk varchar(250),@mqc_rat float,@mqc_amt float,@mgrn_id int,@wh_id int,@mqc_idold varchar(1000),@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mqc_id_out int output)
as
declare
@mqc_id int,
@cur_id int,
@lot_id int,
@lot_nam varchar(1000),
@sup_snm varchar(10),
@sup_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	

	set @cur_id=(select cur_id from t_mgrn where mgrn_id=@mgrn_id)
	set @sup_id=(select t_mpo.sup_id from t_mgrn inner join t_mpo on t_mgrn.mpo_id=t_mpo.mpo_id where mgrn_id=@mgrn_id)
	set @sup_snm=(select rtrim(sup_snm) from m_sup where sup_id=@sup_id)
	
	set @mqc_id=(select max(mqc_id)+1 from t_mqc)
		if @mqc_id is null
			begin
				set @mqc_id=1
			end

	--Lot Insert
	set @lot_nam =rtrim(cast(@mqc_id as varchar(100)))+'-'+rtrim(isnull(@sup_snm,''))
	exec ins_m_lot @lot_nam ,@mqc_act,@mqc_typ,@lot_id_out =@lot_id output

	insert into t_mqc(com_id,br_id,mqc_id,mqc_dat,mqc_typ,mgrn_id,m_yr_id,sup_dc,sup_dcdat,mqc_kepz,mqc_rmk,mqc_rat,mqc_amt,cur_id,mqc_act,mqc_nw,sca_id,wh_id,mqc_idold,lot_id,emppro_macid,log_act,log_dat,usr_id,log_ip)
			values(@com_id,@br_id,@mqc_id,@mqc_dat,@mqc_typ,@mgrn_id,@m_yr_id,@sup_dc,@sup_dcdat,@mqc_kepz,@mqc_rmk,@mqc_rat,@mqc_amt,@cur_id,@mqc_act,@mqc_nw,@sca_id,@wh_id,@mqc_idold,@lot_id,@emppro_macid,@log_act,@log_dat,@usr_id,@log_ip)
	set @mqc_id_out=@mqc_id
	
	
	set @log_newval= 'ID=' + cast(@mqc_id as varchar) + '-' + cast(@log_newval as varchar(max))

  --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end

		

go



--Update
alter proc upd_t_mqc(@m_yr_id char(2),@mqc_act bit,@mqc_id int,@mqc_dat datetime,@sup_dc varchar(100),@sup_dcdat datetime,@mqc_kepz varchar(100),@mqc_rmk varchar(250),@mqc_rat float,@mqc_amt float,@wh_id int,@mqc_nw float,@sca_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@emppro_macid int)
as
declare
@mvch_id char(12),
@cur_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	set @cur_id=(select cur_id from t_mgrn where mgrn_id=(select mgrn_id from t_mqc where mqc_id=@mqc_id))
	
	update t_mqc set mqc_dat=@mqc_dat,sup_dc=@sup_dc,sup_dcdat=@sup_dcdat,mqc_kepz=@mqc_kepz,mqc_rmk=@mqc_rmk,mqc_rat=@mqc_rat,mqc_amt=@mqc_amt,cur_id=@cur_id,mqc_act=@mqc_act,wh_id=@wh_id,mqc_nw=@mqc_nw,sca_id=@sca_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip,emppro_macid=@emppro_macid where mqc_id=@mqc_id

	 --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
		
go

--Delete
alter proc del_t_mqc(@mqc_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	EXEC del_t_dqc @mqc_id
	
	update t_mqc set log_act=@log_act where mqc_id=@mqc_id  
 --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end

		
--select * from rm_det
