use MEIJI
go

create table m_drv
(
drv_sno     int identity(1001,1),
drv_id		int,
drv_nam		varchar(100),
drv_typ		char(1),
drv_act		bit
) 
----Constraints
--Not Null
alter table m_drv alter column drv_id int not null

--Primary Key
alter table m_drv add constraint PK_Mdrv_drvID primary key (drv_id)