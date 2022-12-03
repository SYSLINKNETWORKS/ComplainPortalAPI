USE MFI
GO

--alter table m_sal add msal_per float
--update m_sal set msal_per=0


--Insert
alter  proc [dbo].[ins_m_sal](@msal_dat datetime,@emppro_id int,@msal_pamt float,@msal_per float,@msal_val float,@msal_amt float,@msal_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@msal_id_out int output)
as
declare
@msal_id			int,
@aud_act			char(20)
begin
	set @msal_id =(select max(msal_id) from m_sal)+1
	set @aud_act='Insert'

	if (@msal_id is null)
		begin	
			set @msal_id=1
		end

	insert into m_sal (msal_id,msal_dat,msal_pamt,msal_per,msal_val,msal_amt,emppro_id,msal_typ)
	values	(@msal_id,@msal_dat,@msal_pamt,@msal_per,@msal_val,@msal_amt,@emppro_id,@msal_typ)

	set @msal_id_out=@msal_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_m_sal](@msal_id int,@msal_dat datetime,@msal_pamt float,@msal_per float,@msal_val float,@msal_amt float,@emppro_id int,@msal_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_sal 
			set msal_dat=@msal_dat,msal_pamt=@msal_pamt,msal_per=@msal_per,msal_val=@msal_val,msal_amt=@msal_amt ,emppro_id=@emppro_id,msal_typ=@msal_typ
			where msal_id=@msal_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--exec [upd_m_sal] "1",'07/01/2010','06/30/2011',1,2,14,100,'U','01','01','03',1,'saltuity','','192.168'

--Delete
alter  proc [dbo].[del_m_sal](@com_id char(2),@br_id char(3),@msal_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_sal  
			where msal_id=@msal_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from m_sal
