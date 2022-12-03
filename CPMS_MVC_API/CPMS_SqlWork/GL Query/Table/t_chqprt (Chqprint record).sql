--drop table t_chqprt
--	select * from t_chqprt

create table t_chqprt
(
chqprt_sno int identity(1001,1),
chqprt_id int,
chqprt_dat datetime,
chqprt_pay varchar(1000),
chqprt_payee bit,
chqprt_typ char(1),
bk_id char(2),
chq_no float
)

--Constraint
--Not Null
alter table t_chqprt alter column chqprt_id int not null

--Primary key
alter table t_chqprt add constraint PK_TCHQPRT_CQTPRTID primary key (chqprt_id)

--Foreign key
alter table t_chqprt add constraint FK_TCHQPRT_BKID foreign key (bk_id) references gl_m_bk (bk_id)