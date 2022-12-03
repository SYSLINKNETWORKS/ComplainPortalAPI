USE ZSONS
GO
--DROP TABLe t_dpso
--drop table t_dpso_pat
--drop table t_mpso
--sp_help t_mso
--alter table m_stk drop constraint FK_MSTK_MSOID
--alter table t_cusadv drop constraint FK_cusadv_msoid
--alter table t_dfg drop constraint FK_mdfg_msoid
--alter table t_dsopk drop constraint FK_dsopk_msoid
--alter table t_mdc drop constraint FK_mdc_soid



Create table t_mpso
(
mpso_sno int identity(1001,1),
mpso_id	int,
mpso_no	int,
mpso_dat datetime,
mpso_ddat datetime,
mpso_rmk varchar(250),
mpso_currat float,
mpso_amt float,
mpso_disper float,
mpso_disamt float,
mpso_freamt float,
mpso_othamt float,
mpso_namt float,
mpso_pamt float default 0, --(process SO amount)
mpso_act bit,
mpso_app bit,
--mpso_soapp bit,
mpso_can bit,
mpso_typ char(1),
ins_usr_id int,
ins_usr_dat datetime,
upd_usr_id int,
upd_usr_dat datetime,
emppro_id int,
cus_id int,
cur_id int,
com_id char(2),
br_id char(3),
m_yr_id char(2),
men_nam varchar(250),
usr_ip varchar(250)
)

--Constraint
--Not null
alter table t_mpso alter column mpso_id int not null

--Primary
alter table t_mpso add constraint PK_Mpso_MPsoID primary key (mpso_id)

--Unique
alter table t_mpso add constraint UN_MPSO_MPSONO unique (mpso_no)


--Foreign Key
alter table t_mpso add constraint FK_Mpso_CUSID foreign key (cus_id) references m_cus(cus_id)
alter table t_mpso add constraint FK_Mpso_CURID foreign key (cur_id) references m_cur(cur_id)
alter table t_mpso add constraint FK_Mpso_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)



--Detail SO
create table t_dpso
(
dpso_sno int identity (1001,1),
dpso_id int,
dpso_qty float,
dpso_rat float,
dpso_amt float,
dpso_disper float,
dpso_disamt float,
dpso_othamt float,
dpso_namt float,
dpso_typ char(1),
dpso_act bit,
titm_id int,
itmqty_id int,
mpso_id int
)




--Constraint
--Not null
alter table t_dpso alter column dpso_id int not null

--primary
alter table t_dpso add constraint PK_Dpso_psoID primary key (dpso_id)

--Foreign Key
alter table t_dpso add constraint FK_Dpso_mpsoID foreign key (Mpso_id) references t_mpso (Mpso_id)
alter table t_dpso add constraint FK_Dpso_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_dpso add constraint FK_Dpso_itmqtyID foreign key (itmqty_id) references m_itmqty (itmqty_id)


--Detail SO Packing

create table t_dpso_pat
(
dpso_pat_sno int identity (1001,1),
pat_id int,
mpso_id int
)

--Constraint
--Foreign Key
alter table t_dpso_pat add constraint FK_dpso_pat_mpsoID foreign key (Mpso_id) references t_mpso (Mpso_id)
alter table t_dpso_pat add constraint FK_dpso_pat_patID foreign key (pat_id) references m_pat (pat_id)
