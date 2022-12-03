USE ZSons
GO

--drop table m_dsalzon
--drop table m_msalzon 


create table m_msalzon
(
msalzon_sno int identity(1001,1),
msalzon_id int,
msalzon_dat datetime,
msalzon_act bit,
msalzon_typ char(1),
emppro_id int
)

--Constraint 
--Not Null
alter table m_msalzon alter column msalzon_id int not null

--Primary Key
alter table m_msalzon add constraint PK_msalzon_msalzonID primary key (msalzon_id)

--Foreign key
alter table m_msalzon add constraint FK_Mzone_empproID foreign key (emppro_id) references m_emppro (emppro_id)


create table m_dsalzon
(
dsalzon_sno int identity(1001,1),
dsalzon_id int,
msalzon_id int,
zone_id int
)

--Constraint 
--Not Null
alter table m_dsalzon alter column dsalzon_id int not null

--Primary Key
alter table m_dsalzon add constraint PK_dsalzon_dsalzonID primary key (dsalzon_id)

--Foreign key
alter table m_dsalzon add constraint FK_DSALZON_MSALZONID foreign key (msalzon_id) references m_msalzon (msalzon_id)
alter table m_dsalzon drop constraint FK_DSALZON_ZONEID foreign key (zone_id) references m_zone (zone_id)

