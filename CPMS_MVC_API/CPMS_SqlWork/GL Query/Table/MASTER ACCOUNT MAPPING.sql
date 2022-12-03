use PAGEY
go
--drop table gl_m_acc_master

create table gl_m_acc_master
(
com_id char(2),
br_id char(3),
accmaster_sno int identity(1001,1),
accmaster_id int,
accmaster_nam varchar(250),
accmaster_act bit,
accmaster_no int,
accmaster_cno int,
accmaster_typ char(1)
)

--Constraint
--Not NULL
alter table gl_m_acc_master alter column accmaster_id int not null
alter table gl_m_acc_master alter column accmaster_no int not null
alter table gl_m_acc_master alter column accmaster_cno int not null

--Primary key
alter table gl_m_acc_master add constraint PK_MACCMASTER_MACCMASTERID primary key (accmaster_id)

--Foreign key
alter table gl_m_acc_master add constraint FK_MACCMASTER_COMID_ACCMASTERNO foreign key (com_id,accmaster_no) references gl_m_acc (com_id,acc_no)
alter table gl_m_acc_master add constraint FK_MACCMASTER_COMID_LACCMASTERCNO foreign key (com_id,accmaster_cno) references gl_m_acc(com_id,acc_no)

--Unique 
alter table gl_m_acc_master add constraint QU_MACCMASTER_ACCMASTERNAME unique (accmaster_nam)

alter table gl_m_acc_master drop constraint FK_MACCMASTER_COMID_ACCMASTERNO 
alter table gl_m_acc_master drop constraint FK_MACCMASTER_COMID_LACCMASTERCNO 
