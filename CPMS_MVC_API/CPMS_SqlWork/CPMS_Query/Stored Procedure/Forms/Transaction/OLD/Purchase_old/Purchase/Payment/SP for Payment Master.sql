USE phm
GO

--alter table t_mpay add  sup_bill varchar(1000)
--alter table t_mpay add mpay_can bit
--alter table t_mpay drop column mvch_id
--alter table t_mpay drop column mvch_id_epl
 --alter table t_mpay add com_id char(2),br_id char(3)
 
--alter table t_mpay add mvch_no int
--alter table t_mpay add mvch_no_epl int
--alter table t_mpay add mpay_chqdat datetime
--alter table t_mpay add acc_no int

--alter table t_mpay drop column ins_usr_id,ins_dat,upd_usr_id,upd_dat
--alter table t_mpay add mpay_cktax bit,mpay_whtax float,mpay_namt float
--update t_mpay set mpay_cktax=0,mpay_whtax=0,mpay_namt=mpay_amt
--alter table t_mpay add mpay_taxid int
--alter table t_mpay add mpay_autoadj bit
--update t_mpay set mpay_autoadj=0

--alter table t_mpay add mpay_gstwhtamt float
--update t_mpay set mpay_gstwhtamt=0
--alter table t_mpay add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter  proc sp_ins_mpay(@com_id char(2),@br_id char(4),@m_yr_id char(2),@mpay_dat datetime,@mpay_autoadj bit,@mpay_cktax bit,@mpay_amt float,@mpay_whtax float,@mpay_gstwhtamt float,@mpay_namt float,@mpay_epl float,@mpay_cb char(1),@mpay_chq int,@mpay_chqdat datetime,@mpay_rmk varchar(250),@mpay_can bit,@mpay_rat float,@sup_id int,@cur_id int,@acc_id char(20),@sup_bill varchar(1000),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mpay_taxid_out int output,@mpay_id_out int output)
as
declare
@mpay_id int,
@sup_nam char(250),
@sup_acc char(20),
@mvch_typ char(2),
@mvch_id int,
@mvch_nar varchar(250),
@amount float,
@eplamount float,
@epl_acc char(20),
@mpay_tamt float,
@row_id int,
@acc_no int,
@mpay_taxid int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	set @sup_nam =(select sup_nam from m_sup where sup_id=@sup_id)
	set @mpay_tamt=(select mpay_tamt from t_mpay where mpay_id=@mpay_id)
	set @acc_no=(select acc_no from gl_m_acc where acc_id=@acc_id)
	set @row_id=0
	--Voucher Type
	if @mpay_cb='C' 
		begin
			set @mvch_typ='02'
		end
	else if @mpay_cb='B'
		begin
			set @mvch_typ='04'
		end	

	set @mpay_id=(select max(mpay_id)+1 from t_mpay)
		if @mpay_id is null
			begin
				set @mpay_id=1
			end
	if (@mpay_cktax=0)
		begin
			set @mpay_whtax =0
			set @mpay_gstwhtamt =0
			set @mpay_namt=@mpay_amt
		end
	if (@mpay_cktax=1)
		begin
			set @mpay_taxid=(select MAX(mpay_taxid)+1 from t_mpay where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mpay_taxid is null)
				begin
					set @mpay_taxid =1
				end

		end
	--Inserting the record
	insert into t_mpay (com_id,br_id,mpay_id,mpay_taxid,mpay_dat,mpay_autoadj,mpay_cktax,mpay_amt,mpay_whtax,mpay_gstwhtamt,mpay_namt,mpay_epl,mpay_cb,mpay_chq,mpay_chqdat,mpay_rat,mpay_rmk,sup_bill,sup_id,cur_id,m_yr_id,acc_id,mpay_can,acC_no,log_act,log_dat,usr_id,log_ip)
	values(@com_id,@br_id,@mpay_id,@mpay_taxid,@mpay_dat,@mpay_autoadj,@mpay_cktax,@mpay_amt,@mpay_whtax,@mpay_gstwhtamt,@mpay_namt,@mpay_epl,@mpay_cb,@mpay_chq,@mpay_chqdat,@mpay_rat,@mpay_rmk,@sup_bill,@sup_id,@cur_id,@m_yr_id,@acc_id,@mpay_can,@acc_no,@log_act,@log_dat,@usr_id,@log_ip)			

		set @mpay_id_out=@mpay_id
		set @mpay_taxid_out=@mpay_taxid
		
		set @log_newval= 'ID=' + cast(@mpay_id as varchar) + '-' + cast(@log_newval as varchar(max))

  --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
	--GL
	exec sp_voucher_pay @com_id,@br_id,@m_yr_id ,@mpay_id ,@usr_id,'' ,'' 

	
end
go

--exec sp_upd_mpay '01','01','01',3,'06/17/2012',8000,752000,-48000,'B',1,'manual',100,1,1,'03002003001001','','',1,''
--select * from t_dvch where mvch_id='002-20120617'

--Update
alter  proc sp_upd_mpay(@com_id char(2),@br_id char(4),@m_yr_id char(2),@mpay_id int,@mpay_dat datetime,@mpay_autoadj bit,@mpay_cktax bit,@mpay_amt float,@mpay_whtax float,@mpay_gstwhtamt float,@mpay_namt float,@mpay_epl float,@mpay_cb char(1),@mpay_chq int,@mpay_chqdat datetime,@mpay_rmk varchar(250),@mpay_can bit,@mpay_rat float,@sup_id int,@cur_id int,@acc_id char(20),@sup_bill varchar(1000),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mpay_taxid_out int output)
as
declare
@mvch_typ char(2),
@acc_no int,
@mpay_taxid int,
@mpay_cktax_old bit,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	set @acc_no=(select acc_no from gl_m_acc where acc_id=@acc_id)
	
	set @mpay_taxid=(select mpay_taxid from t_mpay where mpay_id=@mpay_id)
	set @mpay_cktax_old=(select mpay_cktax from t_mpay where mpay_id=@mpay_id)
	if (@mpay_cktax !=@mpay_cktax_old)
		begin
			 set @mpay_taxid=null 
		end

	
	
	
	if (@mpay_cktax=0)
		begin
			set @mpay_whtax =0
			set @mpay_namt=@mpay_amt
		end
		
		if (@mpay_cktax=1 and @mpay_taxid is null)
		begin
			set @mpay_taxid=(select MAX(mpay_taxid)+1 from t_mpay where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mpay_taxid is null)
				begin
					set @mpay_taxid =1
				end

		end	
	--Updating the record
	update t_mpay set mpay_taxid=@mpay_taxid,mpay_autoadj=@mpay_autoadj,mpay_cktax=@mpay_cktax, mpay_amt=@mpay_amt,mpay_whtax=@mpay_whtax,mpay_gstwhtamt=@mpay_gstwhtamt,mpay_namt =@mpay_namt,mpay_epl=@mpay_epl,mpay_cb=@mpay_cb,mpay_rat=@mpay_rat,mpay_rmk=@mpay_rmk,sup_bill=@sup_bill,cur_id=@cur_id,acc_id=@acc_id,mpay_chq=@mpay_chq,mpay_chqdat=@mpay_chqdat,mpay_can=@mpay_can,acc_no=@acc_no,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
		where mpay_id=@mpay_id

	set @mpay_taxid_out=@mpay_taxid
	--Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

	--GL
	exec sp_voucher_pay @com_id,@br_id,@m_yr_id ,@mpay_id ,@usr_id,'',''
end
go
--exec sp_del_mpay '01','01',6,'01','','',1,''
--Delete
alter  proc sp_del_mpay(@com_id char(2),@br_id char(2),@mpay_id int,@m_yr_id char(2),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
	@mvch_no int,
	@mvch_no_epl int,
	@mvch_typ char(2),
	@mpay_dat datetime,
	@mpay_chq int,
	@mpay_cb char(1),	
	@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	--Delete Payment Voucher
	set @mvch_no =(select mvch_no from t_mpay where mpay_id=@mpay_id )
	set @mvch_no_epl =(select mvch_no_epl from t_mpay where mpay_id=@mpay_id )
	set @mpay_dat=(select mpay_dat from t_mpay where mpay_id=@mpay_id )
	set @mpay_chq=(select mpay_chq from t_mpay where mpay_id=@mpay_id )
	set @mpay_cb=(select mpay_cb from t_mpay where mpay_id=@mpay_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete Tax Payment Voucher
	set @mvch_no =(select mvch_taxno from t_mpay where mpay_id=@mpay_id )
	set @mvch_no_epl =(select mvch_taxno_epl from t_mpay where mpay_id=@mpay_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''

	--Delete EPL Voucher	
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no_epl ,'','','',''
	--Delete the detail of payment
	exec sp_del_dpay @mpay_id
	
	update t_mpay set log_act=@log_act where mpay_id=@mpay_id
	--Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end


