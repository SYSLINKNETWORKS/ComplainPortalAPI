
USE ZSONS
GO
--create table m_ros add ros_ota int

--Insert
create proc [dbo].[ins_m_ros](@com_id char(2),@br_id char(3),@ros_nam varchar(100),@ros_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100),@ros_id_out int output)
as
declare
@ros_id			int,
@aud_act			char(20)
begin
	set @ros_id =(select max(ros_id) from m_ros)+1

	set @aud_act='Insert'

	if (@ros_id is null)
		begin	
			set @ros_id=1
		end

	insert into m_ros (ros_id,ros_nam,ros_typ)
	values (@ros_id,@ros_nam,@ros_typ)

	set @ros_id_out=@ros_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
create proc [dbo].[upd_m_ros](@com_id char(2),@br_id char(3),@ros_id int,@ros_nam varchar(100),@ros_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'

	update m_ros 
			set ros_nam=@ros_nam ,ros_typ=@ros_typ
			where ros_id=@ros_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--Delete
create proc [dbo].[del_m_ros](@com_id char(2),@br_id char(3),@ros_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_ros  
			where ros_id=@ros_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from m_ros
