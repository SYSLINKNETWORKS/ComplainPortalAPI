USE MFI
GO
--drop table t_mfg
--drop table t_dfg

--Item Brand
create table t_mfg
(
mfg_sno int identity(1001,1),
mfg_id	int,
mfg_dat datetime,
mfg_act bit,
mfg_typ char(1)
)


--Constraint
--Not Null
alter table t_mfg alter column mfg_id int not null

--Primary Key
alter table t_mfg add constraint PK_Mmfg_mfgID primary key (mfg_id)

--Foreign Key
--alter table t_mfg add constraint FK_Mmfg_titm_ID foreign key (titm_id) references t_itm(titm_id)
--alter table t_mfg add constraint FK_Mmfg_mso_ID foreign key (mso_id) references t_mso(mso_id)






create table t_dfg
(
dfg_sno int identity(1001,1),
dfg_id	int,
dfg_bat	int,
dfg_exp datetime,
dfg_rec float,
dfg_rat float,
titm_id int,
mso_id int,
mfg_id int,
wh_id int
)

--Constraint
--Not Null
alter table t_dfg alter column dfg_id int not null

--Primary Key
alter table t_dfg add constraint PK_Mdfg_dfgID primary key(dfg_id)

--Foreign Key
alter table t_dfg add constraint FK_Mdfg_mfgID foreign key (mfg_id) references t_mfg(mfg_id)
alter table t_dfg add constraint FK_Mdfg_titmID foreign key (titm_id) references t_itm(titm_id)
alter table t_dfg add constraint FK_Mdfg_msoID foreign key (mso_id) references t_mso(mso_id)
alter table t_dfg add constraint FK_TDFG_WHID foreign key (wh_id) references m_wh(wh_id)

 