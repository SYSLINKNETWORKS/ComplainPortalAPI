Use meiji_rusk
go
--drop table m_conrat 

create table m_conrat
(
conrat_sno	int identity(1001,1),
conrat_id	int,
conrat_dat datetime,
conrat_act	bit,
conrat_typ char(1),
conrat_rat float,
con_id int
)

--Constraint
--Not Null
alter table m_conrat alter column conrat_id int not null

--Primary Key
alter table m_conrat add constraint PK_Mconrat_conratID primary key (conrat_id)

--Foreign Key
alter table m_conrat add constraint FK_MCONRAT_CONID foreign key (con_id) references m_con(con_id)
