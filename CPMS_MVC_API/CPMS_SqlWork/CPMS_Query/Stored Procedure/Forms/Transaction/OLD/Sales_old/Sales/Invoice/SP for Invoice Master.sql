
USE phm
GO

--alter table t_minv add minv_cktax bit,minv_gstamt float,minv_fedamt float
--update t_minv set minv_cktax=0,minv_gstamt=0,minv_fedamt=0
--alter table t_minv add minv_taxid int
--select * from t_minv where minv_id=15
--alter table t_minv drop column minv_gstwhtper,minv_gstwhtamt

--alter table t_minv add minv_taxdat datetime
--update t_minv set minv_taxdat=minv_dat

--alter table t_minv add minv_taxamt float,minv_taxnamt float
--update t_minv set minv_taxamt=0,minv_taxnamt=0
--update t_minv set minv_taxamt=minv_amt,minv_taxnamt=minv_namt where minv_cktax =1

--alter table t_minv add minv_taxdisamt float
--update t_minv set minv_taxdisamt=0

--alter table t_minv add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

--Insert
alter proc ins_t_minv(@com_id char(2),@br_id char(3),@m_yr_id char(2),@minv_dat datetime,@minv_taxdat datetime,@minv_typ char(1),@dc_no varchar(100),@minv_rat float,@cur_id int,@cus_id int,@minv_rmk varchar(250),@minv_cktax bit,@minv_taxamt float,@minv_gstamt float,@minv_fedamt float,@minv_taxnamt float,@minv_amt float,@minv_disamt float,@minv_freamt float,@minv_othamt float,@minv_namt float,@minv_can bit,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@minv_no_out int output,@minv_taxid_out int output,@minv_id_out int output)
as
declare
@minv_id int,
@minv_no int,
@minv_taxid int,
@minv_taxdisamt float,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @minv_taxdisamt=0
	set @minv_id=(select max(minv_id)+1 from t_minv)
		if @minv_id is null
			begin
				set @minv_id=1
			end
	set @minv_no=(select max(minv_no)+1 from t_minv)
		if @minv_no is null
			begin
				set @minv_no=1
			end	
			
	if (@minv_cktax =0)
		begin
			set @minv_taxamt=0
			set @minv_gstamt=0
			set @minv_fedamt=0
			set @minv_taxnamt=0
		end
	if (@minv_cktax=1)
		begin
			set @minv_taxid=(select MAX(minv_taxid)+1 from t_minv where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@minv_taxid is null)
				begin
					set @minv_taxid =1
				end

		end	
	insert into t_minv(minv_no,minv_id,minv_taxid,minv_dat,minv_taxdat,minv_typ,cus_id,minv_act,minv_rmk,minv_rat,cur_id,minv_cktax,minv_taxnamt,minv_gstamt,minv_fedamt,minv_taxamt,minv_amt,minv_disamt,minv_taxdisamt,minv_freamt,minv_othamt,minv_namt,m_yr_id,mdc_id,com_id,br_id,minv_can,log_act,log_dat,usr_id,log_ip)
			values(@minv_no,@minv_id,@minv_taxid,@minv_dat,@minv_taxdat,@minv_typ,@cus_id,0,@minv_rmk,@minv_rat,@cur_id,@minv_cktax,@minv_taxnamt,@minv_gstamt,@minv_fedamt,@minv_taxnamt,@minv_amt,@minv_disamt,@minv_taxdisamt,@minv_freamt,@minv_othamt,@minv_namt,@m_yr_id,@dc_no,@com_id,@br_id,@minv_can,@log_act,@log_dat,@usr_id,@log_ip)

	set @minv_id_out=@minv_id
	set @minv_no_out=@minv_no
	set @minv_taxid_out=@minv_taxid
	
set @log_newval= 'ID=' + cast(@minv_id as varchar) + '-' + cast(@log_newval as varchar(max))

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	

end

GO
--Update
alter proc upd_t_minv(@com_id char(2),@br_id char(3),@m_yr_id char(3),@minv_id int,@minv_dat datetime,@minv_taxdat datetime,@minv_typ char(1),@dc_no varchar(100),@cur_id int,@cus_id int,@minv_rat float,@minv_rmk varchar(250),@minv_cktax bit,@minv_taxamt float,@minv_gstamt float,@minv_fedamt float,@minv_taxnamt float,@minv_amt float,@minv_disamt float,@minv_freamt float,@minv_othamt float,@minv_namt float,@minv_can bit,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@minv_taxid_out int output)
as
declare
@minv_taxid int,
@minv_cktax_old bit,
@minv_taxdisamt float,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @minv_taxdisamt=0
	set @minv_taxid=(select minv_taxid from t_minv where minv_id=@minv_id)
	set @minv_cktax_old=(select minv_cktax from t_minv where minv_id=@minv_id)
	if (@minv_cktax !=@minv_cktax_old)
		begin
			 set @minv_taxid=null 
		end

	if (@minv_cktax =0)
		begin
			set @minv_taxamt=0
			set @minv_gstamt=0
			set @minv_fedamt=0
			set @minv_taxnamt=0
		end
	
	if (@minv_cktax=1 and @minv_taxid is null)
		begin
			set @minv_taxid=(select MAX(minv_taxid)+1 from t_minv where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@minv_taxid is null)
				begin
					set @minv_taxid =1
				end

		end			
	update t_minv set minv_taxid=@minv_taxid,minv_dat=@minv_dat,minv_taxdat=@minv_taxdat,minv_typ=@minv_typ,minv_rmk=@minv_rmk,cus_id=@cus_id,minv_rat=@minv_rat,cur_id=@cur_id,minv_cktax=@minv_cktax,minv_taxamt=@minv_taxamt,minv_gstamt=@minv_gstamt,minv_taxnamt=@minv_taxnamt,minv_fedamt=@minv_fedamt,minv_amt=@minv_amt,minv_disamt=@minv_disamt,minv_taxdisamt=@minv_taxdisamt,minv_freamt=@minv_freamt,minv_othamt=@minv_othamt,minv_namt=@minv_namt,mdc_id=@dc_no,minv_can=@minv_can,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
		where minv_id=@minv_id

	set @minv_taxid_out=@minv_taxid

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end

go

--Delete
alter proc del_t_minv(@com_id char(2),@br_id char(3),@m_yr_id int,@minv_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@mvch_no int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	
	--Delete Voucher
	set @mvch_no=(select mvch_no from t_minv where minv_id=@minv_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete Tax Voucher
	set @mvch_no=(select mvch_taxno from t_minv where minv_id=@minv_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--dc Status
	update t_mdc set mdc_act=0 where mdc_id in (select mdc_id from t_dinv_dc where minv_id=@minv_id)

	--Delete Record
	exec del_t_dinv_dc @minv_id
	exec del_t_dinv @minv_id	
	update t_minv set log_act=@log_act where minv_id=@minv_id	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

	
end
--select * from tbl_aud1 where aud_dat='2014-05-08 19:06:41.120' and aud_act='Delete'

