USE MFI
GO
--select * from CHECKINOUT where check_typ ='U' and userid=1


--	update CHECKINOUT set check_app=1 where cast(convert(varchar, checktime, 101) +' 00:00:00' as datetime) ='04/01/2013' and check_typ='U'

--Insert
alter proc [dbo].[ins_t_inoutapp](@com_id char(2),@br_id char(3),@m_yr_id char(2),@inout_dat datetime,@inout_app bit,@inout_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mabs_id			int,
@aud_act			char(20)
begin
	set @aud_act='Insert'


	update CHECKINOUT set check_app=@inout_app where cast(convert(varchar, checktime, 101) +' 00:00:00' as datetime) =@inout_dat and check_typ='U'


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

