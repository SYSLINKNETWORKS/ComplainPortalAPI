USE NATHI
GO
--alter table t_mcn add ins_usr_id char(2),ins_dat datetime,upd_usr_id char(2),upd_dat datetime
--alter table t_mcn add mcn_cktax bit,mcn_gstamt float,mcn_fedamt float
--update t_mcn set mcn_gstamt=0,mcn_fedamt=0,mcn_cktax=0
--alter table t_mcn add mcn_taxid int

--alter table t_mcn add mcn_cnamt float
--alter table t_mcn add ck_itmret bit
--alter table t_mcn drop column mcn_cnamt
--alter table t_mcn add ck_amtadj bit
--alter table t_mcn drop column ck_amtadj
--alter table t_mcn drop column ck_itmret

--alter table t_mcn add mcn_ckamtadj bit,mcn_ckitmret bit
--update t_mcn set mcn_ckamtadj=0,mcn_ckitmret=0

--alter table t_mcn add mcn_disper float
--update t_mcn set mcn_disper=0
--ALTER TABLE T_mcn add mvch_taxno int

--alter table t_mcn add mcn_cash float
--alter table t_mcn add mcn_bdisper float,mcn_bdisamt float


--Insert
alter proc ins_t_mcn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mcn_dat datetime,@mcn_rmk varchar(250),@mcn_amt float,@mcn_bdisper float,@mcn_bdisamt float,@mcn_disper float,@mcn_disamt float,@mcn_namt float,@mcn_typ char(1),@mcn_can bit,@mcn_cash float,@mso_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mcn_no_out int output,@mcn_id_out int output)
as
declare
@mcn_id int,
@mcn_no int,
@cur_id int,
@mcn_currat float,
@aud_act char(10),
@minv_id int,
@mcn_taxid int,
@mcn_cktax bit,@mcn_gstamt float,@mcn_fedamt float,
@mcn_gamt float,@mcn_freamt float,
@cus_id int,@wh_id int,@minv_no int,
@mcn_ckitmret bit,
@mdc_id int
begin

	set @mdc_id=(select mdc_id from t_mdc where mso_id=@mso_id)
	set @minv_id=(select distinct minv_id from t_dinv where mdc_id=@mdc_id)
	set @mcn_cktax=0
	set @mcn_gstamt=0
	set @mcn_fedamt =0
	set @mcn_gamt=0
	set @mcn_freamt =0
	set @mcn_ckitmret =1
	set @cus_id=(select cus_id from t_mso where mso_id=@mso_id)
	set @wh_id=(select wh_id from t_mdc where mdc_id=@mdc_id)
	set @aud_act='Insert'
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
	
	insert into t_mcn(com_id,br_id,m_yr_id,mcn_id,mcn_no,mcn_taxid,mcn_dat,mcn_rmk,mcn_typ,mcn_cktax,mcn_gstamt,mcn_fedamt,mcn_amt,mcn_disper,mcn_disamt,mcn_gamt,mcn_freamt,mcn_namt,minv_id,mcn_act,mcn_can,wh_id,cus_id,cur_id,mcn_currat,ins_usr_id,ins_dat,mcn_ckitmret,mcn_cash,mcn_bdisper,mcn_bdisamt)
			values(@com_id,@br_id,@m_yr_id,@mcn_id,@mcn_no,@mcn_taxid,@mcn_dat,@mcn_rmk,@mcn_typ,@mcn_cktax,@mcn_gstamt,@mcn_fedamt,@mcn_amt,@mcn_disper,@mcn_disamt,@mcn_gamt,@mcn_freamt,@mcn_namt,@minv_id,0,@mcn_can,@wh_id,@cus_id,@cur_id,@mcn_currat,@usr_id,GETDATE(),@mcn_ckitmret,@mcn_cash,@mcn_bdisper,@mcn_bdisamt)
	set @mcn_id_out=@mcn_id
	set @mcn_no_out=@mcn_no

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
--Voucher
	--if (@mcn_ckamtadj !=0)
	--	begin
				exec sp_voucher_cn @mcn_id 
	--	end
end
		
go
--Update
alter proc upd_t_mcn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mcn_id int,@mcn_dat datetime,@mcn_rmk varchar(250),@mcn_amt float,@mcn_disper float,@mcn_disamt float,@mcn_namt float,@mso_id int,@mcn_typ char(1),@mcn_can bit,@mcn_cash float,@mcn_bdisper float,@mcn_bdisamt float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@cur_id int,
@mcn_currat float,
@minv_id int,
@mcn_taxid int,
@mcn_cktax_old bit,
@cus_id int,@mcn_cktax bit,@mcn_gstamt float,@mcn_fedamt float,
@mcn_gamt float,
@mcn_freamt float,
@mcn_ckitmret bit,
@wh_id int,
@mdc_id int
begin
	set @mdc_id=(select mdc_id from t_mdc where mso_id=@mso_id)
	set @minv_id=(select distinct minv_id from t_dinv where mdc_id=@mdc_id)
	set @mcn_cktax=0
	set @mcn_gstamt=0
	set @mcn_fedamt =0
	set @mcn_gamt=0
	set @mcn_freamt =0
	set @mcn_ckitmret =1
	set @cus_id=(select cus_id from t_mso where mso_id=@mso_id)
	set @wh_id=(select wh_id from t_mdc where mdc_id=@mdc_id)
	set @aud_act ='Update'
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
		
	update t_mcn set mcn_taxid=@mcn_taxid,mcn_dat=@mcn_dat,mcn_rmk=@mcn_rmk,mcn_typ=@mcn_typ,cur_id=@cur_id,mcn_currat=@mcn_currat,mcn_cktax=@mcn_cktax,mcn_gstamt=@mcn_gstamt,mcn_fedamt=@mcn_fedamt,mcn_amt=@mcn_amt,mcn_disper=@mcn_disper,mcn_disamt=@mcn_disamt,mcn_gamt=@mcn_gamt,mcn_freamt=@mcn_freamt,mcn_namt=@mcn_namt ,mcn_can=@mcn_can,wh_id=@wh_id,cus_id=@cus_id,upd_usr_id=@usr_id,upd_dat=GETDATE(),mcn_ckitmret=@mcn_ckitmret ,mcn_cash=@mcn_cash,mcn_bdisper=@mcn_bdisper,mcn_bdisamt=@mcn_bdisamt
	 where mcn_id=@mcn_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

--Voucher
	--if (@mcn_ckamtadj !=0)
	--	begin
				exec sp_voucher_cn @mcn_id 
	--	end
	
end
go

--Delete
alter proc del_t_mcn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mcn_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_no int
begin
	set @aud_act='Delete'
	--Delete Voucher
	set @mvch_no=(select mvch_no from t_mcn where mcn_id=@mcn_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete Tax Voucher
	set @mvch_no=(select mvch_taxno from t_mcn where mcn_id=@mcn_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	
	exec del_t_dcn @mcn_id
	delete t_mcn where mcn_id=@mcn_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		

