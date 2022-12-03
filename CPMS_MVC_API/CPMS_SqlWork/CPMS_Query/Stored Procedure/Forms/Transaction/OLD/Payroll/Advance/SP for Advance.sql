USE MEIJI_RUSK
GO

--alter table t_adv add acc_id char(20),mvch_typ char(2),adv_chq int,adv_cb char(1)
--update t_adv set mvch_cb='C',acc_id='03002003002003'
--alter table t_adv drop column dcus_id,drv_id
--alter table t_adv drop column mvch_id



--alter table t_adv add acc_no int
--alter table t_adv add mvch_no int

--alter table t_adv add com_id char(2),br_id char(3),m_yr_id char(2)



--Insert
alter proc [dbo].[ins_t_adv](@com_id char(2),@br_id char(3),@m_yr_id char(2),@adv_dat datetime,@adv_amt float,@emppro_id char(3),@acc_id char(20),@mvch_typ char(2),@adv_chq int,@adv_cb char(1),@adv_typ char(1),@adv_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@adv_id			int,
@aud_act char(20),
@mvch_chq_old int,
@acc_no int
begin
	
	set @acc_no=(select acc_no from gl_m_acc where acc_id=@acc_id)
	set @aud_act='Insert'

	set @adv_id =(select max(adv_id) from t_adv)+1
	if (@adv_id is null)
		begin	
			set @adv_id=1
		end
	insert into t_adv (com_id,br_id,m_yr_id,adv_id,adv_dat,adv_amt,emppro_id,acc_no,adv_chq,adv_cb,adv_typ)
	values	(@com_id,@br_id,@m_yr_id,@adv_id,@adv_dat,@adv_amt,@emppro_id,@acc_no,@adv_chq,@adv_cb,@adv_typ)

	set @adv_id_out=@adv_id

	---GL 
	exec sp_voucher_adv @adv_id

	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
--exec upd_t_adv 1,'06/14/2011',1000,1,'S','01','01','03',1,'Employee Advance','',''
--select * from t_adv

alter proc [dbo].[upd_t_adv](@com_id char(2),@br_id char(3),@m_yr_id char(3),@adv_id int,@adv_dat datetime,@adv_amt float,@emppro_id int,@acc_id char(20),@mvch_typ char(2),@adv_chq int,@adv_cb char(1),@adv_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20),
@acc_no int

begin
	set @aud_act='Update'
	set @acc_no=(select acc_no from gl_m_acc where acc_id=@acc_id)

	update t_adv 
			set adv_dat=@adv_dat,adv_amt=@adv_amt ,adv_typ=@adv_typ, emppro_id=emppro_id,acc_no=@acc_no,adv_chq=@adv_chq,adv_cb=@adv_cb
			where adv_id=@adv_id 

	--GL
	exec sp_voucher_adv @adv_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--exec [upd_t_adv] "1",'07/01/2010','06/30/2011',1,2,14,100,'U','01','01','03',1,'advtuity','','192.168'


--Delete
alter proc [dbo].[del_t_adv](@com_id char(2),@br_id char(3),@adv_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mvch_no int,
@aud_act			char(20)
begin
	set @aud_act='Delete'
	set @mvch_no=(select mvch_no from t_adv where adv_id=@adv_id)

	--GL
	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no ,'','','',''
	--Delete Record
	delete from t_adv  
			where adv_id=@adv_id

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from t_adv
