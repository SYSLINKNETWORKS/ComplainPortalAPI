USE MFI
GO
--Insert
alter proc [dbo].[ins_t_nithrs](@com_id char(2),@br_id char(3),@m_yr_id char(2),@nithrs_dat datetime,@nithrs_hrs float,@emppro_macid int,@nithrs_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@nithrs_id			int,
@emppro_id			int,
@aud_act			char(20)
begin
	set @aud_act='Insert'
	set @emppro_id =(select emppro_id from m_emppro where emppro_macid=@emppro_macid)

	set @nithrs_id=(select MAX(nithrs_id)+1 from m_nithrs)
		if (@nithrs_id is null)
			begin
				set @nithrs_id=1
			end
	insert into m_nithrs(nithrs_id,nithrs_dat,emppro_id,nithrs_hrs,nithrs_typ)
			values(@nithrs_id,@nithrs_dat,@emppro_id,@nithrs_hrs,@nithrs_typ)

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
create proc [dbo].[upd_t_nithrs](@com_id char(2),@br_id char(3),@m_yr_id char(2),@nithrs_dat datetime,@nithrs_app bit,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Update'

	update m_nithrs set nithrs_app=@nithrs_app where nithrs_dat=@nithrs_dat
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Delete
create proc [dbo].[del_t_nithrs](@com_id char(2),@br_id char(3),@m_yr_id char(2),@nithrs_dat datetime,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_nithrs where nithrs_dat=@nithrs_dat
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO
