USE phm
GO

--drop table m_dspo_cus
--drop table m_mspo 


create table m_mspo
(
mspo_sno int identity(1001,1),
mspo_id int,
mspo_dat datetime,
mspo_act bit,
mspo_typ char(1),
emppro_id int
)

--Constraint 
--Not Null
alter table m_mspo alter column mspo_id int not null

--Primary Key
alter table m_mspo add constraint PK_mspo_mspoID primary key (mspo_id)

--Foreign key
alter table m_mspo add constraint FK_Mspo_empproID foreign key (emppro_id) references m_emppro (emppro_id)


--SPO Customer
create table m_dspo_cus
(
dspo_cus_sno int identity(1001,1),
dspo_cus_id int,
mspo_id int,
cus_id int
)

--Constraint 
--Not Null
alter table m_dspo_cus alter column dspo_cus_id int not null

--Primary Key
alter table m_dspo_cus add constraint PK_dspo_cus_dspo_cusID primary key (dspo_cus_id)

--Foreign key
alter table m_dspo_cus add constraint FK_dspo_cus_mspoID foreign key (mspo_id) references m_mspo (mspo_id)
alter table m_dspo_cus add constraint FK_dspo_cus_cusID foreign key (cus_id) references m_cus (cus_id)


--Spo Items
create table m_dspo_titm
(
dspo_titm_sno int identity(1001,1),
dspo_titm_id int,
mspo_id int,
titm_id int
)

--Constraint 
--Not Null
alter table m_dspo_titm alter column dspo_titm_id int not null

--Primary Key
alter table m_dspo_titm add constraint PK_dspo_titm_dspo_titmID primary key (dspo_titm_id)

--Foreign key
alter table m_dspo_titm add constraint FK_dspo_titm_mspoID foreign key (mspo_id) references m_mspo (mspo_id)
alter table m_dspo_titm add constraint FK_dspo_titm_cusID foreign key (titm_id) references t_itm (titm_id)

