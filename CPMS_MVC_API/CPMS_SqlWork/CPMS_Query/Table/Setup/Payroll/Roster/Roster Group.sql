
USE MFI
GO

--alter table m_rosgp add rosgp_lat float
--alter table m_rosgp add rosgp_ear float
--alter table m_rosgp drop column rosgp_lat 
--alter table m_rosgp drop column rosgp_ear

--drop table m_rosgp
create table m_rosgp
(
rosgp_sno int identity(1001,1),
rosgp_id int,
rosgp_nam varchar(100),
rosgp_in datetime,
rosgp_out datetime,
rosgp_lat float,
rosgp_ear float,
rosgp_ota float,
rosgp_wh float, --Working Hours
rosgp_typ char(1),
)


--Constraint 
--Not Null
alter table m_rosgp alter column rosgp_id int not null

--Primary key
alter table m_rosgp add constraint PK_MROSGP_ROSGPID primary key (rosgp_id)
