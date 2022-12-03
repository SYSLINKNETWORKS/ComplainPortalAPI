USE phm
GO

--drop table m_mdoc
--Master Doctor
create table m_mdoc
(
mdoc_sno	int identity(1001,1),
mdoc_id	int,
mdoc_nam	varchar(250),
mdoc_act	bit,
mdoc_typ char(1),
mdoc_pho varchar(100),
mdoc_mob varchar(100),
mdoc_fax varchar(100),
mdoc_eml varchar(100),
doccat_id int,
spo_id int,
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_mdoc alter column mdoc_id int not null

--Primary Key
alter table m_mdoc add constraint PK_Mmdoc_mdocID primary key (mdoc_id)

--Foriegn Key
alter table m_mdoc add constraint FK_MMDOC_MSOID foreign key (mso_id) references m_mso(mso_id)
alter table m_mdoc add constraint FK_MMDOC_DOCCATID foreign key (doccat_id) references m_doccat(doccat_id)


--drop table m_ddoc
--Detail Doctor
create table m_ddoc
(
ddoc_sno	int identity(1001,1),
ddoc_id	int,
ddoc_con varchar(100),
ddoc_timfrm datetime,
ddoc_timto datetime,
mdoc_id int,
hos_id int,
log_act char(1),
log_dat datetime,
log_ip varchar(100),
usr_id int
)

--Constraint
--Not Null
alter table m_ddoc alter column ddoc_id int not null

--Primary Key
alter table m_ddoc add constraint PK_Mddoc_ddocID primary key (ddoc_id)

--Foriegn Key
alter table m_ddoc add constraint FK_MDDOC_MDOCID foreign key (mdoc_id) references m_mdoc(mdoc_id)
alter table m_ddoc add constraint FK_MDDOC_HOSID foreign key (hos_id) references m_hos(hos_id)