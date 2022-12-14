--alter table t_mvch add mvch_tdat datetime,mvch_chq float,mvch_chqdat datetime,mvch_chqst bit default 0
--alter table t_mvch add mvch_po bit default 0
--update t_mvch set mvch_po=0 

--alter table t_mvch add cur_id int,mvch_rat float
--alter table t_mvch add constraint fk_tmvch_curid foreign key (cur_id) references m_cur(cur_id)
--alter table t_dvch add dvch_dr_famt float,dvch_cr_famt float

create table t_mvch 
(
s_no int identity(1001,1),
mvch_no int,
mvch_id char(12),
mvch_dat datetime,
mvch_tdat datetime,
mvch_pro varchar(20),
mvch_app char(1) default 'N',
br_id char(3),
com_id char(2),
dpt_id char(2),
cur_id int,
typ_id char(2),
yr_id char(2),
mvch_cb char(1) default 'C',
mvch_ref varchar(100),
mvch_chq float,
mvch_chqdat datetime,
mvch_chqcldat datetime,
mvch_po bit default 0,
mvch_chqst bit default 0,
mvch_rat float,
mvch_typ varchar(1) default 'U',
mvch_oldvoucherno char(100)
)


--Constaint
--Not Null
alter table t_mvch alter column br_id char(3) not null
alter table t_mvch alter column com_id char(2) not null
alter table t_mvch alter column yr_id char(2) not null
alter table t_mvch alter column mvch_id char(12) not null
alter table t_mvch alter column typ_id char(2) not null
alter table t_mvch alter column mvch_no int not null

--Primary key
alter table t_mvch add constraint pk_comid_brid_mvchno primary key (com_id,br_id,mvch_no)

--Foreign key
alter table t_mvch add constraint fk_tmvch_dptid foreign key (dpt_id) references m_dpt(dpt_id)
alter table t_mvch add constraint fk_tmvch_brid foreign key (br_id) references m_br(br_id)
alter table t_mvch add constraint fk_tmvch_comid foreign key (com_id) references m_com(com_id)
alter table t_mvch add constraint fk_tmvch_yrid foreign key (yr_id) references gl_m_yr(yr_id)
ALTER TABLE t_mvch ADD CONSTRAINT fk_tmvch_typid FOREIGN KEY(typ_id)REFERENCES gl_vch_typ (typ_id)
alter table t_mvch add constraint fk_tmvch_curid foreign key (cur_id) references m_cur(cur_id)

--Check Constraint
ALTER TABLE t_mvch ADD CONSTRAINT CK_TMVCH_CB CHECK  ([mvch_cb]='C' OR [mvch_cb]='B')
ALTER TABLE t_mvch ADD CONSTRAINT CK_TMVCH_TYP CHECK ([mvch_typ]='U' OR [mvch_typ]='S')

--Detail Voucher
create table t_dvch
(
s_no int identity(1001,1),
dvch_row int,
dvch_nar nvarchar(1000),
dvch_dr_famt float, --Foreign Amount
dvch_cr_famt float, --Foreign Amount
dvch_dr_amt float,
dvch_cr_amt float,
com_id char(2),
br_id char(3),
mvch_no int,
acc_no int
)

--Constraint
--Not Null
alter table t_dvch alter column com_id char(2) not null
alter table t_dvch alter column br_id char(3) not null
alter table t_dvch alter column mvch_no int not null
alter table t_dvch alter column dvch_row int not null



--Primary key
alter table t_dvch add constraint pk_comid_brid_mvchno_dvchrow primary key (com_id,br_id,mvch_no,dvch_row)

--Foreign key
alter table t_dvch add constraint fk_tdvch_dptid foreign key (dpt_id) references m_dpt(dpt_id)
alter table t_dvch add constraint FK_TDVCH_COMID_BRID_MVCHNO foreign key (com_id,br_id,mvch_no) references t_mvch(com_id,br_id,mvch_no)
alter table t_dvch add constraint FK_TDVCH_COMID_ACCNO foreign key (com_id,acc_no) references gl_m_acc(com_id,acc_no)

