USE MFI
GO
--drop table t_rec_loan
create table t_rec_loan
(
trec_sno int identity(1001,1),
trec_id int,
trec_dat datetime,
trec_amt float,
trec_typ char(1),
tloan_id int,
acc_id char(20),
mvch_typ char(2),
trec_cb char(1),
trec_chq int,
mvch_id char(12)
)

--Constraint
--Not Null
alter table t_rec_loan alter column trec_id int not null

--Primary key 
alter table t_rec_loan add constraint PK_Trec_TrecID primary key (trec_id)

--Foreign key
alter table t_rec_loan add constraint FK_Trec_TloanID foreign key (tloan_id) references t_loan(tloan_id)
