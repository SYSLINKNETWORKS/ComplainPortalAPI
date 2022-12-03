USE MFI
Go

--drop table t_ddptot
create table t_ddptot
(
ddptot_sno int identity(1001,1),
ddptot_id int,
ddptot_dat datetime,
ddptot_min float,
ddptot_typ char(1),
emppro_id int
)

--Constraint
--Not Null
alter table t_ddptot alter column ddptot_id int not null

--Primary key 
alter table t_ddptot add constraint PK_tddptot_ddptotID primary key (ddptot_id)

--Foreign key
alter table t_ddptot add constraint FK_tddptot_empproID foreign key (emppro_id) references m_emppro(emppro_id)

--SELECT * from t_ddptot
--insert into t_ddptot (ddptot_id,ddptot_dat,ddptot_min,ddptot_typ,emppro_id)
--values (1,'02/11/2013',400,'U',61)
--select * from m_emppro where emppro_macid=279
--select * from t_ddptot
--update t_ddptot set ddptot_min=100 where emppro_id=61


