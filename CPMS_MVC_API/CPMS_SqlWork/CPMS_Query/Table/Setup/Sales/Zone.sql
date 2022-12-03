USE ZSons
GO


create table m_zone
(
zone_sno int identity(1001,1),
zone_id int,
zone_nam varchar(250),
zone_act bit,
zone_typ char(1)
)

--Constraint 
--Not Null
alter table m_zone alter column zone_id int not null

--Primary Key
alter table m_zone add constraint PK_zone_zoneID primary key (zone_id)

