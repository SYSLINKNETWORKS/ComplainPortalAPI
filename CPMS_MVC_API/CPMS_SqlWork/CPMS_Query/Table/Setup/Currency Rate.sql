--alter table m_currat add currat_sht float,currat_cat char(1)
--drop table m_currat

create table m_currat
(
currat_sno int identity(1001,1),
currat_id int,
currat_dat datetime,
cur_id int,
currat_rat float,
currat_typ char(1)
)

--Constraint 
--Not Null
alter table m_currat alter column currat_id int not null

--Primary Key
alter table m_currat add constraint PK_Mcurrat_curratID primary key (currat_id)

--Foreign key
alter table m_currat add constraint FK_MCURRAT_CURID foreign key (cur_id) references m_cur(cur_id)
