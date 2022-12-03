USE ZSONS
GO
--alter table m_rosgp add rosgp_ck_da char(1)
--alter table m_rosgp add rosgp_ck_eve char(1)
--alter table m_rosgp add rosgp_ck_nig char(1)

--alter table m_rosgp add rosgp_ck_mon bit
--alter table m_rosgp add rosgp_ck_tue bit
--alter table m_rosgp add rosgp_ck_wed bit
--alter table m_rosgp add rosgp_ck_thu bit
--alter table m_rosgp add rosgp_ck_fri bit
--alter table m_rosgp add rosgp_ck_sat bit
--alter table m_rosgp add rosgp_ck_sun bit

--alter table m_rosgp add rosgp_in_mon datetime
--alter table m_rosgp add rosgp_out_mon datetime
--alter table m_rosgp add rosgp_mon_wh as DATEDIFF(hh,rosgp_in_mon,rosgp_out_mon)

--alter table m_rosgp add rosgp_in_tue datetime
--alter table m_rosgp add rosgp_out_tue datetime
--alter table m_rosgp add rosgp_tue_wh as DATEDIFF(hh,rosgp_in_tue,rosgp_out_tue)

--alter table m_rosgp add rosgp_in_wed datetime
--alter table m_rosgp add rosgp_out_wed datetime
--alter table m_rosgp add rosgp_wed_wh as DATEDIFF(hh,rosgp_in_wed,rosgp_out_wed)

--alter table m_rosgp add rosgp_in_thu datetime
--alter table m_rosgp add rosgp_out_thu datetime
--alter table m_rosgp add rosgp_thu_wh as DATEDIFF(hh,rosgp_in_thu,rosgp_out_thu)

--alter table m_rosgp add rosgp_in_fri datetime
--alter table m_rosgp add rosgp_out_fri datetime
--alter table m_rosgp add rosgp_fri_wh as DATEDIFF(hh,rosgp_in_fri,rosgp_out_fri)

--alter table m_rosgp add rosgp_in_sat datetime
--alter table m_rosgp add rosgp_out_sat datetime
--alter table m_rosgp add rosgp_sat_wh as DATEDIFF(hh,rosgp_in_sat,rosgp_out_sat)

--alter table m_rosgp add rosgp_in_sun datetime
--alter table m_rosgp add rosgp_out_sun datetime
--alter table m_rosgp add rosgp_sun_wh as DATEDIFF(hh,rosgp_in_sun,rosgp_out_sun)

--alter table m_rosgp drop column rosgp_in
--alter table m_rosgp drop column rosgp_out

--alter table m_rosgp add rosgp_dat datetime
--alter table m_rosgp add ros_id int
--alter table m_rosgp add constraint FK_MROSGP_ROSID foreign key (ros_id) references m_ros(ros_id)



--alter table m_rosgp add rosgp_ota int

--Insert
alter proc [dbo].[ins_m_rosgp](@com_id char(2),@br_id char(3),@rosgp_dat datetime,@ros_id int,@rosgp_lat int,@rosgp_ear int,@rosgp_ota int,@rosgp_wh float,@rosgp_typ char(1),
@rosgp_ck_mon bit,@rosgp_ck_tue bit,@rosgp_ck_wed bit,@rosgp_ck_thu bit,@rosgp_ck_fri bit,@rosgp_ck_sat bit,@rosgp_ck_sun bit,@rosgp_in_mon datetime,@rosgp_out_mon datetime,@rosgp_in_tue datetime,@rosgp_out_tue datetime,@rosgp_in_wed datetime,@rosgp_out_wed datetime,@rosgp_in_thu datetime,@rosgp_out_thu datetime,@rosgp_in_fri datetime,@rosgp_out_fri datetime,@rosgp_in_sat datetime,@rosgp_out_sat datetime,@rosgp_in_sun datetime,@rosgp_out_sun datetime,@aud_ip varchar(100),
@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@rosgp_id_out int output)
as
declare
@rosgp_id			int,
@aud_act			char(20)
begin
	set @rosgp_id =(select max(rosgp_id) from m_rosgp)+1
	
	
	set @aud_act='Insert'

	if (@rosgp_id is null)
		begin	
			set @rosgp_id=1
		end

	insert into m_rosgp (rosgp_id,rosgp_dat,ros_id,rosgp_lat,rosgp_ear,rosgp_ota,rosgp_wh ,rosgp_typ,rosgp_ck_mon,rosgp_ck_tue,rosgp_ck_wed,rosgp_ck_thu,rosgp_ck_fri,rosgp_ck_sat,rosgp_ck_sun,rosgp_in_mon ,rosgp_out_mon ,rosgp_in_tue ,rosgp_out_tue ,rosgp_in_wed ,rosgp_out_wed ,rosgp_in_thu ,rosgp_out_thu ,rosgp_in_fri ,rosgp_out_fri ,rosgp_in_sat ,rosgp_out_sat ,rosgp_in_sun ,rosgp_out_sun)
	values
	(@rosgp_id,@rosgp_dat,@ros_id,@rosgp_lat,@rosgp_ear,@rosgp_ota,@rosgp_wh ,@rosgp_typ,@rosgp_ck_mon,@rosgp_ck_tue,@rosgp_ck_wed,@rosgp_ck_thu,@rosgp_ck_fri,@rosgp_ck_sat,@rosgp_ck_sun,@rosgp_in_mon ,@rosgp_out_mon ,@rosgp_in_tue ,@rosgp_out_tue ,@rosgp_in_wed ,@rosgp_out_wed ,@rosgp_in_thu,@rosgp_out_thu ,@rosgp_in_fri ,@rosgp_out_fri ,@rosgp_in_sat ,@rosgp_out_sat ,@rosgp_in_sun ,@rosgp_out_sun )

	set @rosgp_id_out=@rosgp_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_m_rosgp](@com_id char(2),@br_id char(3),@rosgp_id int,@rosgp_dat datetime,@ros_id int,@rosgp_lat int,@rosgp_ear int,@rosgp_ota int,@rosgp_wh float,@rosgp_typ char(1),
@rosgp_ck_mon bit,@rosgp_ck_tue bit,@rosgp_ck_wed bit,@rosgp_ck_thu bit,@rosgp_ck_fri bit,@rosgp_ck_sat bit,@rosgp_ck_sun bit,@rosgp_in_mon datetime,@rosgp_out_mon datetime,@rosgp_in_tue datetime,@rosgp_out_tue datetime,@rosgp_in_wed datetime,@rosgp_out_wed datetime,@rosgp_in_thu datetime,@rosgp_out_thu datetime,@rosgp_in_fri datetime,@rosgp_out_fri datetime,@rosgp_in_sat datetime,@rosgp_out_sat datetime,@rosgp_in_sun datetime,@rosgp_out_sun datetime,
@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	

	update m_rosgp 
			set rosgp_dat=@rosgp_dat,ros_id=@ros_id,rosgp_lat=@rosgp_lat,rosgp_ear=@rosgp_ear,rosgp_ota=@rosgp_ota,rosgp_wh=@rosgp_wh,rosgp_typ=@rosgp_typ,rosgp_ck_mon=@rosgp_ck_mon,rosgp_ck_tue=@rosgp_ck_tue,rosgp_ck_wed=@rosgp_ck_wed,rosgp_ck_thu=@rosgp_ck_thu,rosgp_ck_fri=@rosgp_ck_fri,rosgp_ck_sat=@rosgp_ck_sat,rosgp_ck_sun=@rosgp_ck_sun,
			rosgp_in_mon=@rosgp_in_mon ,rosgp_out_mon=@rosgp_out_mon ,rosgp_in_tue=@rosgp_in_tue ,rosgp_out_tue=@rosgp_out_tue ,rosgp_in_wed=@rosgp_in_wed,rosgp_out_wed=@rosgp_out_wed ,rosgp_in_thu=@rosgp_in_thu ,rosgp_out_thu=@rosgp_out_thu ,rosgp_in_fri=@rosgp_in_fri ,rosgp_out_fri=@rosgp_out_fri ,rosgp_in_sat=@rosgp_in_sat ,rosgp_out_sat=@rosgp_out_sat ,rosgp_in_sun=@rosgp_in_sun ,rosgp_out_sun=@rosgp_out_sun
			
			where rosgp_id=@rosgp_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--exec [upd_m_rosgp] "1",'07/01/2010','06/30/2011',1,2,14,100,'U','01','01','03',1,'rosgptuity','','192.168'

--Delete
alter proc [dbo].[del_m_rosgp](@com_id char(2),@br_id char(3),@rosgp_id int,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_rosgp  
			where rosgp_id=@rosgp_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from m_rosgp
