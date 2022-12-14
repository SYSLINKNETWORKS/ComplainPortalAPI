USE MFI
GO

--drop table t_mdptot
create table t_mdptot
(
mdptot_sno int identity(1001,1),
mdptot_id int,
mdptot_dat datetime,
mdptot_hrs float,
mdptot_min as case mdptot_hrs when 0 then 0 else mdptot_hrs*60 end,
memppro_sub_id int,
mdptot_typ char(1)
)

--Constraint
--Not Null
alter table t_mdptot alter column mdptot_id int not null

--Primary key 
alter table t_mdptot add constraint PK_tmdptot_mdptotID primary key (mdptot_id)

--Foreign key
alter table t_mdptot add constraint FK_tmdptot_mempsubID foreign key (memp_sub_id) references m_emp_sub(memp_sub_id)

