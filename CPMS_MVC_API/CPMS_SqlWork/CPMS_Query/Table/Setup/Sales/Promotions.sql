USE PAGEY
GO

--drop table m_prom

create table m_prom
(
prom_sno int identity(1001,1),
prom_id int,
prom_dat datetime,
prom_frmdat datetime,
prom_todat datetime,
prom_act bit,
prom_typ char(1),
procat_id int,
titm_id int,
titm_id_free int,
prom_minqty float,
prom_bqty float,
prom_minamt float,
prom_dis float,
com_id char(2),
br_id char(3)
)

--Constraint 
--Not Null
alter table m_prom alter column prom_id int not null

--Primary Key
alter table m_prom add constraint PK_Mprom_promID primary key (prom_id)

--Foreign Key
alter table m_prom add constraint FK_mprom_procatID foreign key (procat_id) references m_procat(procat_id)
alter table m_prom add constraint FK_mprom_titmID foreign key (titm_id) references t_itm(titm_id)
alter table m_prom add constraint FK_mprom_COMID foreign key (com_id) references m_com(com_id)
alter table m_prom add constraint FK_mprom_BRID foreign key (br_id) references m_br(br_id)



--Customer Prometion
create table m_prom_cus
(
prom_cus_sno int identity(1001,1),
prom_cus_id	int,
cus_id int,
prom_id int
)

--Constraint
--Not Null
alter table m_prom_cus alter column prom_cus_id int not null

--Primary Key
alter table m_prom_cus add constraint PK_Mpromcus_promcusID primary key(prom_cus_id)

--Foreign Key
alter table m_prom_cus add constraint FK_Mpromcus_promID foreign key (prom_id) references m_prom(prom_id)
alter table m_prom_cus add constraint FK_Mpromcus_cusID foreign key (cus_id) references m_cus(cus_id)


