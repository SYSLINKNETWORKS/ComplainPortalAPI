USE zsons
GO


--Master Bonus

create table t_mbonus
(
mbonus_sno int identity(1001,1),
mbonus_id int,
mbonus_dat datetime,
mbonus_mdat datetime,
m_yr_id char(2),
mbonus_typ char(1)
)

--Constraint
--Not Null
alter table t_mbonus alter column mbonus_id int not null

--Primary key
alter table t_mbonus add constraint PK_t_mbonus_t_mbonusID primary key (mbonus_id)

GO


--Detail Bonus

create table t_dbonus
(
dbonus_sno int identity(1001,1),
dbonus_id int,
emppro_macid int,
dbonus_sal float,
dbonus_bonper float,
dbonus_bonamt float,
mbonus_id int,
dbonus_typ char(1)
)

--Constraint
--Not Null
alter table t_dbonus alter column dbonus_id int not null

--Primary key
alter table t_dbonus add constraint PK_t_dbonus_t_dbonusID primary key (dbonus_id)


--Foreign Key
alter table t_dbonus add constraint FK_m_bonus_bonusID foreign key (mbonus_id) references t_mbonus(mbonus_id)
