USE phm
GO

--drop table m_reg

create table m_reg
(
reg_sno int identity(1001,1),
reg_id int,
reg_nam varchar(250),
reg_typ char(1),
zone_id int,
log_act char(1),
log_dat datetime,
usr_id int,
log_ip varchar(100)
)

--Constraint 
--Not Null
alter table m_reg alter column reg_id int not null

--Primary Key
alter table m_reg add constraint PK_mreg_regID primary key (reg_id)

--Foriegn Key
alter table m_reg add constraint FK_MREG_ZONEID foreign key (zone_id) references m_zone(zone_id)
