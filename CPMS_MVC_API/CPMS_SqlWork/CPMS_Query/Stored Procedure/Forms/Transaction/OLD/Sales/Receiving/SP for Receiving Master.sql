USE MEIJI_RUSK
GO
--alter table t_mrec drop column ins_usr_id ,ins_dat,upd_usr_id,upd_dat 
--alter table t_mrec add mrec_cktax bit,mrec_intax float,mrec_namt float
--update t_mrec set mrec_cktax=0,mrec_intax=0,mrec_namt=mrec_amt
--alter table t_mrec add mrec_taxid int
--select * from t_mrec

--alter table t_mrec add mrec_autoadj bit
--update t_mrec set mrec_autoadj=0
--alter table t_mrec add mrec_gstwhtamt float
--update t_mrec set mrec_gstwhtamt=0
--alter table t_mrec add cusbk_id int
--alter table t_mrec add constraint FK_MREC_CUSBKID foreign key (cusbk_id) references m_cusbk (cusbk_id)
--alter table t_mrec  add mrec_idold varchar(1000) 
--alter table t_mrec add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--alter table t_mrec add mrec_typ char(1)
--update t_mrec set mrec_typ='U'

--select * from t_mso where mso_cashrec >0
--select * from t_mrec where mrec_typ='S'


--Insert
alter  proc sp_ins_mrec(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mrec_dat datetime,@mrec_autoadj bit,@mrec_cktax bit,@mrec_amt float,@mrec_intax float,@mrec_gstwhtamt float,@mrec_namt float,@mrec_epl float,@mrec_cb char(1),@cusbk_id int,@mrec_chq int,@mrec_chqdat datetime,@mrec_rmk varchar(250),@mrec_rat float,@cus_id int,@cur_id int,@acc_id char(20),@mrec_can bit,@mrec_idold varchar(1000),@mrec_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mrec_no_out int output,@mrec_taxid_out int output,@mrec_id_out int output)
as
declare
@mrec_id int,
@mrec_no int,
@mrec_taxid int,
@acc_no int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @acc_no=(select acc_no from gl_m_acc where com_id=@com_id and acc_id=@acc_id)


	set @mrec_id=(select max(mrec_id)+1 from t_mrec)
		if @mrec_id is null
			begin
				set @mrec_id=1
			end

	set @mrec_no=(select max(mrec_no)+1 from t_mrec)
		if @mrec_no is null
			begin
				set @mrec_no=1
			end
	if (@mrec_cb='C')
		begin
			set @mrec_chqdat=@mrec_dat
		end
	if (@mrec_cb!='B')
		begin
			set @cusbk_id=null
		end
		
	if(@mrec_cktax=0)
		begin
			set @mrec_intax=0
			set @mrec_namt=@mrec_amt
		end
	if (@mrec_cktax=1)
		begin
			set @mrec_taxid=(select MAX(mrec_taxid)+1 from t_mrec where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mrec_taxid is null)
				begin
					set @mrec_taxid =1
				end

		end
	--Inserting the record
	insert into t_mrec (com_id,br_id,m_yr_id,mrec_id,mrec_no,mrec_taxid,mrec_gstwhtamt,mrec_dat,mrec_epl,mrec_cb,cusbk_id,mrec_chq,mrec_chqdat,mrec_autoadj,mrec_rat,mrec_rmk,mrec_cktax,mrec_amt,mrec_intax,mrec_namt,cus_id,cur_id,acc_no,mrec_can,mrec_idold,log_act,log_dat,usr_id,log_ip,mrec_typ)
				values(@com_id,@br_id,@m_yr_id,@mrec_id,@mrec_no,@mrec_taxid,@mrec_gstwhtamt,@mrec_dat,@mrec_epl,@mrec_cb,@cusbk_id,@mrec_chq,@mrec_chqdat,@mrec_autoadj,@mrec_rat,@mrec_rmk,@mrec_cktax,@mrec_amt,@mrec_intax,@mrec_namt,@cus_id,@cur_id,@acc_no,@mrec_can,@mrec_idold,@log_act,@log_dat,@usr_id,@log_ip,@mrec_typ)			
		set @mrec_id_out=@mrec_id
		set @mrec_no_out=@mrec_no
		set @mrec_taxid_out=@mrec_taxid

	--Voucher
		exec sp_voucher_rec @mrec_id

	--Audit
set @log_newval= 'ID=' + cast(@mrec_id as varchar) + '-' + cast(@log_newval as varchar(max))
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
	
end
go

--Update
alter  proc sp_upd_mrec(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mrec_id int,@mrec_dat datetime,@mrec_autoadj bit,@mrec_cktax bit,@mrec_amt float,@mrec_intax float,@mrec_gstwhtamt float,@mrec_namt float,@mrec_epl float,@mrec_cb char(1),@cusbk_id int,@mrec_chq int,@mrec_chqdat datetime,@mrec_rmk varchar(250),@mrec_rat float,@cus_id int,@cur_id int,@acc_id char(20),@mrec_can bit,@mrec_typ char(1),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mrec_taxid_out int output)
as
declare
@acc_no int,
@mrec_cktax_old bit,
@mrec_taxid int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	set @acc_no=(select acc_no from gl_m_acc where com_id=@com_id and acc_id=@acc_id)
	
	if (@mrec_cb='C')
		begin
			set @mrec_chqdat=@mrec_dat
		end
	if (@mrec_cb!='B')
		begin
			set @cusbk_id=null
		end
		
	if (@mrec_cktax !=@mrec_cktax_old)
		begin
			 set @mrec_taxid=null 
		end
	if(@mrec_cktax=0)
		begin
			set @mrec_intax=0
			set @mrec_namt=@mrec_amt
		end
	if (@mrec_cktax=1 and @mrec_taxid is null)
		begin
			set @mrec_taxid=(select MAX(mrec_taxid)+1 from t_mrec where com_id=@com_id and m_yr_id=@m_yr_id)
			if (@mrec_taxid is null)
				begin
					set @mrec_taxid =1
				end

		end		
		--Inserting the record
	update t_mrec set mrec_taxid=@mrec_taxid,mrec_autoadj=@mrec_autoadj,mrec_cktax=@mrec_cktax,mrec_amt=@mrec_amt,mrec_intax=@mrec_intax,mrec_gstwhtamt=@mrec_gstwhtamt,mrec_namt=@mrec_namt,mrec_epl=@mrec_epl,mrec_cb=@mrec_cb,cusbk_id=@cusbk_id,mrec_rat=@mrec_rat,mrec_rmk=@mrec_rmk,cur_id=@cur_id,acc_no=@acc_no,mrec_chq=@mrec_chq,mrec_chqdat=@mrec_chqdat,mrec_can=@mrec_can,mrec_typ=@mrec_typ,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
		where mrec_id=@mrec_id

	set @mrec_taxid_out=@mrec_taxid
		--Voucher
		exec sp_voucher_rec @mrec_id

	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

	
end
go
--Delete
alter  proc sp_del_mrec(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mrec_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
	@mvch_no int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	--Delete Voucher
	set @mvch_no =(select mvch_no from t_mrec where mrec_id=@mrec_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete EPL Voucher
	set @mvch_no =(select mvch_no_epl from t_mrec where mrec_id=@mrec_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete TAX Voucher
	set @mvch_no =(select mvch_taxno from t_mrec where mrec_id=@mrec_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete EPL TAX Voucher
	set @mvch_no =(select mvch_taxno_epl from t_mrec where mrec_id=@mrec_id )
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''

	exec sp_del_drec @mrec_id
	delete from t_mrec where mrec_id=@mrec_id
	
	--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end


