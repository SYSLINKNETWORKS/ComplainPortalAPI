USE MFI
GO
--drop table m_chlbk
----Challan Book
create table m_chlbk
(
com_id char(2),
br_id char(3),
chlbk_sno int identity(1001,1),
chlbk_no int,
chlbk_act bit,
chlbk_typ char(1),
chlbk_lev int,
chlbk_str_no int,
chlbk_rmk varchar(250),
dpt_id char(2)
)
--Constraint
--Not Null
alter table m_chlbk alter column chlbk_no int not null

--Primary key
alter table m_chlbk add constraint PK_CHLBK_CHLBKNO primary key (chlbk_no)

--Foreign key
alter table m_chlbk add constraint FK_CHLBK_DPTID foreign key (dpt_id) references m_dpt (dpt_id)
