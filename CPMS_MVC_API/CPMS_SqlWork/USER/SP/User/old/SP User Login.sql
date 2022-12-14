USE CHSS
GO

alter proc [dbo].[sel_m_log](@usr_nam varchar(100),@usr_pwd varchar(50),@aud_ip varchar(250),@com_id int output,@com_nam varchar(100) output,@br_id int output,@br_nam varchar(100) output,@usr_id int output,@usr_no int output,@ret_rec1 char(1) output,@per_dt1 datetime output,@per_dt2 datetime output)
as
declare
@aud_act char(20),
@aud_frmnam varchar(1024),
@aud_des varchar(1024)
begin
	set @aud_act=	'Login'
	set @aud_frmnam='LoginForm'
	set @usr_id=	(select usr_id from new_usr where usr_nam=@usr_nam and usr_pwd=@usr_pwd)
	set @usr_no=	(select usr_no from new_usr where usr_id=@usr_id)
	set @com_id=	(select com_id from new_usr where usr_id=@usr_id )
	set @com_nam=	(select com_nam from m_com	where com_id=@com_id )
	set @br_id=		(select br_id from new_usr where usr_id=@usr_id )
	set @br_nam=	(select br_nam from m_br where br_id=@br_id )
	set @ret_rec1=	(select ret_rec1 from m_sys)
	set @per_dt1=	(select max( per_dt1) from m_per where usr_id=@usr_id)
	set @per_dt2=	(select max (per_dt2) from m_per where usr_id=@usr_id)

	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO
--select distinct per_dt2 from m_per where usr_id=1
--select * from m_com
--select * from new_sr
--exec sel_m_log 'asattar','57-30-61-E4-8B-7A-3D-18-8A-26-F3-30-19-FA-A6-E7-0D','','','','','','','',''
--select * from new_usr where usr_nam='a' and usr_pwd='86-F7-E4-37-FA-A5-A7-FC-E1-5D-1D-DC-B9-EA-EA-EA-37'
--Login the User
--select * from m_per