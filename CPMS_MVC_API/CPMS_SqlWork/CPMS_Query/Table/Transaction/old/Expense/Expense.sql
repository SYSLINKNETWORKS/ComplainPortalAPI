USE PAGEY
GO


--Expense Transaction

create table t_mexp
(
mexp_sno int identity(1001,1),
mexp_id int,
mexp_dat datetime
lc_id int
)

--Constraint
--Not Null
alter table t_mexp alter column mexp_id int not null

--Primary key 
alter table t_mexp add constraint PK_tmexp_mexpID primary key (mexp_id)


--Foreign key
alter table t_mexp add constraint FK_TMEXP_LCID foreign key (lc_id) references m_lc (lc_id)

