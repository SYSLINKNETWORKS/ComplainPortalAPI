USE PHM
GO

--DROP TABLE m_termres
create table m_termres
(
mtermres_sno int identity(1001,1),
mtermres_id int,
mtermres_nam varchar(250),
mtermres_typ char(1),
com_id char(2),
br_id char(3)
)

--Constraint
--Not Null
alter table m_termres alter column mtermres_id int not null

--Primary key
alter table m_termres add constraint PK_Mtermres_MtermresID primary key (mtermres_id)

--Forign key 
alter table m_termres add constraint FK_MTERMRES_COMID foreign key (com_id) references m_com(com_id)
alter table m_termres add constraint FK_MTERMRES_brID foreign key (br_id) references m_br(br_id)

