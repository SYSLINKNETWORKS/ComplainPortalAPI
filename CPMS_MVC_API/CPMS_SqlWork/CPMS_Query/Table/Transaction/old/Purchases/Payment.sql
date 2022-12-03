--drop table t_dpay
--drop table t_mpay
--select * from t_mpay
--alter table t_mpay drop column mpay_famt
--Master table of plier Payment
create table t_mpay
(
mpay_sno int identity(1001,1),
mpay_id int,
mpay_dat datetime,
mpay_amt float,
mpay_tamt as mpay_rat*mpay_amt,
mpay_epl float,
mpay_cb char(1),
mpay_chq int,
mpay_rmk varchar(250),
sup_bill varchar(1000),
mpay_rat float,
sup_id int,
cur_id int,
m_yr_id char(2),
mvch_id char(12),
mvch_typ char(2),
acc_id char(20)
)
--Not Null
alter table t_mpay alter column mpay_id int not null
alter table t_mpay alter column m_yr_id char(2) not null

--Primary key
alter table t_mpay add constraint PK_MPAYID  primary key (mpay_id)

--Foreign key
alter table t_mpay add constraint FK_MPAY_SUPID foreign key (sup_id) references m_sup(sup_id)
alter table t_mpay add constraint FK_MPAY_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)


--Detail table of plier payment
create table t_dpay
(
dpay_id int,
dpay_amt float,
dpay_famt float,
dpay_epl float,
mpb_id int,
mpay_id int,
m_yr_id char(2)
)
--Not Null
alter table t_dpay alter column dpay_id int not null
alter table t_dpay alter column m_yr_id char(2) not null

--Primary key
alter table t_dpay add constraint PK_DPAYID primary key (dpay_id)

--Foreign key
alter table t_dpay add constraint FK_TMPB_MPBID foreign key (mpb_id) references t_mpb(mpb_id)
alter table t_dpay add constraint FK_MPAY_MPAYID foreign key (mpay_id) references t_mpay(mpay_id)
alter table t_dpay add constraint FK_MPAY_GLMYR_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)





