USE phm
GO

--drop table m_ind
--select * from m_ind

create table m_ind
(
ind_sno int identity (1001,1),
ind_id int,
ind_nam varchar(100),
ind_add varchar(250),
ind_pho varchar(100),
ind_mob varchar(100),
ind_fax varchar(100),
ind_eml varchar(100),
ind_web varchar(100),
ind_act bit,
ind_typ char(1),
mak_action char(1),
mak_id int,
mak_dat datetime,
)


--Constrants
--Not Null
alter table m_ind alter column ind_id int not null

--Primary Key
alter table m_ind add constraint PK_Mind_indID primary key (ind_id)

--Unique
--alter table m_ind add constraint UQ_Mind_indNAM Unique (ind_nam)


