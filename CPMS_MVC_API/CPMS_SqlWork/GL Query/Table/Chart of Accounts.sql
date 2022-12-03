USE [zsons]
GO
CREATE TABLE gl_m_acc
(
	s_no int IDENTITY(1001,1) NOT NULL,
	acc_id char(20) NOT NULL,
	acc_no int NULL,
	acc_nam varchar(100) NULL,
	acc_cid varchar(20) NULL,
	acc_lvl int NULL,
	acc_dm char(1) NOT NULL DEFAULT ('M'),
	acc_typ char(1) NOT NULL DEFAULT ('U'),
	acc_des nvarchar(4000) NULL,
	com_id char(2) NULL,
	br_id char(3) NULL,
	cur_id int NULL,
	acc_oid varchar(20) NULL,
	acc_act bit,
	acc_del bit
)

--Constraint 
--Not Null
alter table gl_m_acc alter column acc_no int not null
alter table gl_m_acc alter column acc_id char(20) not null
alter table gl_m_acc alter column com_id char(2) not null
alter table gl_m_acc alter column br_id char(3) not null

--Primary Key
alter table gl_m_acc add constraint PK_GLMACC_COMID_BRID_ACCNO primary key (com_id,br_id,acc_no)

--Unique
alter table gl_m_acc add constraint UNQ_ACCNAM_ACCCID unique (acc_nam,acc_cid)

--Check
alter table gl_m_acc add constraint ck_acc_dm check (acc_dm='D' or acc_dm='M')
alter table gl_m_acc add constraint ck_acc_typ check (acc_dm='S' or acc_dm='U')

--Foreign key
alter table gl_m_acc add constraint FK_GLMACC_COMID foreign key (com_id) references m_com(com_id)
alter table gl_m_acc add constraint FK_GLMACC_BRID foreign key (br_id) references m_br(br_id)




