USE ZSONS
GO
--DROP TABLE t_itmrat

--Size itmrategory
create table t_itmrat
(
titmrat_sno	int identity(1001,1),
titmrat_id	int,
titmrat_dat datetime,
titmrat_wrat float,
titmrat_rrat float,
titmrat_typ char(1),
titmrat_act bit,
titm_id int,
itmqty_id int,
bd_id int,
itmsub_id int
)

--Constraint
--Not Null
alter table t_itmrat alter column titmrat_id int not null

--Primary Key
alter table t_itmrat add constraint PK_Titmrat_titmratid primary key (titmrat_id)

--Foreign key
alter table t_itmrat add constraint FK_TITMRAT_TITMID foreign key (titm_id) references t_itm(titm_id)
alter table t_itmrat add constraint FK_TITMRAT_BDID foreign key (bd_id) references m_bd(bd_id)
alter table t_itmrat add constraint FK_TITMRAT_ITMSUBID foreign key (itmsub_id) references m_itmsub(itmsub_id)


