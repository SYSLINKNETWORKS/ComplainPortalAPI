USE MFI
GO
--drop table t_dstdcos_pk
--drop table t_dstdcos_rm
--drop table t_dstdcos_exp
--drop table t_mstdcos

--Item Brand
create table t_mstdcos
(
mstdcos_sno int identity(1001,1),
mstdcos_id	int,
mstdcos_dat datetime,
mstdcos_typ char(1),
titm_id int,
itmqty_id int
)


--Constraint
--Not Null
alter table t_mstdcos alter column mstdcos_id int not null

--Primary Key
alter table t_mstdcos add constraint PK_Mmstdcos_mstdcosID primary key (mstdcos_id)

--Foreign Key
alter table t_mstdcos add constraint FK_Mmstdcos_titm_ID foreign key (titm_id) references t_itm(titm_id)





--Detail for Expense
create table t_dstdcos_exp
(
dstdcos_sno int identity(1001,1),
dstdcos_id	int,
acc_id	char(20),
dstdcos_rat float,
mstdcos_id int
)

--Constraint
--Not Null
alter table t_dstdcos_exp alter column dstdcos_id int not null

--Primary Key
alter table t_dstdcos_exp add constraint PK_Mdstdcos_dstdcosID_exp primary key(dstdcos_id)

--Foreign Key
alter table t_dstdcos_exp add constraint FK_Mdstdcos_mstdcosID_EXP foreign key (mstdcos_id) references t_mstdcos(mstdcos_id)
alter table t_dstdcos_exp add constraint FK_Mdstdcos_accID foreign key (acc_id) references gl_m_acc(acc_id)


--Detail for RM
create table t_dstdcos_rm
(
dstdcos_sno int identity(1001,1),
dstdcos_id	int,
titm_id	int,
dstdcos_rat float,
mstdcos_id int
)

--Constraint
--Not Null
alter table t_dstdcos_rm alter column dstdcos_id int not null

--Primary Key
alter table t_dstdcos_rm add constraint PK_Mdstdcos_dstdcosID_RM primary key(dstdcos_id)

--Foreign Key
alter table t_dstdcos_rm add constraint FK_Mdstdcos_mstdcosID_RM foreign key (mstdcos_id) references t_mstdcos(mstdcos_id)
alter table t_dstdcos_rm add constraint FK_Mdstdcos_titmID_RM foreign key (titm_id) references t_itm(titm_id)


--Detail for Packing
create table t_dstdcos_pk
(
dstdcos_sno int identity(1001,1),
dstdcos_id	int,
titm_id int,
dstdcos_rat float,
mstdcos_id int
)

--Constraint
--Not Null
alter table t_dstdcos_pk alter column dstdcos_id int not null

--Primary Key
alter table t_dstdcos_pk add constraint PK_Mdstdcos_dstdcosID_PK primary key(dstdcos_id)

--Foreign Key
alter table t_dstdcos_pk add constraint FK_Mdstdcos_mstdcosID_PK foreign key (mstdcos_id) references t_mstdcos(mstdcos_id)
alter table t_dstdcos_pk add constraint FK_Mdstdcos_titmID_PK foreign key (titm_id) references t_itm(titm_id)
