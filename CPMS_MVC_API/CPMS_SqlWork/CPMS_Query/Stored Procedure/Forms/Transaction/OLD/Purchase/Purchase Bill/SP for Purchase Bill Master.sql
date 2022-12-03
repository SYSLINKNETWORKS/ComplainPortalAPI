USE NATHI
GO
 --alter table t_mpb drop column ins_usr_id,ins_dat,upd_usr_id,upd_dat

--select * from t_mpb

--alter table t_mpb add mpb_othamt float,mpb_tothamt as mpb_rat*mpb_othamt
--update t_mpb set mpb_othamt=0 where mpb_othamt is null
--alter table t_mpb add mpb_can bit
--ALter table t_mpb add com_id char(2),br_id char(3)

--alter table t_mpb drop column mvch_id
--alter table t_mpb add mvch_no int



--select * from t_mpb where mpb_id=304
--update t_mpb set mpb_st=0 where mpb_id=304
--update t_mpb set mpb_st=0 where mpb_id=337

--alter table t_mpb add mpb_gstwhtper float,mpb_gstwhtamt float
--update t_mpb set mpb_gstwhtper=0,mpb_gstwhtamt=0


--update t_mpb set mpb_con='-'
--alter table t_mpb add mpb_cktax bit,mpb_gstamt float,mpb_fedamt float,mpb_advper float,mpb_advtax float,mpb_othper float,mpb_othtax float
--update t_mpb set mpb_cktax=0,mpb_gstamt=0,mpb_fedamt=0,mpb_advper=0,mpb_advtax=0,mpb_othper=0,mpb_othtax=0
--ALTER table t_mpb add sup_billdat datetime
--alter table t_mpb alter column sup_bill varchar(100)

--update t_mpb set sup_billdat=mpb_dat
--alter table t_mpb add mpb_taxid int

--alter table t_mpb drop column mpb_gstwhtper,mpb_gstwhtamt

--alter table t_mpb add mpb_taxamt float,mpb_taxgamt float,mpb_taxnamt float
--update t_mpb set mpb_taxamt=0,mpb_taxgamt=0,mpb_taxnamt =0

--alter table t_mpb add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--alter table t_mpb add mpb_auth bit
--update t_mpb set mpb_auth=1

--alter table t_mpb add mpb_frecon char(1)
--update t_mpb set mpb_frecon='+'

--Insert
alter proc ins_t_mpb(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpb_dat datetime,@mpb_typ char(1),@grn_no varchar(100),@mpb_rat float,@cur_id int,@sup_id int,@mpb_rmk varchar(250),@sup_bill varchar(100),@sup_billdat datetime,@mpb_cktax bit,@mpb_taxamt float,@mpb_gstamt float,@mpb_fedamt float,@mpb_amt float,@mpb_taxgamt float,@mpb_disper float,@mpb_disamt float,@mpb_advper float,@mpb_advtax float,@mpb_othper float,@mpb_othtax float,@mpb_desamt float,@mpb_othamt float,@mpb_namt float,@mpb_taxnamt float,@mpb_fre float,@mpb_con char(1),@mpb_can bit,@mpb_auth bit,@mpb_frecon char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mpb_taxid_out int output,@mpb_id_out int output)
as
declare
@mpb_id int,
@mpb_taxid int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	

	
	set @mpb_id=(select max(mpb_id)+1 from t_mpb)
		if @mpb_id is null
			begin
				set @mpb_id=1
			end
	if (@mpb_cktax=0)
		begin
			set @mpb_taxamt=0
			set @mpb_taxgamt=0
			set @mpb_taxnamt=0
			set @mpb_gstamt=0
			set @mpb_fedamt =0
			set @mpb_advper=0
			set @mpb_advtax=0
			set @mpb_othper =0
			set @mpb_othtax=0
		end
		
	if (@mpb_cktax=1)
		begin
			set @mpb_taxid=(select MAX(mpb_taxid)+1 from t_mpb where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mpb_taxid is null)
				begin
					set @mpb_taxid =1
				end

		end
				
	insert into t_mpb(com_id,br_id,mpb_id,mpb_taxid,mpb_dat,mpb_typ,sup_id,mpb_st,mpb_rmk,mpb_rat,cur_id,sup_bill,sup_billdat,mpb_cktax,mpb_taxamt,mpb_gstamt,mpb_fedamt,mpb_amt,mpb_taxgamt,mpb_disper,mpb_disamt,mpb_advper,mpb_advtax,mpb_othper,mpb_othtax,mpb_desamt,mpb_othamt,mpb_namt,mpb_taxnamt,mpb_fre,mpb_con,m_yr_id,mgrn_id,mpb_can,mpb_auth,log_act,log_dat,usr_id,log_ip,mpb_frecon)
			values(@com_id,@br_id,@mpb_id,@mpb_taxid,@mpb_dat,@mpb_typ,@sup_id,0,@mpb_rmk,@mpb_rat,@cur_id,@sup_bill,@sup_billdat,@mpb_cktax,@mpb_taxamt,@mpb_gstamt,@mpb_fedamt,@mpb_amt,@mpb_taxgamt,@mpb_disper,@mpb_disamt,@mpb_advper,@mpb_advtax,@mpb_othper,@mpb_othtax,@mpb_desamt,@mpb_othamt,@mpb_namt,@mpb_taxnamt,@mpb_fre,@mpb_con,@m_yr_id,@grn_no,@mpb_can,@mpb_auth,@log_act,@log_dat,@usr_id,@log_ip,@mpb_frecon)

	set @mpb_id_out=@mpb_id
	set @mpb_taxid_out=@mpb_taxid

	set @log_newval= 'ID=' + cast(@mpb_id as varchar) + '-' + cast(@log_newval as varchar(max))

  --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	


end

GO
--Update
alter proc upd_t_mpb(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpb_id int,@mpb_typ char(1),@grn_no varchar(100),@cur_id int,@mpb_rat float,@mpb_rmk varchar(250),@sup_bill varchar(100),@sup_billdat datetime,@mpb_cktax bit,@mpb_taxamt float,@mpb_gstamt float,@mpb_fedamt float,@mpb_amt float,@mpb_taxgamt float,@mpb_disper float,@mpb_disamt float,@mpb_advper float,@mpb_advtax float,@mpb_othper float,@mpb_othtax float,@mpb_desamt float,@mpb_othamt float,@mpb_namt float,@mpb_taxnamt float,@mpb_fre float,@mpb_con char(1),@mpb_can bit,@mpb_auth bit,@mpb_frecon char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mpb_taxid_out int output)
as
declare
@mpb_taxid int,
@mpb_cktax_old bit,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	set @mpb_taxid=(select mpb_taxid from t_mpb where mpb_id=@mpb_id)
	set @mpb_cktax_old=(select mpb_cktax from t_mpb where mpb_id=@mpb_id)
	if (@mpb_cktax !=@mpb_cktax_old)
		begin
			 set @mpb_taxid=null 
		end

	if (@mpb_cktax=0)
		begin
			set @mpb_taxamt=0
			set @mpb_taxgamt=0
			set @mpb_taxnamt=0
			set @mpb_gstamt=0
			set @mpb_fedamt =0
			set @mpb_advper=0
			set @mpb_advtax=0
			set @mpb_othper =0
			set @mpb_othtax=0
		end
	if (@mpb_cktax=1 and @mpb_taxid is null)
		begin
			set @mpb_taxid=(select MAX(mpb_taxid)+1 from t_mpb where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mpb_taxid is null)
				begin
					set @mpb_taxid =1
				end

		end	
	
	update t_mpb set mpb_taxid=@mpb_taxid,mpb_typ=@mpb_typ,mpb_rmk=@mpb_rmk,mpb_rat=@mpb_rat,cur_id=@cur_id,sup_bill=@sup_bill,sup_billdat=@sup_billdat,mpb_cktax=@mpb_cktax,mpb_taxamt=@mpb_taxamt,mpb_gstamt=@mpb_gstamt,mpb_fedamt=@mpb_fedamt,mpb_amt=@mpb_amt,mpb_taxgamt=@mpb_taxgamt,mpb_disper=@mpb_disper,mpb_disamt=@mpb_disamt,mpb_advper=@mpb_advper,mpb_advtax=@mpb_advtax,mpb_othper=@mpb_othper,mpb_othtax=@mpb_othtax,mpb_desamt=@mpb_desamt,mpb_othamt=@mpb_othamt,mpb_namt=@mpb_namt,mpb_taxnamt=@mpb_taxnamt	,mpb_fre=@mpb_fre,mpb_con=@mpb_con,mgrn_id=@grn_no,mpb_can=@mpb_can,mpb_auth=@mpb_auth,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip,mpb_frecon=@mpb_frecon
		where mpb_id=@mpb_id
	set @mpb_taxid_out =@mpb_taxid
	if (@mpb_can=1)
		begin
			--GRN Status
			update t_mgrn set mgrn_act=0,mgrn_typ='U' where mgrn_id in (select mgrn_id from t_dpb_grn where mpb_id=@mpb_id)
		end

	 --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
  
end

go


--Delete
alter proc del_t_mpb(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpb_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@mvch_no int,
@log_dat datetime
begin
	set @log_dat=GETDATE()

	--Delete Voucher
	set @mvch_no=(select mvch_no from t_mpb where mpb_id=@mpb_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete TAX Voucher
	set @mvch_no=(select mvch_taxno from t_mpb where mpb_id=@mpb_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''

	--GRN Status
	update t_mgrn set mgrn_act=0,mgrn_typ='U' where mgrn_id in (select mgrn_id from t_dpb_grn where mpb_id=@mpb_id)

	--Delete Record
	exec del_t_dpb_grn @mpb_id
	exec del_t_dpb @mpb_id
	update t_mpb set log_act=@log_act where mpb_id=@mpb_id	 

	 --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
