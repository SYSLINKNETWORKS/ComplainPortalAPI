USE zsons
GO



--alter table m_sms add sms_st bit
--alter table m_sms add sms_rmk varchar(250)
--alter table m_sms add sms_sdat datetime

--select * from m_sms

--alter table m_sys add sms_port int
--update m_sys set sms_port=12
--alter table m_sms add sms_action varchar(250)
--alter table m_sms add men_id int
--update m_sms set men_id=(select men_id from m_men where men_nam=sms_frmnam)
--alter table m_sms add sms_dat1 as cast(CONVERT(VARCHAR(10), sms_dat, 101) as datetime)
--alter table m_sms add sms_sdat1 as cast(CONVERT(VARCHAR(10), sms_sdat, 101) as datetime)

--alter table m_sms add sms_cat varchar(100)
--update m_sms set sms_cat='mobile'
---Insert
alter proc [dbo].[ins_m_sms](@com_id char(2),@br_id char(2),@sms_txt varchar(1000),@sms_typ char(1),@sms_cus varchar (250),@sms_mob varchar(1000),@sms_min int,@sms_st bit,@sms_action varchar(250),@sms_id_out int output,@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_ip varchar(100))
as
declare
@sms_id	int,
@aud_act char(20),
@sms_dat datetime,
@men_id int
begin
	set @sms_dat=DATEADD(MINUTE,@sms_min,getdate())
	set @sms_id =(select max(sms_id) from m_sms)+1
	set @men_id=(select men_id from m_men where men_nam=@aud_frmnam)
	set @aud_act='Insert'

	if (@sms_id is null)
		begin	
			set @sms_id=1
		end

	insert into m_sms(sms_id,sms_dat,sms_txt,com_id,br_id,sms_typ,sms_mob,sms_min,sms_cus,sms_st,sms_action,men_id)
	values
	(@sms_id,@sms_dat,@sms_txt,@com_id,@br_id,@sms_typ,@sms_mob,@sms_min,@sms_cus,@sms_st,@sms_action,@men_id)

	set @sms_id_out=@sms_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--update
alter proc [dbo].[upd_m_sms](@com_id char(2),@br_id char(2),@sms_id int,@sms_act bit,@sms_rmk varchar(250),@sms_cat varchar(100),@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_ip varchar(100))
as
declare 
@aud_act char(20)
begin
set @aud_act='Update'

update m_sms
			set sms_sdat=getdate(),sms_act =@sms_act,sms_rmk=@sms_rmk,sms_cat=@sms_cat 
			where sms_id=@sms_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--update SMS Approval
alter proc [dbo].[upd_m_sms_app](@com_id char(2),@br_id char(2),@sms_id int,@sms_st bit,@aud_frmnam varchar(1024),@aud_des varchar(1024),@usr_id int,@aud_ip varchar(100))
as
declare 
@aud_act char(20)
begin
set @aud_act='Update'

update m_sms
			set sms_st =@sms_st
			where sms_id=@sms_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter proc [dbo].[del_m_sms](@com_id char(2),@br_id char(2),@sms_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_sms  
			where sms_id=@sms_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from t_emp_so
