--drop table t_dgrn
--drop table t_mgrn
--alter table t_mgrn add mgrn_rat float,mgrn_amt float,mgrn_tamt as [mgrn_rat* mgrn_amt],cur_id int
--alter table t_dgrn add dgrn_rat float,dgrn_trat float,dgrn_amt float,dgrn_tamt float
--update t_dgrn set dgrn_rat=0,dgrn_trat=0,dgrn_amt=0,dgrn_tamt=0

Create table t_mgrn
(
mgrn_sno int identity(1001,1),
mgrn_id	int,
mgrn_dat datetime,
mgrn_typ char(1),
mgrn_act int default 0,
sup_dc varchar(100),
mgrn_rmk varchar(250),
mgrn_rat float,
mgrn_amt float,
mgrn_tamt as mgrn_rat*mgrn_amt,
mgrn_nw float,
cur_id int,
mpo_id int,
wh_id int,
sca_id int,
m_yr_id char(2)
)



--Constraint
--Not null
alter table t_mgrn alter column mgrn_id int not null
alter table t_mgrn alter column m_yr_id char(2) not null

--Primary
alter table t_mgrn add constraint PK_Mgrn_grnID primary key (mgrn_id)
--Foreign Key
alter table t_mgrn add constraint FK_MGRN_MPOID foreign key (mpo_id) references t_mpo(mpo_id)
alter table t_mgrn add constraint FK_MGRN_curID foreign key (cur_id) references m_cur(cur_id)
alter table t_mgrn add constraint FK_MGRN_scaID foreign key (sca_id) references m_sca(sca_id)


create table t_dgrn
(
dgrn_sno int identity (1001,1),
dgrn_id int,
dgrn_man datetime,
dgrn_exp datetime,
dgrn_qty float,
dgrn_rat float,
dgrn_trat float,
dgrn_amt float,
dgrn_tamt float,
dgrn_st int default 0,
mgrn_id int,
titm_id int,
m_yr_id char(2)
)




--Constraint
--Not null
alter table t_dgrn alter column dgrn_id int not null
alter table t_dgrn alter column m_yr_id char(2) not null

--Primary
alter table t_dgrn add constraint PK_TDGRN_DGRNID primary key (dgrn_id)

--Foreign Key
alter table t_dgrn add constraint FK_DGRN_MGRNID foreign key (mgrn_id) references t_mgrn (mgrn_id)
alter table t_dgrn add constraint FK_DGRN_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_dgrn add constraint FK_DGRN_YRID foreign key (m_yr_id) references gl_m_yr (yr_id)
