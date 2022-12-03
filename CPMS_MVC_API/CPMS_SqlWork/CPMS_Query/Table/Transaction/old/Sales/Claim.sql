use nathi
go

Create table t_mclaim
(
mclaim_sno int identity(1001,1),
mclaim_id	int,
mclaim_dat datetime,
mclaim_recfrm varchar(250),
mclaim_typ char(1),
m_yr_id char(2),
com_id char(2),
br_id char(3)
)

--Constraint
--Not null
alter table t_mclaim alter column mclaim_id int not null
alter table t_mclaim alter column m_yr_id char(2) not null

--Primary
alter table t_mclaim add constraint PK_mclaim_mclaimID primary key (mclaim_id)

--Foreign key
alter table t_mclaim add constraint FK_MCLAIM_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)


create table t_dclaim
(
dclaim_sno int identity (1001,1),
dclaim_id int,
dclaim_qtyrec float,
dclaim_qtyiss float,
titm_id_rec int,
titm_id_iss int,
mclaim_id int
)



--Constraint
--Not null
alter table t_dclaim alter column dclaim_id int not null

--Primary
alter table t_dclaim add constraint PK_dclaim_PRID primary key (dclaim_id)

--Foreign Key
alter table t_dclaim add constraint FK_dclaim_mclaim foreign key (mclaim_id) references t_mclaim (mclaim_id)
alter table t_dclaim add constraint FK_dclaim_TITMIDREC foreign key (titm_id_rec) references t_itm (titm_id)
alter table t_dclaim add constraint FK_dclaim_TITMIDISS foreign key (titm_id_iss) references t_itm (titm_id)


