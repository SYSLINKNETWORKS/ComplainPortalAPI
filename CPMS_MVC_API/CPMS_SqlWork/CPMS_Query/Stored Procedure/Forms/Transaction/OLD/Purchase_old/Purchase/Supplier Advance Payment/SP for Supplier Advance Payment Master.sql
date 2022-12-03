USE phm
GO
--alter table t_supadv add supadv_chqdat datetime,supadv_can bit
--alter table t_supadv add mvch_no int
--alter table t_supadv drop column mvch_id
--alter table t_supadv add supadv_cktax bit,supadv_roff bit,supadv_whtper float,supadv_whtamt float
--alter table t_supadv add supadv_taxid int
--alter table t_supadv drop column ins_usr_id ,ins_dat ,upd_usr_id ,upd_dat 
--SELECT * FROM t_supadv 
--alter table t_supadv add supadv_autoadj bit
--update t_supadv set supadv_autoadj=0

--alter table t_supadv add supadv_gstwhtamt float
--update t_supadv set supadv_gstwhtamt=0

--alter table t_supadv add supadv_gstwhtper float,supadv_gstwhtamt1 float
--update t_supadv set supadv_gstwhtper =0,supadv_gstwhtamt1=0
--alter table t_supadv add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(10)

--Insert
alter  proc sp_ins_supadv(@com_id char(2),@br_id char(4),@m_yr_id char(2),@supadv_dat datetime,@supadv_autoadj bit,@supadv_amt float,@supadv_cktax bit,@supadv_roff bit,@supadv_whtper float,@supadv_whtamt float,@supadv_gstwhtamt float,@supadv_gstwhtper float,@supadv_gstwhtamt1 float,@supadv_tamt float,@supadv_cb char(1),@supadv_chq int,@supadv_chqdat datetime,@supadv_rmk varchar(250),@supadv_rat float,@sup_id int,@supadv_ckpo bit,@supadv_can bit,@mpo_id int,@cur_id int,@acc_id char(20),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@supadv_taxid_out int output,@supadv_id_out int output)
as
declare
@supadv_id int,
@supadv_taxid int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	

	if (@supadv_ckpo =0)
		begin
			set @mpo_id=null
		end

	set @supadv_id=(select max(supadv_id)+1 from t_supadv)
		if @supadv_id is null
			begin
				set @supadv_id=1
			end
	if (@supadv_cktax=0)
		begin
			set @supadv_whtper=0
			set @supadv_whtamt=0
			set @supadv_gstwhtamt=0
			set @supadv_gstwhtper=0
			set @supadv_gstwhtamt1=0
		end
	if (@supadv_cktax=1)
		begin
			set @supadv_taxid=(select MAX(supadv_taxid)+1 from t_supadv where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@supadv_taxid is null)
				begin
					set @supadv_taxid =1
				end

		end
			
	--Inserting the record
	insert into t_supadv (com_id,br_id,supadv_id,supadv_taxid,supadv_dat,supadv_autoadj,supadv_rat,supadv_amt,supadv_cktax,supadv_roff,supadv_whtper,supadv_whtamt,supadv_gstwhtamt,supadv_gstwhtper,supadv_gstwhtamt1,supadv_tamt,supadv_cb,supadv_chq,supadv_chqdat,supadv_rmk,sup_id,supadv_ckpo,supadv_can,mpo_id,cur_id,m_yr_id,acc_id,log_act,log_dat,usr_id,log_ip)
	values(@com_id,@br_id,@supadv_id,@supadv_taxid,@supadv_dat,@supadv_autoadj,@supadv_rat,@supadv_amt,@supadv_cktax,@supadv_roff,@supadv_whtper,@supadv_whtamt,@supadv_gstwhtamt,@supadv_gstwhtper,@supadv_gstwhtamt1,@supadv_tamt,@supadv_cb,@supadv_chq,@supadv_chqdat,@supadv_rmk,@sup_id,@supadv_ckpo,@supadv_can,@mpo_id,@cur_id,@m_yr_id,@acc_id,@log_act,@log_dat,@usr_id,@log_ip)			

		set @supadv_id_out=@supadv_id
		set @supadv_taxid_out=@supadv_taxid
	
set @log_newval= 'ID=' + cast(@supadv_id as varchar) + '-' + cast(@log_newval as varchar(max))

  --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
--GL
	exec sp_voucher_supadv @supadv_id 


end
go

--exec sp_upd_supadv '01','01','01',3,'06/17/2012',8000,752000,-48000,'B',1,'manual',100,1,1,'03002003001001','','',1,''
--select * from t_dvch where mvch_id='002-20120617'

--Update
alter  proc sp_upd_supadv(@com_id char(2),@br_id char(4),@m_yr_id char(2),@supadv_id int,@supadv_dat datetime,@supadv_autoadj bit,@supadv_rat float,@supadv_amt float,@supadv_cktax float,@supadv_roff bit,@supadv_whtper float,@supadv_whtamt float,@supadv_gstwhtamt float,@supadv_gstwhtper float,@supadv_gstwhtamt1 float,@supadv_tamt float,@supadv_cb char(1),@supadv_chq int,@supadv_chqdat datetime,@supadv_rmk varchar(250),@sup_id int,@supadv_ckpo bit,@supadv_can bit,@mpo_id int,@cur_id int,@acc_id char(20),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@supadv_taxid_out int output)
as
declare
@supadv_taxid int,
@supadv_cktax_old bit,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	
	set @supadv_taxid=(select supadv_taxid from t_supadv where supadv_id=@supadv_id)
	set @supadv_cktax_old=(select supadv_cktax from t_supadv where supadv_id=@supadv_id)
	
	if (@supadv_cktax !=@supadv_cktax_old)
		begin
			 set @supadv_taxid=null 
		end
		
	

	if (@supadv_ckpo =0)
		begin
			set @mpo_id=null
		end
		if (@supadv_cktax=0)
		begin
			set @supadv_whtper=0
			set @supadv_whtamt=0
			set @supadv_gstwhtamt=0
			set @supadv_gstwhtper=0
			set @supadv_gstwhtamt1=0
		end
	if (@supadv_cktax=1 and @supadv_taxid is null)
		begin
			set @supadv_taxid=(select MAX(supadv_taxid)+1 from t_supadv where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@supadv_taxid is null)
				begin
					set @supadv_taxid =1
				end

		end			
	--Inserting the record
	update t_supadv set supadv_taxid=@supadv_taxid,supadv_autoadj=@supadv_autoadj,supadv_rat=@supadv_rat,supadv_amt=@supadv_amt,supadv_cktax=@supadv_cktax,supadv_roff=@supadv_roff,supadv_whtper=@supadv_whtper,supadv_whtamt=@supadv_whtamt,supadv_gstwhtamt=@supadv_gstwhtamt,supadv_gstwhtper=@supadv_gstwhtper,supadv_gstwhtamt1=@supadv_gstwhtamt1,supadv_tamt=@supadv_tamt,supadv_cb=@supadv_cb,supadv_rmk=@supadv_rmk,cur_id=@cur_id,acc_id=@acc_id,supadv_chq=@supadv_chq,supadv_chqdat=@supadv_chqdat,supadv_can=@supadv_can,supadv_ckpo=@supadv_ckpo,mpo_id=@mpo_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
		where supadv_id=@supadv_id and com_id=@com_id and br_id=@br_id and m_yr_id=@m_yr_id
	
	set	@supadv_taxid_out=@supadv_taxid

	--Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

--GL
		exec sp_voucher_supadv @supadv_id 

end
go
--Delete
alter  proc sp_del_supadv(@com_id char(2),@br_id char(2),@supadv_id int,@m_yr_id char(2),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
	@mvch_no int,
	@mvch_typ char(2),
	@supadv_dat datetime,
	@supadv_chq int,
	@supadv_cb char(1),	
	@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	
	--Delete Voucher
	set @mvch_no =(select mvch_no from t_supadv where supadv_id=@supadv_id )
	set @mvch_typ=(select mvch_typ from t_supadv  where supadv_id=@supadv_id  )
	set @supadv_dat=(select supadv_dat from t_supadv where supadv_id=@supadv_id  )
	set @supadv_chq=(select supadv_chq from t_supadv where supadv_id=@supadv_id  )
	set @supadv_cb=(select supadv_cb from t_supadv where supadv_id=@supadv_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete Tax Voucher
	set @mvch_no =(select mvch_taxno from t_supadv where supadv_id=@supadv_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''


	delete from t_dsupadv where supadv_id=@supadv_id 	 
	update t_supadv set log_act=@log_act where supadv_id=@supadv_id 
	--Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end

