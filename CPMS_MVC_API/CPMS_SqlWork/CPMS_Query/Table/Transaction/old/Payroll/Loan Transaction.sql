USE MFI
GO
--drop table t_loan
create table t_loan
(
tloan_sno int identity(1001,1),
tloan_id int,
tloan_dat datetime,
tloan_amt float,
tloan_ins float,
tloan_insamt float,
tloan_typ char(1),
tloan_st bit,
acc_id char(20),
mvch_typ char(2),
tloan_cb char(1),
tloan_chq int,
mloan_id int,
emppro_id int,
mvch_id char(12)
)

--Constraint
--Not Null
alter table t_loan alter column tloan_id int not null

--Primary key 
alter table t_loan add constraint PK_TLOAN_TLOANID primary key (tloan_id)

--Foreign key
alter table t_loan add constraint FK_TLOAN_MLOANID foreign key (mloan_id) references m_loan(mloan_id)
alter table t_loan add constraint FK_TLOAN_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)

