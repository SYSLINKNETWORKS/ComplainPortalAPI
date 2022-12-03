USE ZSONS
GO
--DROP TABLe t_dso
--drop table t_dso_pat
--drop table t_mso
--sp_help t_mso
--alter table m_stk drop constraint FK_MSTK_MSOID
--alter table t_cusadv drop constraint FK_cusadv_msoid
--alter table t_dfg drop constraint FK_mdfg_msoid
--alter table t_dsopk drop constraint FK_dsopk_msoid
--alter table t_mdc drop constraint FK_mdc_soid

--DSR
--drop table t_msodsr

Create table t_msodsr
(
msodsr_sno int identity(1001,1),
msodsr_id	int,
msodsr_no	int,
msodsr_act bit,
msodsr_can bit,
msodsr_typ char(1),
msodsr_idold varchar(1000),
com_id char(2),
br_id char(3),
m_yr_id char(2),
ins_usr_id int,
ins_usr_dat datetime,
upd_usr_id int,
upd_usr_dat datetime
)

--Constraint
--Not null
alter table t_msodsr alter column msodsr_id int not null

--Primary
alter table t_msodsr add constraint PK_msodsr_msodsrID primary key (msodsr_id)

--Unique
alter table t_msodsr add constraint UN_msodsr_msodsrNO unique (msodsr_no)


---
go

Create table t_mso
(
mso_sno int identity(1001,1),
mso_id	int,
mso_no	int,
mso_dat datetime,
mso_cuspo varchar(250),
mso_podat datetime,
mso_ddat datetime,
mso_rmk varchar(250),
mso_currat float,
mso_amt float,
mso_disper float,
mso_disamt float,
mso_freamt float,
mso_othamt float,
mso_namt float,
mso_pamt float default 0, --(process SO amount)
mso_act bit,
mso_app bit,
mso_soapp bit,
mso_can bit,
mso_typ char(1),
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
alter table t_mso alter column mso_id int not null

--Primary
alter table t_mso add constraint PK_Mso_MsoID primary key (mso_id)

--Unique
alter table t_mso add constraint UN_MSO_MSONO unique (mso_no)


--Foreign Key
alter table t_mso add constraint FK_Mso_CUSID foreign key (cus_id) references m_cus(cus_id)
alter table t_mso add constraint FK_Mso_CURID foreign key (cur_id) references m_cur(cur_id)
alter table t_mso add constraint FK_Mso_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)



--Detail SO
create table t_dso
(
dso_sno int identity (1001,1),
dso_id int,
dso_qty float,
dso_rat float,
dso_amt float,
dso_disper float,
dso_disamt float,
dso_othamt float,
dso_namt float,
dso_typ char(1),
dso_act bit,
titm_id int,
itmqty_id int,
mso_id int
)




--Constraint
--Not null
alter table t_dso alter column dso_id int not null

--primary
alter table t_dso add constraint PK_Dso_soID primary key (dso_id)

--Foreign Key
alter table t_dso add constraint FK_Dso_msoID foreign key (Mso_id) references t_mso (Mso_id)
alter table t_dso add constraint FK_Dso_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_dso add constraint FK_Dso_itmqtyID foreign key (itmqty_id) references m_itmqty (itmqty_id)


--Detail SO Packing

create table t_dso_pat
(
dso_pat_sno int identity (1001,1),
pat_id int,
mso_id int
)

--Constraint
--Foreign Key
alter table t_dso_pat add constraint FK_dso_pat_msoID foreign key (Mso_id) references t_mso (Mso_id)
alter table t_dso_pat add constraint FK_dso_pat_patID foreign key (pat_id) references m_pat (pat_id)
