USE PHM
GO


create table m_coun
(
coun_sno int identity(1001,1),
coun_id int,
coun_nam char(25),
coun_act bit,
coun_typ char(1)
)

--Constraint 
--Not Null
alter table m_coun alter column coun_id int not null

--Primary Key
alter table m_coun add constraint PK_Mcoun_counID primary key (coun_id)
