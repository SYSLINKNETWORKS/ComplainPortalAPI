
USE ZSONS
GO


--drop table m_rosemp
create table m_rosemp
(
rosemp_sno int identity(1001,1),
rosemp_id int,
rosemp_dat datetime,
rosemp_typ char(1),
ros_id int,
emppro_id int
)


--Constraint 
--Not Null
alter table m_rosemp alter column rosemp_id int not null

--Primary key
alter table m_rosemp add constraint PK_Mrosemp_rosempID primary key (rosemp_id)


--Foreign key
alter table m_rosemp add constraint FK_MEMPOS_ROSID foreign key (ros_id) references m_ros(ros_id)
alter table m_rosemp add constraint FK_MEMPOS_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)