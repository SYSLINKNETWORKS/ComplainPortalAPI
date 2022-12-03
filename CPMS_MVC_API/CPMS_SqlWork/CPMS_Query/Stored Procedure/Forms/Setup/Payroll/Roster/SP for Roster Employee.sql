
USE ZSONS
GO

--Insert
alter proc [dbo].[ins_m_rosemp](@com_id char(2),@br_id char(3),@rosemp_dat datetime,@rosemp_typ char(1),@ros_id int,@emppro_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@rosemp_id_out int output)
as
declare
@rosemp_id			int,
@aud_act			char(20)
begin
	set @rosemp_id =(select max(rosemp_id) from m_rosemp)+1

	set @aud_act='Insert'

	if (@rosemp_id is null)
		begin	
			set @rosemp_id=1
		end

	insert into m_rosemp (rosemp_id,rosemp_dat,rosemp_typ,ros_id,emppro_id)
	values (@rosemp_id,@rosemp_dat,@rosemp_typ,@ros_id,@emppro_id)

	set @rosemp_id_out=@rosemp_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO
--Update
alter proc [dbo].[upd_m_rosemp](@com_id char(2),@br_id char(3),@rosemp_id int,@rosemp_dat datetime,@rosemp_typ char(1),@ros_id int,@emppro_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Update'	
	
	update m_rosemp set rosemp_dat=@rosemp_dat,ros_id=@ros_id,emppro_id=@emppro_id where rosemp_id=@rosemp_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Delete
alter proc [dbo].[del_m_rosemp](@com_id char(2),@br_id char(3),@rosemp_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_rosemp  
			where rosemp_id=@rosemp_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from m_rosemp
