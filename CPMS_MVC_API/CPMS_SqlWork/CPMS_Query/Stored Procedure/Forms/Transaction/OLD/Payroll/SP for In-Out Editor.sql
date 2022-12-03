USE ZSONS
GO

--ALTER table checkinout add checkdate as cast(convert(varchar, checktime, 101) +' 00:00:00' as datetime)

--Insert
alter proc [dbo].[ins_t_inoutedit](@userid int,@checktime datetime,@checktype char,@empatt_typ char,@inoutcat_id int,@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@empatt_id_out int output)
as
declare
@empatt_id int,
@emppro_macid int,
@aud_act char(20)
begin
	set @aud_act='Insert'
	set @emppro_macid=(select emppro_userid from m_emppro where emppro_macid=@userid)

	if (@empatt_id is null)
		begin	
			set @empatt_id=1
		end

	insert into checkinout (userid,checktime,checktype,ckinout_st,check_typ,inoutcat_id,check_app)
	values
	(@emppro_macid,@checktime,@checktype,1,@empatt_typ,@inoutcat_id,0)

	set @empatt_id_out=@empatt_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


-- exec del_t_inoutedit '01','01','02/27/2013',4,'01',1,'','',''
--Delete
alter proc [dbo].[del_t_inoutedit](@com_id char(2),@br_id char(3),@empatt_dat datetime,@userid int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from checkinout where cast(convert(varchar, checktime, 101) +' 00:00:00' as datetime)=@empatt_dat and userid=@userid and check_typ='U' and check_app=0
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select cast(convert(varchar, checktime, 101) +' 00:00:00' as datetime)  from checkinout where  userid=4 and check_typ='U'

