USE [MFI]
GO

--Update
ALTER proc [dbo].[upd_t_nithrs](@com_id char(2),@br_id char(3),@m_yr_id char(2),@nithrs_dat datetime,@nithrs_app bit,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Update'

	update m_nithrs set nithrs_app=@nithrs_app where nithrs_dat=@nithrs_dat
	update checkinout set check_night=@nithrs_app where userid in (select userid from v_nithrs where nithrs_dat=@nithrs_dat) and checktime in (select nightinn from v_nithrs where userid=checkinout.userid and nithrs_dat=@nithrs_dat)
	update checkinout set check_night=@nithrs_app where userid in (select userid from v_nithrs where nithrs_dat=@nithrs_dat) and checktime in(select nightout from v_nithrs where userid=checkinout.userid and nithrs_dat=@nithrs_dat)
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

GO


