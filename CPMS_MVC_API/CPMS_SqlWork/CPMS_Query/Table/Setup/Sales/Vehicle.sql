use MEIJI
go

create table m_veh
(
veh_sno     int identity(1001,1),
veh_id		int,
veh_nam		varchar(100),
veh_typ		char(1),
veh_act		bit
) 
----Constraints
--Not Null
alter table m_veh alter column veh_id int not null

--Primary Key
alter table m_veh add constraint PK_Mveh_vehID primary key (veh_id)