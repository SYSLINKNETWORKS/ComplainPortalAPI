
USE ZSONS
GO


--drop table m_ros
create table m_ros
(
ros_sno int identity(1001,1),
ros_id int,
ros_nam varchar(100),
ros_typ char(1)
)


--Constraint 
--Not Null
alter table m_ros alter column ros_id int not null

--Primary key
alter table m_ros add constraint PK_Mros_rosID primary key (ros_id)
