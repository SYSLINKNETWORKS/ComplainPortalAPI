USE MFI
GO
--DROP TABLE m_loan
create table m_loan
(
mloan_sno int identity(1001,1),
mloan_id int,
mloan_nam varchar(250),
mloan_typ char(1)
)

--Constraint
--Not Null
alter table m_loan alter column mloan_id int not null

--Primary key
alter table m_loan add constraint PK_MLOAN_MLOANID primary key (mloan_id)

