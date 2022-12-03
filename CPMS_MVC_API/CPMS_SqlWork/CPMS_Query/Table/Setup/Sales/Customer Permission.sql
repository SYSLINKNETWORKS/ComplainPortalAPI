USE ZSONS
GO

create table m_cusper
(
cusper_sno int identity(1001,1),
cusper_id int,
cusper_view bit,
cusper_new bit,
cusper_upd bit,
cusper_del bit,
cusper_print bit,
cusper_tax bit,
cus_id int,
men_id int
)

--Constraint
--Not Null
alter table m_cusper alter column cusper_id int not null

--Primary Key
alter table m_cusper add constraint PK_mcusper_cuspertid primary key (cusper_id)
 
 --foreign key
alter table m_cusper add constraint PK_mcusper_cusid foreign key (cus_id) references m_cus(cus_id)
alter table m_cusper add constraint PK_mcusper_menid foreign key (men_id) references m_men(men_id)

