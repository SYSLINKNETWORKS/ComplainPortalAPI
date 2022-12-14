USE zsons 
GO
alter proc [dbo].[sel_m_log](@usr_nam varchar(100),@usr_pwd varchar(50),@usr_ckbr bit output,@com_id char(2) output,@com_nam varchar(100) output,@br_id char(3) output,@br_nam varchar(100) output,@usr_id char(2) output,@ret_rec1 char(1) output,@per_dt1 datetime output,@per_dt2 datetime output,@srv_dat datetime output)
as
begin
--Company ID
set @usr_id=	(select usr_id from new_usr where usr_nam=@usr_nam and usr_pwd=@usr_pwd)
set @com_id=	(select m_com.com_id from new_usr inner join m_br	on new_usr.br_id=m_br.br_id	inner join m_com on m_br.com_id=m_com.com_id	where usr_nam = @usr_nam and usr_pwd = @usr_pwd )
set @com_nam=	(select m_com.com_nam from new_usr inner join m_br	on new_usr.br_id=m_br.br_id	inner join m_com on m_br.com_id=m_com.com_id	where usr_nam = @usr_nam and usr_pwd = @usr_pwd )
set @br_id=		(select br_id from new_usr	where usr_nam = @usr_nam and usr_pwd = @usr_pwd )
set @br_nam=	(select br_nam from new_usr	inner join m_br	on new_usr.br_id=m_br.br_id	where usr_nam = @usr_nam and usr_pwd = @usr_pwd )
set @ret_rec1=	(select ret_rec1 from m_sys)
set @per_dt1=	(select max( per_dt1) from m_per where usr_id=@usr_id)
set @per_dt2=	(select max (per_dt2) from m_per where usr_id=@usr_id)
set @srv_dat=	getdate()
set @usr_ckbr=	(select usr_ckbr from new_usr where usr_id=@usr_id)
end
GO

alter proc [dbo].[sel_m_cuslog](@cus_nam varchar(100),@cus_pwd varchar(50),@com_id char(2) output,@com_nam varchar(100) output,@br_id char(3) output,@br_nam varchar(100) output,@cus_id int output,@ret_rec1 char(1) output,@per_dt1 datetime output,@per_dt2 datetime output,@srv_dat datetime output)
as
begin
----Company ID
set @cus_id=	(select cus_id from m_cus where cus_usrid=@cus_nam and cus_pwd=@cus_pwd and cus_ckweb=1)
set @com_id=	(select com_id from m_cus where cus_id=@cus_id and cus_ckweb=1 )
set @com_nam=	(select com_nam from m_com where com_id=@com_id  )
set @br_id=		(select br_id from m_cus	where cus_id=@cus_id and cus_ckweb=1 )
set @br_nam=	(select br_nam from m_br where br_id=@br_id )
set @ret_rec1=	(select ret_rec1 from m_sys)
set @per_dt1=	GETDATE()
set @per_dt2=	GETdate()
set @srv_dat=	getdate()
end
--select * from m_cus

--select distinct per_dt2 from m_per where usr_id=1
--select * from m_com
--select * from new_sr
--exec sel_m_log 'asattar','57-30-61-E4-8B-7A-3D-18-8A-26-F3-30-19-FA-A6-E7-0D','','','','','','','',''
--select * from new_usr where usr_nam='a' and usr_pwd='86-F7-E4-37-FA-A5-A7-FC-E1-5D-1D-DC-B9-EA-EA-EA-37'
--Login the User
--select * from m_cus where cus_usrid='t' and cus_pwd='8E-FD-86-FB-78-A5-6A-51-45-ED-77-39-DC-B0-0C-78-58'
--sp_help m_cus

--update m_cus set cus_pwd=''
--alter table m_cus alter column cus_pwd varchar(50) null
