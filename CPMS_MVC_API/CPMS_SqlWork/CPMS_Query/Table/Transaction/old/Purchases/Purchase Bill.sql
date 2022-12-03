--drop table t_dpb_grn
--drop table t_dpb
--drop table t_mpb

--alter table t_mpb add mpb_disper float,mpb_disamt float,mpb_namt float,mpb_tdisamt float,mpb_ntamt float
Create table t_mpb
(
mpb_sno int identity(1001,1),
mpb_id	int,
mpb_dat datetime,
mpb_typ char(1),
mpb_rat float,
sup_id int,
cur_id int,
mpb_st int default 0,
mpb_rmk varchar(250),
mpb_amt float,
mpb_disper float,
mpb_disamt float,
mpb_desamt float,
mpb_othamt float,
mpb_namt float,
mpb_tamt as mpb_rat*mpb_amt,
mpb_tdisamt as mpb_rat*mpb_disamt,
mpb_tdes as mpb_rat*mpb_desamt,
mpb_toth as mpb_rat*mpb_othamt,
mpb_ntamt as mpb_rat*mpb_desamt,
mpb_con char(1),
mpb_fre float,
mpb_tfre as mpb_rat*mpb_fre,
sup_bill varchar(100),
sup_billdat datetime,
mgrn_id varchar(100),
m_yr_id char(2),
mvch_id char(12)
)

--Constraint
--Not null
alter table t_mpb alter column mpb_id int not null
alter table t_mpb alter column m_yr_id char(2) not null

--Primary
alter table t_mpb add constraint PK_Mpb_pbID primary key (mpb_id)

--Foreign key
alter table t_mpb add constraint FK_MPB_SUPID foreign key (sup_id) references m_sup(sup_id)
alter table t_mpb add constraint FK_MPB_CURID foreign key (cur_id) references m_cur(cur_id)

--Detail Purchase Bill
create table t_dpb
(
dpb_sno int identity (1001,1),
dpb_id int,
dpb_qty float,
dpb_rat float,
dpb_amt float,
dpb_disper float,
dpb_disamt float,
dpb_namt float,
dpb_tamt float,
dpb_tdisamt float,
dpb_ntamt float,
dpb_st int default 0,
mpb_id int,
titm_id int,
m_yr_id char(2)
)



--Constraint
--Not null
alter table t_dpb alter column dpb_id int not null
alter table t_dpb alter column m_yr_id char(2) not null

--Primary
alter table t_dpb add constraint PK_TDpb_DpbID primary key (dpb_id)

--Foreign Key
alter table t_dpb add constraint FK_Dpb_MpbID foreign key (mpb_id) references t_mpb (mpb_id)
alter table t_dpb add constraint FK_DPB_titmID foreign key (titm_id) references t_itm (titm_id)
alter table t_dpb add constraint FK_Dpb_YRID foreign key (m_yr_id) references gl_m_yr (yr_id)

--Detail Purchase Bill GRN
create table t_dpb_grn
(
dpb_grn_sno int identity(1001,1),
dpb_grn_id int,
mpb_id int,
mqc_id int,
m_yr_id char(2)
)	

--Constraint
--Not null
alter table t_dpb_grn alter column dpb_grn_id int not null
alter table t_dpb_grn alter column m_yr_id char(2) not null

--Primary
alter table t_dpb_grn add constraint PK_TDpb_DpbGRNID primary key (dpb_grn_id)

--Foreign Key
alter table t_dpb_grn add constraint FK_Dpbgrn_MPBID foreign key (mpb_id) references t_mpb (mpb_id)
alter table t_dpb_grn add constraint FK_Dpbgrn_MQCID foreign key (mqc_id) references t_mqc (mqc_id)
alter table t_dpb_grn add constraint FK_Dpbgrn_YRID foreign key (m_yr_id) references gl_m_yr (yr_id)
