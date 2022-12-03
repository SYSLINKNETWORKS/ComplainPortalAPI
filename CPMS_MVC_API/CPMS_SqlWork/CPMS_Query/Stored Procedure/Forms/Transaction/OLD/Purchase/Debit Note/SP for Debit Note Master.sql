USE phm
GO
--alter table t_mdn drop column mvch_id
--alter table t_mdn add mvch_no int
--alter table t_mdn drop column ins_usr_id ,ins_dat ,upd_usr_id ,upd_dat 

--alter table t_mdn add com_id char(2),br_id char(3)
--alter table t_mdn add constraint FK_mdn_COMID foreign key (com_id) references m_com(com_id)
--alter table t_mdn add constraint FK_mdn_BRID foreign key (br_id) references m_br(br_id)
--update t_mdn set com_id='01',br_id='01'

--alter table t_mdn add mdn_cktax bit,mdn_gstamt float,mdn_fedamt float
--update t_mdn set mdn_cktax =0,mdn_gstamt=0,mdn_fedamt=0
--alter table t_mdn add mdn_taxid int
--alter table t_mdn add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(10)

--Insert
alter  proc ins_t_mdn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mdn_dat datetime,@mdn_typ char(1),@mpb_id int,@mdn_cktax bit,@wh_id int,@mdn_rmk varchar(250),@mdn_rat float,@cur_id int,@mdn_gstamt float,@mdn_fedamt float,@mdn_amt float,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mdn_taxid_out int output,@mdn_id_out int output)
as
declare
@mdn_id int,
@mdn_taxid int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	
	set @mdn_id=(select max(mdn_id)+1 from t_mdn)
		if @mdn_id is null
			begin
				set @mdn_id=1
			end
	
	if (@mdn_cktax=1)
		begin
			set @mdn_taxid=(select MAX(mdn_taxid)+1 from t_mdn where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mdn_taxid is null)
				begin
					set @mdn_taxid =1
				end

		end
		
	insert into t_mdn(com_id,br_id,mdn_id,mdn_taxid,mdn_dat,mdn_typ,mpb_id,wh_id,mdn_cktax,mdn_gstamt,mdn_fedamt,mdn_amt,m_yr_id,mdn_rmk,mdn_rat,cur_id,log_act,log_dat,usr_id,log_ip)
			values(@com_id,@br_id,@mdn_id,@mdn_taxid,@mdn_dat,@mdn_typ,@mpb_id,@wh_id,@mdn_cktax,@mdn_gstamt,@mdn_fedamt,@mdn_amt,@m_yr_id,@mdn_rmk,@mdn_rat,@cur_id,@log_act,@log_dat,@usr_id,@log_ip)

	set @mdn_id_out=@mdn_id
	set @mdn_taxid_out=@mdn_taxid
set @log_newval= 'ID=' + cast(@mdn_id as varchar) + '-' + cast(@log_newval as varchar(max))

  --Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end


go
--Update
alter  proc upd_t_mdn(@com_id char(2),@br_id char(3),@mdn_id int,@mdn_dat datetime,@mdn_typ char(1),@m_yr_id char(2),@mpb_id int,@mdn_cktax bit,@wh_id int,@mdn_rmk varchar(250),@mdn_rat float,@cur_id int,@mdn_gstamt float,@mdn_fedamt float,@mdn_amt float,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mdn_taxid_out int output)
as
declare
@mdn_taxid int,
@mdn_cktax_old bit,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	

	set @mdn_taxid=(select mdn_taxid from t_mdn where mdn_id=@mdn_id)
	set @mdn_cktax_old=(select mdn_cktax from t_mdn where mdn_id=@mdn_id)
	if (@mdn_cktax !=@mdn_cktax_old)
		begin
			 set @mdn_taxid=null 
		end

	if (@mdn_cktax=1 and @mdn_taxid is null)
		begin
			set @mdn_taxid=(select MAX(mdn_taxid)+1 from t_mdn where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mdn_taxid is null)
				begin
					set @mdn_taxid =1
				end

		end	
	update t_mdn set mdn_taxid=@mdn_taxid,mdn_typ=@mdn_typ,mdn_cktax=@mdn_cktax,mdn_gstamt=@mdn_fedamt,mdn_fedamt=@mdn_fedamt,mdn_amt=@mdn_amt,mdn_rmk=@mdn_rmk,mdn_rat=@mdn_rat,cur_id=@cur_id,wh_id=@wh_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
	where mdn_id=@mdn_id
	
	set @mdn_taxid_out=@mdn_taxid
--Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat


end



go
--Delete
alter proc del_t_mdn(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mdn_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@mvch_no int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	

	--Delete Voucher
	set @mvch_no=(select mvch_no from t_mdn where mdn_id=@mdn_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete TAX Voucher
	set @mvch_no=(select mvch_taxno from t_mdn where mdn_id=@mdn_id)
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''

	--MPB Status
	update t_mpb set mpb_st=0 where mpb_id =(select mpb_id from t_mdn where mdn_id=@mdn_id)

	--Delete Record
	exec del_t_ddn @mdn_id,@m_yr_id
	
	update t_mdn set log_act=@log_act where mdn_id=@mdn_id	
	--Audit
  exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
