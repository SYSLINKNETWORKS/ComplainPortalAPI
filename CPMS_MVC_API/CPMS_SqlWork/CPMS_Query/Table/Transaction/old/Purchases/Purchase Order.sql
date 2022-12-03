USE ZSons
GO

Create table t_mpo
(
mpo_sno int identity(1001,1),
mpo_id	int,
mpo_dat datetime,
mpo_ddat datetime,
mpo_typ char(1),
mpo_act bit default 0,
mpo_rat float,
mpo_amt float,
mpo_tamt as [mpo_rat*mpo_amt],
mpo_rmk varchar(250),
m_yr_id char(2),
mpr_id int,
cur_id int,
sup_id int
)
--alter table t_mpo add mpo_rat float,mpo_amt float,cur_id int
--alter table t_mpo add constraint FK_Mpo_curID foreign key (cur_id) references m_cur(cur_id)
--alter table t_mpo add mpo_tamt as mpo_rat* mpo_amt

--Constraint
--Not null
alter table t_mpo alter column mpo_id int not null
alter table t_mpo alter column m_yr_id char(2) not null

--primary key
alter table t_mpo add constraint PK_MPO_MPOID primary key (mpo_id)

--Foreign Key
alter table t_mpo add constraint FK_mpo_PRID foreign key (mpr_id) references t_mpr(mpr_id)
alter table t_mpo add constraint FK_mpo_SUPID foreign key (sup_id) references m_sup(sup_id)
alter table t_mpo add constraint FK_Mpo_curID foreign key (cur_id) references m_cur(cur_id)

--alter table t_mpo add constraint FK_Mmpo_MGRNID foreign key (mgrn_id,m_yr_id) references t_mgrn(mgrn_id,m_yr_id)



create table t_dpo
(
dpo_sno int identity (1001,1),
dpo_id int,
dpo_man datetime,
dpo_exp datetime,
dpo_qty float,
dpo_rat float,
dpo_trat float,
dpo_amt float,
dpo_tamt float,
dpo_rmk varchar(250)
dpo_st bit,
titm_id int,
titm_img bit,
mpo_id int,
m_yr_id char(2)
)

--alter table t_dpo add bd_id int
--alter table t_dpo add dpo_rat float,dpo_trat float,dpo_amt float,dpo_tamt float

--Constraint

--Not null
alter table t_dpo alter column dpo_id int not null

--Primary key
alter table t_dpo add constraint PK_dpo_id primary key (dpo_id)

--Foreign Key
alter table t_dpo add constraint FK_dpo_mpo foreign key (mpo_id) references t_mpo (mpo_id)
alter table t_dpo add constraint FK_dpo_TITMID foreign key (titm_id) references t_itm (titm_id)


--DROP table t_dpo_pat
create table t_dpo_pat
(
dpo_pat_sno int identity (1001,1),
dpo_pat_id int,
mpo_id int,
pat_id int
)

--Constraint
--Not null
alter table t_dpo_pat alter column dpo_pat_id int not null

--Primary key
alter table t_dpo_pat add constraint PK_dpo_pat_PATid primary key (dpo_pat_id)

--Foreign Key
alter table t_dpo_pat add constraint FK_dpo_pat_MPOID foreign key (mpo_id) references t_mpo (mpo_id)
