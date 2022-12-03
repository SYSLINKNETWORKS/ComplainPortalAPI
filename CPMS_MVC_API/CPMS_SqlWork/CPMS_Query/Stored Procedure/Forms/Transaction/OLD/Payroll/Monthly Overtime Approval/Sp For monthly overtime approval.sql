USE phm
GO



--Insert
create proc [dbo].[ins_t_otemp_app](@com_id char(2),@br_id char(3),@m_yr_id char(3),@otemp_dat datetime,@otemp_app bit,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Update'

update t_otemp set otemp_app=@otemp_app where otemp_dat=@otemp_dat

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

