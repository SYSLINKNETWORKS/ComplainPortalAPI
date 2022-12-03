USE phm
GO

--drop table m_zone
--sp_help m_zone

--alter table m_cus drop constraint FK_MCUS_ZONEID
--alter table m_zone drop constraint FK_Mzone_cityID
--alter table m_dsalzon drop constraint FK_DSALZON_ZONEID
--alter table m_reg drop constraint FK_MREG_ZONEID
--ALTER table m_cus drop constraint FK_MCUS_ZONEID
--select * from m_zone 
--alter table m_zone drop column city_id 
--alter table m_zone add coun_id int
--alter table m_zone add constraint FK_MZONE_COUNID foreign key (coun_id) references m_coun(coun_id)


--delete from m_zone
create table m_zone
(
zone_sno int identity(1001,1),
zone_id int,
zone_nam varchar(250),
coun_id int,
zone_typ char(1)
)

--Constraint 
--Not Null
alter table m_zone alter column zone_id int not null

--Primary Key
alter table m_zone add constraint PK_mzone_zoneID primary key (zone_id)

--Foriegn Key
alter table m_zone add constraint FK_mZONE_COUNID foreign key (coun_id) references m_coun(coun_id)
