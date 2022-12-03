USE ZSons
GO
--drop table m_stdcat

create table m_stdcat
(
stdcat_sno int identity(1001,1),
stdcat_id int,
stdcat_nam char(25),
stdcat_typ char(1),
stdcat_act bit,
stdcatmas_id int
)

--Constraint 
--Not Null
alter table m_stdcat alter column stdcat_id int not null

--Primary Key
alter table m_stdcat add constraint PK_Mstdcat_stdcatID primary key (stdcat_id)

--Foreign key
alter table m_stdcat add constraint FK_MSTDCAT_STDCATMASID foreign key (stdcatmas_id) references m_stdcatmas(stdcatmas_id)