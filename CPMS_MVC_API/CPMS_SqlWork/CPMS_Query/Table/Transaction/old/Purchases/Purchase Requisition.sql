
--alter table t_mpr add mso_id int

--drop table t_dpr
--drop table t_mpr

Create table t_mpr
(
mpr_sno int identity(1001,1),
mpr_id	int,
mpr_dat datetime,
mpr_act int default 0,
m_yr_id char(2),
dpt_id char(2),
mpr_typ char(1),
mso_id int
)

--Constraint
--Not null
alter table t_mpr alter column mpr_id int not null
alter table t_mpr alter column m_yr_id char(2) not null

--Primary
alter table t_mpr add constraint PK_MPR_MPRID primary key (mpr_id)

--Foreign Key
alter table t_mpr add constraint FK_MPR_DPTID foreign key (dpt_id) references m_dpt(dpt_id)



create table t_dpr
(
dpr_sno int identity (1001,1),
dpr_id int,
dpr_qty float,
dpr_st int,
titm_id int,
dpr_man datetime,
dpr_exp datetime,
mpr_id int
)



--Constraint
--Not null
alter table t_dpr alter column dpr_id int not null

--Primary
alter table t_dpr add constraint PK_DPR_PRID primary key (dpr_id)

--Foreign Key
alter table t_dpr add constraint FK_DPR_PRID foreign key (MPR_id) references t_mpr (MPR_id)
alter table t_dpr add constraint FK_DPR_TITMID foreign key (titm_id) references t_itm (titm_id)


