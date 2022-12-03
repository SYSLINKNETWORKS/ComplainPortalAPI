USE PAGEY
GO

--Expense Transaction Detail
create table t_dexp
(
dexp_sno int identity(1001,1),
dexp_id int,
dexp_amt int
mexp_id int,
exp_id int
)

--Constraint
--Not Null
alter table t_dexp alter column dexp_id int not null

--Primary key 
alter table t_dexp add constraint PK_tdexp_dexpID primary key (dexp_id)


--Foreign key
alter table t_dexp add constraint FK_EXP_MEXPID foreign key (mexp_id) references t_mexp (mexp_id)
alter table t_dexp add constraint FK_EXP_EXPID foreign key (exp_id) references m_exp (exp_id)

