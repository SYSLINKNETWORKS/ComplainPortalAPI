USE ZSONS
GO
--alter table t_loan add tloan_rmk varchar(250)
--alter table t_loan add com_id char(2),br_id char(3),m_yr_id char(2)
--ALTER table t_loan add acc_no int,mvch_no int
--alter table t_loan drop column acc_id,mvch_id


--Insert
alter  proc [dbo].[ins_t_loan](@com_id char(2),@br_id char(3),@m_yr_id char(3),@tloan_dat datetime,@tloan_amt float,@tloan_ins float,@tloan_insamt float,@tloan_rmk varchar(250),@tloan_typ char(1),@emppro_id char(3),@acc_id char(20),@mvch_typ char(2),@tloan_chq int,@tloan_cb char(1),@mloan_id int,@tloan_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@tloan_id			int,
@aud_act char(20),
@acc_no int 
begin

	set @aud_act='Insert'

	set @acc_no=(select acc_no from gl_m_Acc where acc_id=@acc_id)
	set @tloan_id =(select max(tloan_id) from t_loan)+1

	if (@tloan_id is null)
		begin	
			set @tloan_id=1
		end

	insert into t_loan (com_id,br_id,m_yr_id,tloan_id,tloan_dat,tloan_amt,tloan_ins,tloan_insamt,tloan_rmk,mloan_id,acc_no,tloan_chq,tloan_cb,emppro_id,tloan_typ,tloan_st)
	values
						(@com_id,@br_id,@m_yr_id,@tloan_id,@tloan_dat,@tloan_amt,@tloan_ins,@tloan_insamt,@tloan_rmk,@mloan_id,@acc_no,@tloan_chq,@tloan_cb,@emppro_id,@tloan_typ,0)

	set @tloan_id_out=@tloan_id


	---GL 
		exec sp_voucher_loan @tloan_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_t_loan](@com_id char(2),@br_id char(3),@m_yr_id char(3),@tloan_id int,@tloan_dat datetime,@tloan_amt float,@tloan_ins float,@tloan_insamt float,@tloan_rmk varchar(250),@mloan_id int,@emppro_id char(3),@tloan_typ char(1),@acc_id char(20),@mvch_typ char(2),@tloan_chq int,@tloan_cb char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(10),
@acc_no int
begin

	set @aud_act='Update'
	set @acc_no =(select acc_no from gl_m_Acc where acc_id=@acc_id)

	update t_loan 
			set tloan_dat=@tloan_dat,tloan_amt=@tloan_amt, tloan_ins=@tloan_ins,tloan_insamt =@tloan_insamt ,tloan_rmk=@tloan_rmk,tloan_typ=@tloan_typ,mloan_id=@mloan_id, emppro_id=emppro_id,acc_no=@acc_no,mvch_typ=@mvch_typ,tloan_chq=@tloan_chq,tloan_cb=@tloan_cb
			where tloan_id=@tloan_id 

	---GL 
		exec sp_voucher_loan @tloan_id 
		
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter  proc [dbo].[del_t_loan](@com_id char(2),@br_id char(3),@tloan_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20),
@mvch_no int
begin
	set @aud_act='Delete'
	set @mvch_no=(select mvch_no from t_loan where tloan_id=@tloan_id)

	--GL
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''

	delete from t_loan  
			where tloan_id=@tloan_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

