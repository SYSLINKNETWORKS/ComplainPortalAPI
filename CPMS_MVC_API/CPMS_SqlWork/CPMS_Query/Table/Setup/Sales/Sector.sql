use MEIJI
go

create table m_sec
(
sec_sno     int identity(1001,1),
sec_id		int,
sec_nam		varchar(100),
sec_typ		char(1),
sec_act		bit
) 
----Constraints
--Not Null
alter table m_sec alter column sec_id int not null

--Primary Key
alter table m_sec add constraint PK_MSEC_SECID primary key (sec_id)