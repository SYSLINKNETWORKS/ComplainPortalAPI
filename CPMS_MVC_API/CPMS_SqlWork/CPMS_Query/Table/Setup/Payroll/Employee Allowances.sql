USE MFI
GO

--drop table m_empall
create table m_empall
(
empall_sno int identity(1001,1),
empall_id int,
emppro_id int,
all_id int
)

--Not Null
alter table m_empall alter column empall_id int not null
alter table m_empall alter column all_id int not null
alter table m_empall alter column emppro_id int not null

--Primary key 
alter table m_empall add constraint PK_MEMPALL_EMPALLID primary key (empall_id)


--Foreign key
alter table m_empall add constraint FK_MEMPALL_ALLID foreign key (all_id) references m_all (all_id)
alter table m_empall add constraint FK_MEMPALL_EMPPROID foreign key (emppro_id) references m_emppro (emppro_id)
