USE MFI
GO

--drop table t_adv
create table t_adv
(
adv_sno int identity(1001,1),
adv_id int,
adv_dat datetime,
adv_amt float,
emppro_id int,
dcus_id int,
drv_id int,
adv_typ char(1),
mvch_id char(12)
)

--Constraint
--Not Null
alter table t_adv alter column adv_id int not null

--Primary key 
alter table t_adv add constraint PK_TADV_ADVID primary key (adv_id)

--Foreign key
alter table t_adv add constraint FK_TADV_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)
