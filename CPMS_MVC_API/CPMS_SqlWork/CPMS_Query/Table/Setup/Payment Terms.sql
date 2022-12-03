USE ZSONS
GO
--alter table t_pat drop constraint FK_TPAT_PATID
--drop table m_pat
--Item Brand
create table m_pat
(
pat_sno	int identity(1001,1),
pat_id	int,
pat_nam	varchar(1000),
pat_act	bit,
pat_typ char(1),
com_id char(2),
br_id char(3)
)

--Constraint
--Not Null
alter table m_pat alter column pat_id int not null

--Primary Key
alter table m_pat add constraint PK_Mpat_patID primary key (pat_id)

