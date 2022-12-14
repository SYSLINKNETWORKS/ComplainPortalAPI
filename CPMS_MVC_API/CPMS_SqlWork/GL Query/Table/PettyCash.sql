USE ZSons
GO
--drop table gl_m_pc


CREATE table gl_m_pc
(
pc_sno int identity(1001,1),
pc_id int,
pc_typ char(1),
acc_no_cash int,
acc_no int,
com_id char(2),
br_id char(3)
)

--Not Null
alter table gl_m_pc alter column pc_id int not null

--Primary key
alter table gl_m_pc add constraint PK_GLMPC_PCID primary key (pc_id)

--Foreign key
alter table gl_m_pc add constraint FK_GLMPC_COMID foreign key (com_id) references m_com(com_id)
alter table gl_m_pc add constraint FK_GLMPC_BRID foreign key (br_id) references m_br(br_id)
alter table gl_m_pc add constraint FK_GLMPC_ACCNO foreign key (com_id,acc_no) references gl_m_acc (com_id,acc_no)
alter table gl_m_pc add constraint FK_GLMPC_ACCNOCASH foreign key (com_id,acc_no_cash) references gl_m_acc (com_id,acc_no)
