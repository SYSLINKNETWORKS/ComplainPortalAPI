USE MFI
GO
--drop table m_mbat
--drop table m_dbat

--Item Brand
create table m_mbat
(
mbat_sno int identity(1001,1),
mbat_id	int,
mbat_dat datetime,
mbat_siz float,
mbat_nam varchar(250),
mbat_act bit,
mbat_typ char(1),
cus_id int,
ck_cus bit
)

--Constraint
--Not Null
alter table m_mbat alter column mbat_id int not null

--Primary Key
alter table m_mbat add constraint PK_Mmbat_mbatID primary key (mbat_id)

--Foreign Key
alter table m_mbat add constraint FK_Mmbat_cus_ID foreign key (cus_id) references m_cus(cus_id)



create table m_dbat
(
dbat_sno int identity(1001,1),
dbat_id	int,
dbat_qty float,
titm_id int,
mbat_id int
)

--Constraint
--Not Null
alter table m_dbat alter column dbat_id int not null

--Primary Key
alter table m_dbat add constraint PK_Mdbat_dbatID primary key(dbat_id)

--Foreign Key
alter table m_dbat add constraint FK_Mdbat_mbatID foreign key (mbat_id) references m_mbat(mbat_id)
alter table m_dbat add constraint FK_Mdbat_titmID foreign key (titm_id) references t_itm(titm_id)





create table m_dbat_fg
(
dbat_fg_sno int identity(1001,1),
dbat_fg_id	int,
titm_id int,
mbat_id int
)

--Constraint
--Not Null
alter table m_dbat_fg alter column dbat_fg_id int not null

--Primary Key
alter table m_dbat_fg add constraint PK_Mdbatfg_dbatfgID primary key(dbat_fg_id)

--Foreign Key
alter table m_dbat_fg add constraint FK_Mdbatfg_mbatID foreign key (mbat_id) references m_mbat(mbat_id)
alter table m_dbat_fg add constraint FK_Mdbatfg_titmID foreign key (titm_id) references t_itm(titm_id)



create table m_dbat_bd
(
dbat_bd_sno int identity(1001,1),
dbat_bd_id	int,
bd_id int,
mbat_id int
)

--Constraint
--Not Null
alter table m_dbat_bd alter column dbat_bd_id int not null

--Primary Key
alter table m_dbat_bd add constraint PK_Mdbatbd_dbatbdID primary key(dbat_bd_id)

--Foreign Key
alter table m_dbat_bd add constraint FK_Mdbatbd_mbatID foreign key (mbat_id) references m_mbat(mbat_id)
alter table m_dbat_bd add constraint FK_Mdbatbd_bdID foreign key (bd_id) references m_bd(bd_id)



