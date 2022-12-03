USE phm
GO
--create table t_cusadv add cusadv_chqdat datetime,cusadv_can bit
--create table t_cusadv add mvch_no int
--create table t_cusadv drop column mvch_id
--SELECT * FROM t_cusadv 
--alter table t_cusadv add cusadv_cktax bit,cusadv_roff bit,cusadv_whtper float,cusadv_whtamt float,cusadv_tamt float
--update t_cusadv set cusadv_cktax=0,cusadv_roff=0,cusadv_whtper=0,cusadv_whtamt =0,cusadv_tamt=cusadv_amt
--alter table t_cusadv add cusadv_taxid int
--alter table t_cusadv add constraint UNQ_CUSADV_COMID_YRID_CUSADVTAXID UNIQUE (com_id,m_yr_id,cusadv_taxid)
--select * from t_cusadv
--update t_cusadv set cusadv_taxid=null
--alter table t_cusadv add cusadv_autoadj bit
--update t_cusadv set cusadv_autoadj=0

--ALTER table t_cusadv add cusadv_gstwhtamt float
--update t_cusadv set cusadv_gstwhtamt=0

--alter table t_cusadv add cusbk_id int
--alter table t_cusadv add constraint FK_CUSADV_CUSBKID foreign key (cusbk_id) references m_cusbk (cusbk_id)

--alter table t_cusadv add cusadv_ckgstwht bit,cusadv_gstwhtper float,cusadv_gstwhtamt1 float
--update t_cusadv set cusadv_ckgstwht=0,cusadv_gstwhtper=0,cusadv_gstwhtamt1=0
--alter table t_cusadv drop column ins_usr_id,ins_dat,upd_usr_id,upd_dat
--alter table t_cusadv add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter  proc sp_ins_cusadv(@com_id char(2),@br_id char(4),@m_yr_id char(2),@cusadv_dat datetime,@cusadv_autoadj bit,@cusadv_amt float,@cusadv_ckgstwht bit,@cusadv_gstwhtamt float,@cusadv_gstwhtper float,@cusadv_gstwhtamt1 float,@cusadv_cktax bit,@cusadv_roff bit,@cusadv_whtper float,@cusadv_whtamt float,@cusadv_tamt float,@cusadv_cb char(1),@cusbk_id int,@cusadv_chq int,@cusadv_chqdat datetime,@cusadv_rmk varchar(250),@cusadv_rat float,@cus_id int,@cusadv_ckso bit,@cusadv_can bit,@mso_id int,@cur_id int,@acc_id char(20),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@cusadv_taxid_out int output,@cusadv_id_out int output)
as
declare
@cusadv_id int,
@cusadv_no int,
@acc_no int,
@cusadv_taxid int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @acc_no=(select acc_no from gl_m_acc where acc_id=@acC_id)
	
	set @cusadv_id=(select MAX(cusadv_id)+1 from t_cusadv)
		if (@cusadv_id is null)
			begin
				set @cusadv_id =1
			end
	set @cusadv_no=(select MAX(cusadv_no)+1 from t_cusadv)
		if (@cusadv_no is null)
			begin
				set @cusadv_no =1
			end
	if (@cusadv_ckso =0)
		begin
			set @mso_id=null
		end
	if (@cusadv_cktax=0)
		begin
			set @cusadv_roff=0
			set @cusadv_whtper=0
			set @cusadv_whtamt=0
			set @cusadv_tamt=@cusadv_amt
			set @cusadv_gstwhtamt=0
			set @cusadv_gstwhtper =0
			set @cusadv_gstwhtamt1=0
		end
	if (@cusadv_cktax=1)
		begin
			set @cusadv_taxid=(select MAX(cusadv_taxid)+1 from t_cusadv where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@cusadv_taxid is null)
				begin
					set @cusadv_taxid =1
				end

		end
	if (@cusadv_cb !='B')
		begin
			set @cusbk_id=null
		end
	--Inserting the record
	insert into t_cusadv (com_id,br_id,cusadv_id,cusadv_no,cusadv_taxid,cusadv_dat,cusadv_rat,cusadv_cktax,cusadv_autoadj,cusadv_amt,cusadv_ckgstwht,cusadv_gstwhtamt,cusadv_gstwhtper,cusadv_gstwhtamt1,cusadv_roff,cusadv_whtper,cusadv_whtamt,cusadv_tamt,cusadv_cb,cusbk_id,cusadv_chq,cusadv_chqdat,cusadv_rmk,cus_id,cusadv_ckso,cusadv_can,mso_id,cur_id,m_yr_id,acc_no,log_act,log_dat,usr_id,log_ip)
	values(@com_id,@br_id,@cusadv_id,@cusadv_no,@cusadv_taxid,@cusadv_dat,@cusadv_rat,@cusadv_cktax,@cusadv_autoadj,@cusadv_amt,@cusadv_ckgstwht,@cusadv_gstwhtamt,@cusadv_gstwhtper,@cusadv_gstwhtamt1,@cusadv_roff,@cusadv_whtper,@cusadv_whtamt,@cusadv_tamt,@cusadv_cb,@cusbk_id,@cusadv_chq,@cusadv_chqdat,@cusadv_rmk,@cus_id,@cusadv_ckso,@cusadv_can,@mso_id,@cur_id,@m_yr_id,@acc_no,@log_act,@log_dat,@usr_id,@log_ip)			

		set @cusadv_id_out=@cusadv_id
		set @cusadv_taxid_out=@cusadv_taxid

	

	--GL
	exec sp_voucher_cusadv @cusadv_id
	set @log_newval= 'ID=' + cast(@cusadv_id as varchar) + '-' + cast(@log_newval as varchar(max))

	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
	
end
go

--exec sp_upd_cusadv '01','01','01',3,'06/17/2012',8000,752000,-48000,'B',1,'manual',100,1,1,'03002003001001','','',1,''
--select * from t_dvch where mvch_id='002-20120617'

--Update
alter  proc sp_upd_cusadv(@com_id char(2),@br_id char(4),@m_yr_id char(2),@cusadv_id int,@cusadv_dat datetime,@cusadv_rat float,@cusadv_autoadj bit,@cusadv_amt float,@cusadv_ckgstwht bit,@cusadv_gstwhtamt float,@cusadv_gstwhtper float,@cusadv_gstwhtamt1 float,@cusadv_cktax bit,@cusadv_roff bit,@cusadv_whtper float,@cusadv_whtamt float,@cusadv_tamt float,@cusadv_cb char(1),@cusbk_id int,@cusadv_chq int,@cusadv_chqdat datetime,@cusadv_rmk varchar(250),@cus_id int,@cusadv_ckso bit,@cusadv_can bit,@mso_id int,@cur_id int,@acc_id char(20),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@cusadv_taxid_out int output)
as
declare

@acc_no int,
@cusadv_taxid int,
@cusadv_cktax_old bit,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @acc_no=(select acc_no from gl_m_acc where acc_id=@acc_id)
	set @cusadv_taxid=(select cusadv_taxid from t_cusadv where cusadv_id=@cusadv_id)
	set @cusadv_cktax_old=(select cusadv_cktax from t_cusadv where cusadv_id=@cusadv_id)
	if (@cusadv_cktax !=@cusadv_cktax_old)
		begin
			 set @cusadv_taxid=null 
		end
	if (@cusadv_ckso =0)
		begin
			set @mso_id=null
		end

	if (@cusadv_cktax=0)
		begin
			set @cusadv_roff=0
			set @cusadv_whtper=0
			set @cusadv_whtamt=0
			set @cusadv_tamt=@cusadv_amt
			set @cusadv_gstwhtamt=0
			set @cusadv_gstwhtper=0
			set @cusadv_gstwhtamt1=0
		end
	
	if (@cusadv_cktax=1 and @cusadv_taxid is null)
		begin
			set @cusadv_taxid=(select MAX(cusadv_taxid)+1 from t_cusadv where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@cusadv_taxid is null)
				begin
					set @cusadv_taxid =1
				end

		end		
		
	if (@cusadv_cb !='B')
		begin
			set @cusbk_id=null
		end	
	--Update the record
	update t_cusadv set cusadv_taxid=@cusadv_taxid,cusadv_rat=@cusadv_rat,cusadv_autoadj=@cusadv_autoadj,cusadv_amt=@cusadv_amt,
		cusadv_ckgstwht=@cusadv_ckgstwht,cusadv_gstwhtamt=@cusadv_gstwhtamt,cusadv_gstwhtper=@cusadv_gstwhtper,cusadv_gstwhtamt1=@cusadv_gstwhtamt1,cusadv_cb=@cusadv_cb,cusbk_id=@cusbk_id,cusadv_rmk=@cusadv_rmk,cur_id=@cur_id,acc_no=@acc_no,cusadv_chq=@cusadv_chq,cusadv_chqdat=@cusadv_chqdat,cusadv_can=@cusadv_can,cusadv_ckso=@cusadv_ckso,mso_id=@mso_id,
		cusadv_cktax=@cusadv_cktax,cusadv_roff=@cusadv_roff ,cusadv_whtper=@cusadv_whtper,cusadv_whtamt=@cusadv_whtamt,cusadv_tamt=@cusadv_tamt,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip 
		where cusadv_id=@cusadv_id and com_id=@com_id and br_id=@br_id and m_yr_id=@m_yr_id
	
	set @cusadv_taxid_out=@cusadv_Taxid
	
	--GL
	exec sp_voucher_cusadv @cusadv_id

	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
go
--Delete
alter  proc sp_del_cusadv(@com_id char(2),@br_id char(2),@cusadv_id int,@m_yr_id char(2),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
	
	@mvch_no int,
	@cusadv_taxid int,	
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @cusadv_taxid=(select cusadv_taxid from t_cusadv where cusadv_id=@cusadv_id)
	
	--Delete Voucher
	set @mvch_no =(select mvch_no from t_cusadv where cusadv_id=@cusadv_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete TAX Voucher
	set @mvch_no =(select mvch_taxno from t_cusadv where cusadv_id=@cusadv_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''


	exec sp_del_dcusadv @cusadv_id
	
	update t_cusadv set log_act=@log_act where cusadv_id=@cusadv_id 
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	

end

