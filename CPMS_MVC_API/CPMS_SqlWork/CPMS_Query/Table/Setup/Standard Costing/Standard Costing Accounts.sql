USE MFI
GO

--drop table m_scacc


create table m_scacc
(
scacc_sno int identity(1001,1),
scacc_id int,
scacc_typ char(1),
scacc_act bit,
sccat_id int,
acc_id char(20)
)

--Constraint 
--Not Null
alter table m_scacc alter column scacc_id int not null

--Primary Key
alter table m_scacc add constraint PK_Mscacc_scaccID primary key (scacc_id)

--Foreign key
alter table m_scacc add constraint FK_MSCACC_SCACATID foreign key (sccat_id) references m_sccat(sccat_id)
alter table m_scacc add constraint FK_MSCACC_ACCID foreign key (acc_id) references gl_m_acc(acc_id)
