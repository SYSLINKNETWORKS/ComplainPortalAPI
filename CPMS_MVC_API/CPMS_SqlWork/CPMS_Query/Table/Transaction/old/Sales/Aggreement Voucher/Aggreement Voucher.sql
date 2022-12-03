USE ZSONS
go

--alter table t_maggvch alter column maggvch_amt float

--drop table t_daggvch
--drop table t_maggvch

Create table t_maggvch
(
maggvch_sno int identity(1001,1),
maggvch_id	int,
maggvch_no int,
maggvch_dat datetime,
maggvch_datfrm datetime,
maggvch_datto datetime,
maggvch_act int default 0,
maggvch_rmk varchar(250),
com_id char(2),
br_id char(3),
m_yr_id char(2),
cus_id int,
maggvch_typ char(1),
maggvch_close bit,
mvch_id int,
ins_usr_id char(2),
ins_dat datetime,
upd_usr_id char(2),
upd_dat datetime
)


--Constraint
--Not null
alter table t_maggvch alter column maggvch_id int not null
alter table t_maggvch alter column com_id char(2) not null
alter table t_maggvch alter column br_id char(3) not null
alter table t_maggvch alter column m_yr_id char(2) not null
alter table t_maggvch alter column maggvch_no int not null

--Priimary
alter table t_maggvch add constraint PK_Maggvch_MaggvchID primary key (maggvch_id)

--Foreign Key
alter table t_maggvch add constraint FK_Maggvch_COMID foreign key (com_id) references m_com(com_id)
alter table t_maggvch add constraint FK_Maggvch_BRID foreign key (br_id) references m_br(br_id)
alter table t_maggvch add constraint FK_Maggvch_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)
alter table t_maggvch add constraint FK_Maggvch_CUSID foreign key (cus_id) references m_cus(cus_id)

--Unique key
alter table t_maggvch add constraint PK_Maggvch_COMID_BRID_MYRID_MaggvchNO unique (com_id,m_yr_id,maggvch_no)


create table t_daggvch
(
daggvch_sno int identity (1001,1),
daggvch_id int,
daggvch_sal float,
daggvch_ret float,
daggvch_dis float,
daggvch_disamt float,
daggvch_add float,
daggvch_ded float,
bd_id int,
itmsub_id int,
maggvch_id int
)



--Constraint
--Not null
alter table t_daggvch alter column daggvch_id int not null

--aggvchimary
alter table t_daggvch add constraint PK_Daggvch_aggvchID primary key (daggvch_id)

--Foreign Key
alter table t_daggvch add constraint FK_Daggvch_aggvchID foreign key (Maggvch_id) references t_maggvch (Maggvch_id)
alter table t_daggvch add constraint FK_Daggvch_BDID foreign key (bd_id) references m_bd (bd_id)
alter table t_daggvch add constraint FK_Daggvch_ITMSUBID foreign key (itmsub_id) references m_itmsub (itmsub_id)


