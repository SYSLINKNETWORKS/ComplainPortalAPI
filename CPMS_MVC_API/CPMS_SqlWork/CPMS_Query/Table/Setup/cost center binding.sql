USE ZSons
GO

--drop table m_dcs
--drop table m_mcs

--Master
create table m_mcs
(
mcs_sno int identity(1001,1),
mcs_id int,
mcs_dat datetime,
mcs_typ char(1),
mcs_act bit,
acc_id char(20),
com_id char(2),
br_id char(3)
)

--Constraint 
--Not Null
alter table m_mcs alter column mcs_id int not null
alter table m_mcs alter column com_id char(2) not null
alter table m_mcs alter column br_id char(3) not null

--Primary Key
alter table m_mcs add constraint PK_Mcs_DcsID primary key (mcs_id)
  
--Foreign key
alter table m_mcs add constraint FK_mcs_ACCID foreign key (acc_id) references gl_m_acc(acc_id)


--Detail
create table m_dcs
(
dcs_sno int identity(1001,1),
dcs_id int,
dcs_per float,
cs_id int,
mcs_id int
)

--Constraint 
--Not Null
alter table m_dcs alter column dcs_id int not null

--Primary Key
alter table m_dcs add constraint PK_Dcs_DcsID primary key (Dcs_id)
  
--Foreign key
alter table m_dcs add constraint FK_dcs_csID foreign key (cs_id) references m_cs(cs_id)
alter table m_dcs add constraint FK_dcs_McsID foreign key (mcs_id) references m_mcs(mcs_id)

