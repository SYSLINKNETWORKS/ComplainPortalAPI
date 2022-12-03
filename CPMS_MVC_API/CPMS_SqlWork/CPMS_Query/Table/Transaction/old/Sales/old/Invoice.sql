--drop table t_dinv_dc
--drop table t_dinv
--drop table t_minv

Create table t_minv
(
minv_sno int identity(1001,1),
minv_id	int,
minv_dat datetime,
minv_typ char(1),
minv_rat float,
cus_id int,
cur_id int,
minv_st int default 0,
minv_rmk varchar(250),
minv_amt float,
minv_camt float,
minv_refamt float,
minv_disper float,
minv_disamt float,
minv_freamt float,
minv_namt float,
minv_tamt as minv_amt*minv_rat,
minv_tcamt as minv_camt*minv_rat,
minv_trefamt as minv_refamt*minv_rat,
minv_tdisamt as minv_disamt*minv_rat,
minv_tfreamt as minv_freamt*minv_rat,
minv_ntamt as minv_namt*minv_rat,
mdc_id varchar(100),
m_yr_id char(2),
mvch_id char(12)
)

--alter table t_minv add minv_freamt float,minv_gamt float,minv_disper float,minv_disamt float,minv_namt float,minv_tfreamt float,minv_tgamt float,minv_tdisamt float,minv_ntamt float

--Constraint
--Not null
alter table t_minv alter column minv_id int not null
alter table t_minv alter column m_yr_id char(2) not null

--Primary
alter table t_minv add constraint PK_Minv_invID primary key (minv_id)

--Foreign key
alter table t_minv add constraint FK_Minv_cusID foreign key (cus_id) references m_cus(cus_id)
alter table t_minv add constraint FK_Minv_CURID foreign key (cur_id) references m_cur(cur_id)

--Detail Purchase Bill
create table t_dinv
(
dinv_sno int identity (1001,1),
dinv_id int,
dinv_qty float,
dinv_rat float,
dinv_trat as round((dinv_tamt/dinv_rat),4),
dinv_amt float,
dinv_tamt float,
dinv_st int default 0,
minv_id int,
titm_id int,
m_yr_id char(2)
)


--Constraint
--Not null
alter table t_dinv alter column dinv_id int not null
alter table t_dinv alter column m_yr_id char(2) not null

--Primary
alter table t_dinv add constraint PK_TDinv_DinvID primary key (dinv_id)

--Foreign Key
alter table t_dinv add constraint FK_Dinv_MinvID foreign key (minv_id) references t_minv (minv_id)
alter table t_dinv add constraint FK_Dinv_titmID foreign key (titm_id) references t_itm (titm_id)
alter table t_dinv add constraint FK_Dinv_YRID foreign key (m_yr_id) references gl_m_yr (yr_id)

--Detail Purchase Bill dc
create table t_dinv_dc
(
dinv_dc_sno int identity(1001,1),
dinv_dc_id int,
minv_id int,
mdc_id int,
m_yr_id char(2)
)	

--Constraint
--Not null
alter table t_dinv_dc alter column dinv_dc_id int not null
alter table t_dinv_dc alter column m_yr_id char(2) not null

--Primary
alter table t_dinv_dc add constraint PK_TDinv_DinvdcID primary key (dinv_dc_id)

--Foreign Key
alter table t_dinv_dc add constraint FK_Dinvdc_MinvID foreign key (minv_id) references t_minv (minv_id)
alter table t_dinv_dc add constraint FK_Dinvdc_MdcID foreign key (mdc_id) references t_mdc (mdc_id)
alter table t_dinv_dc add constraint FK_Dinvdc_YRID foreign key (m_yr_id) references gl_m_yr (yr_id)
