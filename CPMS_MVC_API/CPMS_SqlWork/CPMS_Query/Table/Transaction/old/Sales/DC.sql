use ZSons
GO

--drop table t_ddc
--drop table t_mdc

create table t_mdc
(
mdc_sno int identity(1001,1),
mdc_id	int,
mdc_no int,
mdc_dat datetime,
mdc_deptime datetime,
mdc_vno varchar(250),
mdc_typ char(1),
mdc_act bit default 0,
mso_id int,
wh_id int,
mdc_rmk varchar(1000),
com_id char(2),
br_id char(3),
m_yr_id char(2)
)


--Constraint
--Not null
alter table t_mdc alter column mdc_id int not null
alter table t_mdc alter column com_id char(2) not null
alter table t_mdc alter column br_id char(3) not null
alter table t_mdc alter column m_yr_id char(2) not null
alter table t_mdc alter column mdc_no int not null

--primary key
alter table t_mdc add constraint PK_Mdc_MdcID primary key (mdc_id)


--Unique
alter table t_mdc add constraint UQ_MDC_MDCNO unique(mdc_no)
--Foreign Key
alter table t_mdc add constraint FK_mdc_SOID foreign key (mso_id) references t_mso(mso_id)
alter table t_mdc add constraint FK_mdc_WHID foreign key (wh_id) references m_wh(wh_id)
alter table t_mdc add constraint FK_mdc_COMID foreign key (com_id) references m_com(com_id)
alter table t_mdc add constraint FK_mdc_BRID foreign key (br_id) references m_br(br_id)
alter table t_mdc add constraint FK_mdc_YRID foreign key (m_yr_id) references gl_m_yr(yr_id)

GO
--drop table t_ddc
create table t_ddc
(
ddc_sno int identity (1001,1),
ddc_id int,
ddc_qty float,
ddc_st bit,
titm_id int,
itmqty_id int,
mdc_id int
)




--Constraint

--Not null
alter table t_ddc alter column ddc_id int not null

--Primary key
alter table t_ddc add constraint PK_ddc_id primary key (ddc_id)

--Foreign Key
alter table t_ddc add constraint FK_ddc_mdc foreign key (mdc_id) references t_mdc (mdc_id)
alter table t_ddc add constraint FK_ddc_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_ddc add constraint FK_ddc_TitmqtyID foreign key (itmqty_id) references m_itmqty (itmqty_id)
	
