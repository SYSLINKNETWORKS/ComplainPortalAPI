USE phm
GO
--alter table t_mcn drop column ins_usr_id,ins_dat,upd_usr_id,upd_dat 
--alter table t_mcn add mcn_cktax bit,mcn_gstamt float,mcn_fedamt float
--update t_mcn set mcn_gstamt=0,mcn_fedamt=0,mcn_cktax=0
--alter table t_mcn add mcn_taxid int

--alter table t_mcn add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter proc ins_t_mcn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mcn_dat datetime,@mcn_rmk varchar(250),@mcn_cktax bit,@mcn_gstamt float,@mcn_fedamt float,@mcn_amt float,@mcn_disamt float,@mcn_gamt float,@mcn_freamt float,@mcn_namt float,@mcn_typ char(1),@cus_id int,@wh_id int,@minv_no int,@mcn_can bit,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mcn_no_out int output,@mcn_taxid_out int output,@mcn_id_out int output)
as
declare
@mcn_id int,
@mcn_no int,
@cur_id int,
@mcn_currat float,
@minv_id int,
@mcn_taxid int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @minv_id=(select minv_id from t_minv where minv_no=@minv_no)
	set @cur_id=(select cur_id from t_minv where minv_id=@minv_id)
	set @mcn_currat=(select minv_rat from t_minv where minv_id=@minv_id)

	set @mcn_id=(select max(mcn_id)+1 from t_mcn)
		if @mcn_id is null
			begin
				set @mcn_id=1
			end
	set @mcn_no=(select max(mcn_no)+1 from t_mcn)
		if @mcn_no is null
			begin
				set @mcn_no=1
			end
	
	if (@mcn_cktax=1)
		begin
			set @mcn_taxid=(select MAX(mcn_taxid)+1 from t_mcn where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mcn_taxid is null)
				begin
					set @mcn_taxid =1
				end

		end
	
	insert into t_mcn(com_id,br_id,m_yr_id,mcn_id,mcn_no,mcn_taxid,mcn_dat,mcn_rmk,mcn_typ,mcn_cktax,mcn_gstamt,mcn_fedamt,mcn_amt,mcn_disamt,mcn_gamt,mcn_freamt,mcn_namt,minv_id,mcn_act,mcn_can,wh_id,cus_id,cur_id,mcn_currat,log_act,log_dat,usr_id,log_ip)
			values(@com_id,@br_id,@m_yr_id,@mcn_id,@mcn_no,@mcn_taxid,@mcn_dat,@mcn_rmk,@mcn_typ,@mcn_cktax,@mcn_gstamt,@mcn_fedamt,@mcn_amt,@mcn_disamt,@mcn_gamt,@mcn_freamt,@mcn_namt,@minv_id,0,@mcn_can,@wh_id,@cus_id,@cur_id,@mcn_currat,@log_act,@log_dat,@usr_id,@log_ip)
	set @mcn_id_out=@mcn_id
	set @mcn_no_out=@mcn_no
	set @mcn_taxid_out =@mcn_taxid
	
set @log_newval= 'ID=' + cast(@mcn_id as varchar) + '-' + cast(@log_newval as varchar(max))

	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		
go
--Update
alter proc upd_t_mcn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mcn_id int,@mcn_dat datetime,@mcn_rmk varchar(250),@cus_id int,@mcn_cktax bit,@mcn_gstamt float,@mcn_fedamt float,@mcn_amt float,@mcn_disamt float,@mcn_gamt float,@mcn_freamt float,@mcn_namt float,@minv_no int,@wh_id int,@mcn_typ char(1),@mcn_can bit,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mcn_taxid_out int output)
as
declare

@cur_id int,
@mcn_currat float,
@minv_id int,
@mcn_taxid int,
@mcn_cktax_old bit,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	set @minv_id=(select minv_id from t_minv where minv_no=@minv_no)
	
	set @cur_id=(select cur_id from t_minv where minv_id=@minv_id)
	set @mcn_currat=(select minv_rat from t_minv where minv_id=@minv_id)
		
	set @mcn_taxid=(select mcn_taxid from t_mcn where mcn_id=@mcn_id)
	set @mcn_cktax_old=(select mcn_cktax from t_mcn where mcn_id=@mcn_id)
	if (@mcn_cktax !=@mcn_cktax_old)
		begin
			 set @mcn_taxid=null 
		end
		
	if (@mcn_cktax=1 and @mcn_taxid is null)
		begin
			set @mcn_taxid=(select MAX(mcn_taxid)+1 from t_mcn where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mcn_taxid is null)
				begin
					set @mcn_taxid =1
				end

		end		
		
	update t_mcn set mcn_taxid=@mcn_taxid,mcn_dat=@mcn_dat,mcn_rmk=@mcn_rmk,mcn_typ=@mcn_typ,cur_id=@cur_id,mcn_currat=@mcn_currat,mcn_cktax=@mcn_cktax,mcn_gstamt=@mcn_gstamt,mcn_fedamt=@mcn_fedamt,mcn_amt=@mcn_amt,mcn_disamt=@mcn_disamt,mcn_gamt=@mcn_gamt,mcn_freamt=@mcn_freamt,mcn_namt=@mcn_namt ,mcn_can=@mcn_can,wh_id=@wh_id,cus_id=@cus_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip where mcn_id=@mcn_id
	set @mcn_taxid_out=@mcn_taxid
	
		--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
go

--Delete
alter proc del_t_mcn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mcn_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@mvch_no int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	--Delete Voucher
	set @mvch_no=(select mvch_no from t_mcn where mcn_id=@mcn_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete Tax Voucher
	set @mvch_no=(select mvch_taxno from t_mcn where mcn_id=@mcn_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	
	exec del_t_dcn @mcn_id
	update t_mcn set log_act=@log_act where mcn_id=@mcn_id 
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		

