USE MFI
GO

--alter table t_mgp add mso_id int

--drop table t_dgp
--drop table t_mgp

Create table t_mgp
(
mgp_sno int identity(1001,1),
mgp_id	int,
mgp_dat datetime,
mgp_act int default 0,
m_yr_id char(2),
mgp_typ char(1),
emppro_id int,
mvch_id char(12)
)

--Constraint
--Not null
alter table t_mgp alter column mgp_id int not null
alter table t_mgp alter column m_yr_id char(2) not null

--gpimary
alter table t_mgp add constraint PK_Mgp_MgpID primary key (mgp_id)

--Foreign Key
alter table t_mgp add constraint FK_Mgp_empproID foreign key (emppro_id) references m_emppro(emppro_id)



create table t_dgp
(
dgp_sno int identity (1001,1),
dgp_id int,
dgp_qty float,
dgp_rat float,
gp_bat varchar(250),
chlbk_no int,
bd_id int,
titm_id int,
nat_id int,
mgp_id int
)



--Constraint
--Not null
alter table t_dgp alter column dgp_id int not null

--Primary
alter table t_dgp add constraint PK_DGP_DGPID primary key (dgp_id)

--Foreign Key
alter table t_dgp add constraint FK_Dgp_gpID foreign key (Mgp_id) references t_mgp (Mgp_id)
alter table t_dgp add constraint FK_Dgp_TITMID foreign key (titm_id) references t_itm (titm_id)
alter table t_dgp add constraint FK_Dgp_BDID foreign key (bd_id) references m_bd (bd_id)
alter table t_dgp add constraint FK_Dgp_NATID foreign key (nat_id) references m_nat (nat_id)
alter table t_dgp add constraint FK_Dgp_CHLBKNO foreign key (chlbk_no) references m_chlbk (chlbk_no)



