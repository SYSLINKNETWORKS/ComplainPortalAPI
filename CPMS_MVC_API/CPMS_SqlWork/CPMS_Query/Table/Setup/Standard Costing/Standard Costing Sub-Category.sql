USE MFI
GO

--drop table m_dscacc
--drop table m_dscfg
--drop table m_mscfg


create table m_mscfg
(
mscfg_sno int identity(1001,1),
mscfg_id int,
mscfg_dat datetime,
mscfg_typ char(1),
mscfg_act bit,
itmsub_id int,
m_yr_id char(2)
)

--Constraint 
--Not Null
alter table m_mscfg alter column mscfg_id int not null

--Primary Key
alter table m_mscfg add constraint PK_Mscfg_scfgID primary key (mscfg_id)
--Foreign key
alter table m_mscfg add constraint FK_MSCFG_ITMSUBID foreign key (itmsub_id) references m_itmsub(itmsub_id)
alter table m_mscfg add constraint FK_MSCFG_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)


--Details
create table m_dscfg
(
dscfg_sno int identity(1001,1),
dscfg_id int,
dscfg_rat float,
sccat_id int,
mscfg_id int
)

--Constraint 
--Not Null
alter table m_dscfg alter column dscfg_id int not null

--Primary Key
alter table m_dscfg add constraint PK_dscfg_dscfgID primary key (dscfg_id)
--Foreign key
alter table m_dscfg add constraint FK_dscfg_SCCATID foreign key (sccat_id) references m_sccat(sccat_id)
alter table m_dscfg add constraint FK_dscfg_SCFGID foreign key (mscfg_id) references m_mscfg(mscfg_id)

--Details Account
create table m_dscfg_acc
(
dscfgacc_sno int identity(1001,1),
dscfgacc_id int,
sccat_id int,
acc_id char(20),
mscfg_id int
)

--Constraint 
--Not Null
alter table m_dscfg_acc alter column dscfgacc_id int not null

--Primary Key
alter table m_dscfg_acc add constraint PK_dscfgacc_dscfgaccID primary key (dscfgacc_id)

--Foreign key
alter table m_dscfg_acc add constraint FK_dscfgacc_SCCATID foreign key (sccat_id) references m_sccat(sccat_id)
alter table m_dscfg_acc add constraint FK_dscfgacc_ACCID foreign key (acc_id) references gl_m_acc(acc_id)
alter table m_dscfg_acc add constraint FK_dscfgacc_SCFGID foreign key (mscfg_id) references m_mscfg(mscfg_id)


--Standard Cost Raw Material
create table m_dscrm
(
dscrm_sno int identity(1001,1),
dscrm_id int,
dscrm_rat float,
titm_id int,
mscfg_id int
)

--Constraint 
--Not Null
alter table m_dscrm alter column dscrm_id int not null

--Primary Key
alter table m_dscrm add constraint PK_dscrm_dscrmID primary key (dscrm_id)

--Foreign key
alter table m_dscrm add constraint FK_dscrm_SCFGID foreign key (mscfg_id) references m_mscfg(mscfg_id)
alter table m_dscrm add constraint FK_dscrm_TITMID foreign key (titm_id) references t_itm(titm_id)

--Standard Cost Packing Material
create table m_dscpk
(
dscpk_sno int identity(1001,1),
dscpk_id int,
dscpk_rat float,
itmsubmas_id int,
mscfg_id int
)

--Constraint 
--Not Null
alter table m_dscpk alter column dscpk_id int not null

--Primary Key
alter table m_dscpk add constraint PK_dscpk_dscpkID primary key (dscpk_id)

--Foreign key
alter table m_dscpk add constraint FK_dscpk_SCFGID foreign key (mscfg_id) references m_mscfg(mscfg_id)
alter table m_dscpk add constraint FK_dscpk_ITMSUBMASID foreign key (itmsubmas_id) references m_itmsubmas(itmsubmas_id)

drop table m_dscpk