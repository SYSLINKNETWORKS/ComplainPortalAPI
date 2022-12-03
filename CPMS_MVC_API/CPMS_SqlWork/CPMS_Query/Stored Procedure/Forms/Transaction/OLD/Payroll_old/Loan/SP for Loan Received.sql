USE ZSONS
GO
--select * from t_rec_loan
--alter table t_rec_loan add com_id char(2),br_id char(3),m_yr_id char(2)
--ALTER table t_rec_loan add acc_no int,mvch_no int
--alter table t_rec_loan drop column acc_id,mvch_id


--Insert
alter  proc [dbo].[ins_t_rec_loan](@com_id char(2),@br_id char(3),@m_yr_id char(3),@trec_dat datetime,@trec_amt float,@tloan_id int,@trec_typ char(1),@acc_id char(20),@mvch_typ char(2),@trec_chq int,@trec_cb char(1),@trec_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@trec_id			int,
@aud_act char(20),
@acc_no int,
@tloan_amt float
begin
	set @aud_act='Insert'
	set @acc_no=(select acc_no from gl_m_Acc where acc_id=@acc_id)

	set @trec_id =(select max(trec_id) from t_rec_loan)+1

	if (@trec_id is null)
		begin	
			set @trec_id=1
		end

	insert into t_rec_loan (com_id,br_id,m_yr_id,trec_id,trec_dat,trec_amt,tloan_id,trec_typ,acc_no,mvch_typ,trec_chq,trec_cb)
	values
	(@com_id,@br_id,@m_yr_id,@trec_id,@trec_dat,@trec_amt,@tloan_id,@trec_typ,@acc_no,@mvch_typ,@trec_chq,@trec_cb)

	set @trec_id_out=@trec_id

	--Loan Amount 
	set @tloan_amt=(select tloan_amt from t_loan where tloan_id=@tloan_id)
	set @trec_amt=(select sum(trec_amt) from t_rec_loan where tloan_id=@tloan_id)
	if (@tloan_amt=@trec_amt)
		begin
			update t_loan set tloan_st=1 where tloan_id=@tloan_id
		end

	--GL	
		exec sp_voucher_rec_loan @trec_id 
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_t_rec_loan](@com_id char(2),@br_id char(3),@m_yr_id char(3),@trec_id int,@trec_dat datetime,@trec_amt float,@tloan_id int,@trec_typ char(1),@acc_id char(20),@mvch_typ char(2),@trec_chq int,@trec_cb char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20),
@tloan_amt float,
@acc_no int
begin
	set @aud_act='Update'
	set @acc_no=(select acc_no from gl_m_Acc where acc_id=@acc_id)
	update t_rec_loan 
			set trec_dat=@trec_dat,trec_amt=@trec_amt,trec_typ=@trec_typ,acc_no=@acc_no,trec_chq=@trec_chq,trec_cb=@trec_cb,mvch_typ=@mvch_typ,tloan_id=@tloan_id
			where trec_id=@trec_id 

	set @tloan_amt=(select tloan_amt from t_loan where tloan_id=@tloan_id)
	set @trec_amt=(select sum(trec_amt) from t_rec_loan where tloan_id=@tloan_id)
	if (@tloan_amt=@trec_amt)
		begin
			update t_loan set tloan_st=1 where tloan_id=@tloan_id
		end
	--GL
		exec sp_voucher_rec_loan  @trec_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO




--exec del_t_rec_loan '01','01',1,'01',1,'','',''
--Delete
alter  proc [dbo].[del_t_rec_loan](@com_id char(2),@br_id char(3),@trec_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20),
@tloan_id int,
@mvch_no int
begin
	set @aud_act='Delete'

	set @mvch_no=(select mvch_no from t_rec_loan where trec_id=@trec_id)

	set @tloan_id=(select tloan_id from t_rec_loan where trec_id=@trec_id)
	update t_loan set tloan_st=0 where tloan_id=@tloan_id

		--GL
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''

	delete from t_rec_loan  
			where trec_id=@trec_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

