


--drop table t_itm
--drop table m_itm

--Item Category
create table m_itm
(
itm_sno	int identity(1001,1),
itm_id	int,
itm_nam	varchar(250),
oacc_id char(20),
cacc_id char(20),
pacc_id char(20),
sacc_id char(20),
aacc_id char(20),
itm_cat char(1), --Finish Goods, Raw Material, Packing Material, Others
itm_typ char(1),
itm_act bit
)

--Constraint
--Not Null
alter table m_itm alter column itm_id int not null

--Primary Key
alter table m_itm add constraint PK_Mitm_itmID primary key (itm_id)

--alter table t_itm add bd_id int,gmaster_sca_id int,man_sca_id int


--Item Sub Category Master
create table m_itmsubmas
(
itmsubmas_sno	int identity(1001,1),
itmsubmas_id	int,
itmsubmas_nam	varchar(250),
itmsubmas_typ char(1),
itmsubmas_soact bit,
itmsubmas_innact bit,
itmsubmas_masact bit,
itmsubmas_act bit
)

--Constraint
--Not Null
alter table m_itmsubmas alter column itmsubmas_id int not null

--Primary Key
alter table m_itmsubmas add constraint PK_Mitmsubmas_itmsubmasID primary key (itmsubmas_id)

--alter table t_itm add bd_id int,gmaster_sca_id int,man_sca_id int



--Item Sub Category
create table m_itmsub
(
itmsub_sno	int identity(1001,1),
itmsub_id	int,
itmsub_nam	varchar(250),
itmsubmas_id int,
itmsub_typ char(1),
itmsub_act bit
)

--Constraint
--Not Null
alter table m_itmsub alter column itmsub_id int not null

--Primary Key
alter table m_itmsub add constraint PK_Mitmsub_itmsubID primary key (itmsub_id)

--Foreign Key
alter table m_itmsub add constraint FK_ITMSUB_ITMSUBMASID foreign key (itmsubmas_id) references m_itmsubmas(itmsubmas_id)

--alter table t_itm add bd_id int,gmaster_sca_id int,man_sca_id int


--Item Detail
create table t_itm
(
titm_sno int identity(1001,1),
titm_id	int,
titm_nam	varchar(250),
bd_id int,
titm_bar varchar(100),
sca_id int,
inner_titm_qty float,
inner_sca_id int,
master_titm_qty float,
master_sca_id int,
gmaster_sca_id int,
man_titm_qty float,
man_sca_id int,
man_qty float,
inn_sca_id int,
titm_inn_wei float,
titm_mlvl float,
titm_rlvl float,
titm_prat float,
titm_srat float,
titm_typ char(1),
titm_act bit,
itm_id	int,
itmsub_id int,
wei_sca_id int,
gwei_titm_qty float,
nwei_titm_qty float,
titm_cm float,
ck_bth bit,
titm_img image
)



--Constraint
--Not Null
alter table t_itm alter column titm_id int not null

--Primary Key
alter table t_itm add constraint PK_itmtitm_titmID primary key (titm_id)

--Foreign Key
alter table t_itm add constraint FK_itmtitm_itmID foreign key (itm_id) references m_itm(itm_id)


--Item Qty
create table t_itmqty
(
titmqty_sno	int identity(1001,1),
titmqty_id	int,
itmqty_id int,
titm_id int,
titmqty_typ char(1)
)

--Constraint
--Not Null
alter table t_itmqty alter column titmqty_id int not null

--Primary Key
alter table t_itmqty add constraint PK_Titmqty_titmqtyID primary key (titmqty_id)

--Foreign key
alter table t_itmqty add constraint FK_TITMQTY_ITMQTYID foreign key (itmqty_id) references m_itmqty(itmqty_id)
alter table t_itmqty add constraint FK_TITMQTY_TITMID foreign key (titm_id) references t_itm(titm_id)

--Item Qty
create table t_itmfg
(
titmfg_sno	int identity(1001,1),
titm_id_fg	int,
titm_id		int,
titmfg_typ char(1)
)

--Constraint

--Foreign key
alter table t_itmfg add constraint FK_TITMfg_TITMIDFG foreign key (titm_id_fg) references t_itm(titm_id)
alter table t_itmfg add constraint FK_TITMfg_TITMID foreign key (titm_id) references t_itm(titm_id)
