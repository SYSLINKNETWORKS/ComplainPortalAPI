
USE MFI
GO

--alter table m_Sys add acc_advstaff char(20)
--update m_Sys set acc_advstaff='03002002003'


--Insert
alter proc [dbo].[ins_t_adv](@adv_dat datetime,@adv_amt float,@emppro_id char(3),@adv_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@adv_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@adv_id			int,
@emppro_nam varchar(250),
@dpt_id char(2),
@mvch_id char(12),
@acc_id  char(20),
@mvch_nar varchar(1000) ,
@aud_act char(20),
@dcus_id int,
@drv_id char(3)
begin
	set @adv_id =(select max(adv_id) from t_adv)+1
	set @dpt_id=(select dpt_id from m_emppro where emppro_id=@emppro_id)
	print @dpt_id
	set @aud_act='Insert'

	if (@adv_id is null)
		begin	
			set @adv_id=1
		end

	if (@adv_typ='E')
		begin
			set @dcus_id=null
			set @drv_id=null
			set @emppro_id=@emppro_id
			set @emppro_nam=(select emppro_nam from m_emppro where emppro_id=@emppro_id)
		end
	else if (@adv_typ='S')
		begin
			set @dcus_id=@emppro_id
			set @drv_id=null
			set @emppro_id=null			
			set @emppro_nam=(select dcus_nam from d_cus where dcus_id=@dcus_id)
		end
	else if (@adv_typ='D')
		begin
			set @dcus_id=null
			set @drv_id=@emppro_id
			set @emppro_id=null
			set @emppro_nam=(select drv_nam from m_drv where drv_id=@drv_id)
		end

	insert into t_adv (adv_id,adv_dat,adv_amt,emppro_id,dcus_id,drv_id,adv_typ)
	values
	(@adv_id,@adv_dat,@adv_amt,@emppro_id,@dcus_id,@drv_id,@adv_typ)

	set @adv_id_out=@adv_id


	---GL 
	--Master Voucher
	exec	ins_t_mvch  @com_id, @br_id ,@adv_dat,@emppro_nam,@dpt_id,'01',@m_yr_id,'Y','C','','S','',@mvch_id_out =@mvch_id output
	update t_adv set mvch_id=@mvch_id where adv_id=@adv_id

	--Detail Voucher
	set @mvch_nar='Paid Advance to Mr. ' + cast(@emppro_nam as varchar(250))
	--Debit
	set @acc_id=(select acc_advstaff from m_sys)
	exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@adv_dat,1,@acc_id,@mvch_nar,@adv_amt,0,'01',@m_yr_id

	--Credit
	set @acc_id=(select cash_acc from m_Sys)
	exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@adv_dat,2,@acc_id,@mvch_nar,0,@adv_amt,'01',@m_yr_id

	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
--exec upd_t_adv 1,'06/14/2011',1000,1,'S','01','01','03',1,'Employee Advance','',''
--select * from t_adv

alter proc [dbo].[upd_t_adv](@adv_id int,@adv_dat datetime,@adv_amt float,@emppro_id int,@adv_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mvch_id char(12),
@emppro_nam varchar(250),
@dpt_id char(2),
@mvch_nar varchar(1000),
@acc_id varchar(20),
@aud_act char(20),
@dcus_id int,
@drv_id char(3)
begin
	set @aud_act='Update'
	set @emppro_nam=(select emppro_nam from m_emppro where emppro_id=@emppro_id)
	set @mvch_id=(select mvch_id from t_adv where adv_id=@adv_id)
	set @dpt_id=(select dpt_id from m_emppro where emppro_id=@emppro_id)

	if (@adv_typ='E')
		begin
			set @dcus_id=null
			set @drv_id=null
			set @emppro_id=@emppro_id
			set @emppro_nam=(select emppro_nam from m_emppro where emppro_id=@emppro_id)
		end
	else if (@adv_typ='S')
		begin
			set @dcus_id=@emppro_id
			set @drv_id=null
			set @emppro_id=null			
			set @emppro_nam=(select dcus_nam from d_cus where dcus_id=@dcus_id)
		end
	else if (@adv_typ='D')
		begin
			set @dcus_id=null
			set @drv_id=@emppro_id
			set @emppro_id=null
			set @emppro_nam=(select drv_nam from m_drv where drv_id=@drv_id)
		end

	update t_adv 
			set adv_dat=@adv_dat,adv_amt=@adv_amt ,adv_typ=@adv_typ, emppro_id=emppro_id,dcus_id=@dcus_id,drv_id=@drv_id
			where adv_id=@adv_id 

	---GL 
	--Master Voucher
	exec upd_t_mvch @com_id,@br_id, @mvch_id,@adv_dat,'01',@m_yr_id,@emppro_nam,@dpt_id,'C','',''
	--delete Detail Voucher
	delete from t_Dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='01'

	--Detail Voucher
	set @mvch_nar='Paid Advance to Mr. ' + cast(@emppro_nam as varchar(250))
	--Debit
	set @acc_id=(select acc_advstaff from m_sys)
	exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@adv_dat,1,@acc_id,@mvch_nar,@adv_amt,0,'01',@m_yr_id

	--Credit
	set @acc_id=(select cash_acc from m_Sys)
	exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@adv_dat,2,@acc_id,@mvch_nar,0,@adv_amt,'01',@m_yr_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--exec [upd_t_adv] "1",'07/01/2010','06/30/2011',1,2,14,100,'U','01','01','03',1,'advtuity','','192.168'


--Delete
alter proc [dbo].[del_t_adv](@com_id char(2),@br_id char(3),@adv_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mvch_id char(12),
@adv_dat datetime,
@aud_act			char(20)
begin
	set @aud_act='Delete'
	set @mvch_id=(select mvch_id from t_adv where adv_id=@adv_id)
	set @adv_dat=(select adv_dat from t_adv where adv_id=@adv_id)
	--GL
	exec del_t_vch @com_id ,@br_id ,@mvch_id,@adv_dat,'01',@m_yr_id,''
	--Delete Record
	delete from t_adv  
			where adv_id=@adv_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from t_adv
