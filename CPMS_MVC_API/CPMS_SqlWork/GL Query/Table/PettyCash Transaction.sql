USE ZSons
GO
--drop table t_dpc
--drop table t_mpc


create table t_mpc 
(
mpc_sno int identity(1001,1),
mpc_no int,
mpc_dat datetime,
mpc_rmk varchar(100),
mpc_rat float,
mpc_typ varchar(1) default 'U',
cur_id int,
com_id char(2),
br_id char(3),
yr_id char(2),
ins_usr_id char(2),
ins_dat datetime,
upd_usr_id char(2),
upd_dat datetime,
mvch_no int,
mpc_dc bit
)

--Constaint
--Not Null
alter table t_mpc alter column br_id char(3) not null
alter table t_mpc alter column com_id char(2) not null
alter table t_mpc alter column yr_id char(2) not null
alter table t_mpc alter column mpc_no int not null

--Primary key
alter table t_mpc add constraint pk_mpcno primary key (mpc_no)

--Foreign key
alter table t_mpc add constraint fk_tmpc_brid foreign key (br_id) references m_br(br_id)
alter table t_mpc add constraint fk_tmpc_comid foreign key (com_id) references m_com(com_id)
alter table t_mpc add constraint fk_tmpc_yrid foreign key (yr_id) references gl_m_yr(yr_id)
alter table t_mpc add constraint fk_tmpc_curid foreign key (cur_id) references m_cur(cur_id)

--Check Constraint
ALTER TABLE t_mpc ADD CONSTRAINT CK_TMpc_TYP CHECK ([mpc_typ]='U' OR [mpc_typ]='S')

--Detail Voucher
create table t_dpc
(
dpc_sno int identity(1001,1),
dpc_row int,
dpc_nar nvarchar(1000),
dpc_amt float,
dpc_set bit,
dpc_setdat datetime,
com_id char(2),
mpc_no int,
acc_no int
)

--Constraint
--Not Null
alter table t_dpc alter column com_id char(2) not null
alter table t_dpc alter column mpc_no int not null
alter table t_dpc alter column dpc_row int not null



--Primary key
alter table t_dpc add constraint pk_comid_brid_mpcno_dpcrow primary key (mpc_no,dpc_row)

--Foreign key
alter table t_dpc add constraint FK_TDpc_COMID_BRID_MpcNO foreign key (mpc_no) references t_mpc(mpc_no)
alter table t_dpc add constraint FK_TDpc_COMID_ACCNO foreign key (com_id,acc_no) references gl_m_acc(com_id,acc_no)

