--alter table m_cur add cur_sht float,cur_cat char(1)
--drop table m_cur

create table m_cur
(
cur_sno int identity(1001,1),
cur_id int,
cur_nam char(250),
cur_snm char(10),
cur_typ char(1)
)

--Constraint 
--Not Null
alter table m_cur alter column cur_id int not null

--Primary Key
alter table m_cur add constraint PK_Mcur_curID primary key (cur_id)
