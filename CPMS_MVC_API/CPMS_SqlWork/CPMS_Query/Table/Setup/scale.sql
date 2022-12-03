--alter table m_sca add sca_sht float,sca_cat char(1)
--drop table m_sca

create table m_sca
(
sca_sno int identity(1001,1),
sca_id int,
sca_nam char(25),
sca_typ char(1)
)

--Constraint 
--Not Null
alter table m_sca alter column sca_id int not null

--Primary Key
alter table m_sca add constraint PK_MSCA_SCAID primary key (sca_id)
