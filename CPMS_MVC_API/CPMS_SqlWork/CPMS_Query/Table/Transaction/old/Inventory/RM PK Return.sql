USE MFI
GO
--drop table t_dret
--drop table t_mret


--Item Brand
create table t_mret
(
mret_sno int identity(1001,1),
mret_id	int,
mret_dat datetime,
titm_id int,
mret_act bit,
mso_id int,
mret_ckso bit,
mret_typ char(1),
cus_id int,
bd_id int,
mvch_id char(12)
)


--Constraint
--Not Null
alter table t_mret alter column mret_id int not null

--Primary Key
alter table t_mret add constraint PK_Mmret_mretID primary key (mret_id)

--Foreign Key
alter table t_mret add constraint FK_Mmret_titm_ID foreign key (titm_id) references t_itm(titm_id)
alter table t_mret add constraint FK_Mret_CUSID foreign key (cus_id) references m_cus(cus_id)
alter table t_mret add constraint FK_Mret_BDID foreign key (bd_id) references m_bd(bd_id)






create table t_dret
(
dret_sno int identity(1001,1),
dret_id	int,
dret_exp datetime,
dret_qty float,
dret_rat float,
dret_namt as dret_qty*dret_rat,
titm_id int,
mret_id int,
wh_id int
)

--Constraint
--Not Null
alter table t_dret alter column dret_id int not null

--Primary Key
alter table t_dret add constraint PK_Mdret_dretID primary key(dret_id)

--Foreign Key
alter table t_dret add constraint FK_Mdret_mretID foreign key (mret_id) references t_mret(mret_id)
alter table t_dret add constraint FK_Mdret_titmID foreign key (titm_id) references t_itm(titm_id)
alter table t_dret add constraint FK_Dret_whID foreign key (wh_id) references m_wh(wh_id)


