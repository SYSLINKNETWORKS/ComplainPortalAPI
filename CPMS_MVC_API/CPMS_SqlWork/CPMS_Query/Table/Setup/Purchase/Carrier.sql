USE phm
GO

--drop table m_carr
--select * from m_carr

create table m_carr
(
carr_sno int identity (1001,1),
carr_id int,
carr_nam varchar(100),
carr_add varchar(250),
carr_pho varchar(100),
carr_mob varchar(100),
carr_fax varchar(100),
carr_eml varchar(100),
carr_web varchar(100),
carr_act bit,
carr_typ char(1),
mak_action char(1),
mak_id int,
mak_dat datetime,
)


--Constrants
--Not Null
alter table m_carr alter column carr_id int not null

--Primary Key
alter table m_carr add constraint PK_Mcarr_carrID primary key (carr_id)

--Unique
--alter table m_carr add constraint UQ_Mcarr_carrNAM Unique (carr_nam)


