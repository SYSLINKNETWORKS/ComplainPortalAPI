USE MFI
GO

--drop table m_dscacc
--drop table m_dscfg
--drop table m_mscfg
--drop table m_dscfg_acc
--drop table m_dscpk
--drop table m_dscrm

create table m_mscexp
(
mscexp_sno int identity(1001,1),
mscexp_id int,
mscexp_dat datetime,
mscexp_typ char(1),
mscexp_act bit,
itmsub_id int,
m_yr_id char(2)
)

--Constraint 
--Not Null
alter table m_mscexp alter column mscexp_id int not null

--Primary Key
alter table m_mscexp add constraint PK_mscexp_scfgID primary key (mscexp_id)
--Foreign key
alter table m_mscexp add constraint FK_mscexp_ITMSUBID foreign key (itmsub_id) references m_itmsub(itmsub_id)
alter table m_mscexp add constraint FK_mscexp_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)


--Details Sub -Category
create table m_dsccat
(
dsccat_sno int identity(1001,1),
dsccat_id int,
dsccat_rat float,
dsccat_sca int,
sccat_id int,
mscexp_id int
)

--Constraint 
--Not Null
alter table m_dsccat alter column dsccat_id int not null

--Primary Key
alter table m_dsccat add constraint PK_dsccat_dsccatID primary key (dsccat_id)
--Foreign key
alter table m_dsccat add constraint FK_dsccat_SCCATID foreign key (sccat_id) references m_sccat(sccat_id)
alter table m_dsccat add constraint FK_dsccat_SCFGID foreign key (mscexp_id) references m_mscexp(mscexp_id)


--Finish Goods
create table m_dscfg
(
dscfg_sno int identity(1001,1),
dscfg_id int,
titm_id int,
mscexp_id int
)

--Constraint 
--Not Null
alter table m_dscfg alter column dscfg_id int not null

--Primary Key
alter table m_dscfg add constraint PK_dscfg_dscfgID primary key (dscfg_id)
--Foreign key
alter table m_dscfg add constraint FK_dscfg_titmID foreign key (titm_id) references t_itm(titm_id)
alter table m_dscfg add constraint FK_dscfg_SCEXPID foreign key (mscexp_id) references m_mscexp(mscexp_id)

go
--Details Account
create table m_dscfg_acc
(
dscfgacc_sno int identity(1001,1),
dscfgacc_id int,
sccat_id int,
acc_id char(20),
mscexp_id int
)

--Constraint 
--Not Null
alter table m_dscfg_acc alter column dscfgacc_id int not null

--Primary Key
alter table m_dscfg_acc add constraint PK_dscfgacc_dscfgaccID primary key (dscfgacc_id)

--Foreign key
alter table m_dscfg_acc add constraint FK_dscfgacc_SCCATID foreign key (sccat_id) references m_sccat(sccat_id)
alter table m_dscfg_acc add constraint FK_dscfgacc_ACCID foreign key (acc_id) references gl_m_acc(acc_id)
alter table m_dscfg_acc add constraint FK_dscfgacc_SCEXPID foreign key (mscexp_id) references m_mscexp(mscexp_id)


--Finish Goods
create table m_dscpk
(
dscpk_sno int identity(1001,1),
dscpk_id int,
dscpk_rat float,
itmsubmas_id int,
titm_id int,
mscexp_id int
)

--Constraint 
--Not Null
alter table m_dscpk alter column dscpk_id int not null

--Primary Key
alter table m_dscpk add constraint PK_dscpk_dscpkID primary key (dscpk_id)

--Foreign key
alter table m_dscpk add constraint FK_dscpk_ITMSUBMASID foreign key (itmsubmas_id) references m_itmsubmas(itmsubmas_id)
alter table m_dscpk add constraint FK_dscpk_titmID foreign key (titm_id) references t_itm(titm_id)
alter table m_dscpk add constraint FK_dscpk_SCEXPID foreign key (mscexp_id) references m_mscexp(mscexp_id)
